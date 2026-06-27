from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests
import json
import os
from typing import List, Optional
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
load_dotenv()
# 1. ¡PRIMERO INICIALIZAMOS FIREBASE! (El orden es clave)
cred = credentials.Certificate("firebase_credenciales.json")
# Si ya está inicializada, evitamos que lance error al recargar uvicorn
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

# 2. AHORA SÍ, importamos las funciones de database.py
from database import (
    obtener_o_crear_usuario, 
    actualizar_progreso_materia, 
    registrar_sesion_juego,
    guardar_mensaje_chat
)

# 3. Inicializamos el cliente de Firestore para main.py
db = firestore.client()

# Inicializamos la aplicación FastAPI
app = FastAPI(title="Yachay AI - Backend")

# Permitir conexiones desde cualquier origen
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Función auxiliar para leer los archivos .md
def leer_prompt(ruta_archivo):
    """Lee el archivo .md desde la carpeta Prompt_Library"""
    try:
        with open(ruta_archivo, 'r', encoding='utf-8') as archivo:
            return archivo.read()
    except FileNotFoundError:
        print(f"Advertencia: No se encontró el prompt en {ruta_archivo}")
        return ""

# --- MODELOS DE DATOS (FASE 1: DISEÑO NOSQL) ---

# 1. Modelo para la Colección Raíz: /users
class UsuarioPerfil(BaseModel):
    uid: str
    name: str
    avatarId: str
    totalPoints: int = 0
    achievements: List[str] = []

# 2. Modelo para la Subcolección: /users/{userId}/progress
class ProgresoMateria(BaseModel):
    userId: str # Requerido por el backend para saber la ruta
    subjectId: str
    currentLevel: int
    maxLevelReached: int
    completedLessonsCount: int

# 3. Modelo para la Subcolección: /users/{userId}/sessions
class SesionJuego(BaseModel):
    userId: str # Requerido por el backend para saber la ruta
    sessionId: str
    subjectId: str
    level: int
    status: str
    correctAnswers: int
    totalQuestions: int
    pointsEarned: int

# 4. Modelo para la Subcolección de historial de Chat
class MensajeChat(BaseModel):
    userId: str
    sessionId: str
    text: str
    isUser: bool
    type: str
    audioPath: Optional[str] = None

# 5. ACTUALIZACIÓN CLAVE: El puente con la IA
# Ahora Flutter debe enviarte los IDs para que tú mismo guardes el chat 
# en la base de datos después de que Gemini responda.
class ConsultaEstudiante(BaseModel):
    userId: str
    sessionId: str
    mensaje: str
    materia: str
    nivel: str

# --- RUTAS (ENDPOINTS) ---
@app.get("/")
def read_root():
    return {"mensaje": "Servidor de Yachay AI funcionando correctamente en Firebase"}

@app.post("/api/tutor")
def consultar_tutor(consulta: ConsultaEstudiante):
    try:
        # --- PASO A: GUARDAR EL MENSAJE DEL ESTUDIANTE ---
        guardar_mensaje_chat({
            "userId": consulta.userId,
            "sessionId": consulta.sessionId,
            "text": consulta.mensaje,
            "isUser": True,
            "type": "normal", 
            "audioPath": None
        })

        # --- PASO B: PREPARAR EL CONTEXTO PARA GEMINI ---
        prompt_sys = leer_prompt("Prompt_Library/01_System_Prompt/01_System_Prompt.md")
        materia = consulta.materia.lower()
        prompt_materia = ""
        prompt_json = ""

        # Enrutador Dinámico de Materias
        if "matem" in materia:
            prompt_materia = leer_prompt("Prompt_Library/02_Matematica/MAT-02_Correccion_Inteligente.md")
            prompt_json = leer_prompt("Prompt_Library/06_JSON/JSON-01_Matematica.md")
        elif "aymara" in materia:
            prompt_materia = leer_prompt("Prompt_Library/03_Aymara/AYM-01_Generacion_Audios.md")
            prompt_json = leer_prompt("Prompt_Library/06_JSON/JSON-02_Aymara.md")
        elif "naturales" in materia:
            prompt_materia = leer_prompt("Prompt_Library/04_Ciencias_Naturales/NAT-02_Correccion_Inteligente.md")
            prompt_json = leer_prompt("Prompt_Library/06_JSON/JSON-03_Ciencias_Naturales.md")
        elif "sociales" in materia:
            prompt_materia = leer_prompt("Prompt_Library/05_Ciencias_Sociales/SOC-02_Correccion_Inteligente.md")
            prompt_json = leer_prompt("Prompt_Library/06_JSON/JSON-04_Ciencias_Sociales.md")

        instruccion_completa = f"""
        --- IDENTIDAD Y REGLAS MAESTRAS ---
        {prompt_sys}
        --- REGLAS ESPECÍFICAS DE LA TAREA ---
        {prompt_materia}
        --- ESTRUCTURA DE RESPUESTA OBLIGATORIA ---
        {prompt_json}
        """
        
        pregunta_armada = f"Nivel: {consulta.nivel}\nMensaje/Respuesta del estudiante: {consulta.mensaje}"
        
        # --- PASO C: COMUNICACIÓN CON LA IA ---
        API_KEY = os.getenv("GEMINI_API_KEY") 
        
        if not API_KEY:
            return {"estado": "error", "detalles": "Falta configurar GEMINI_API_KEY en el entorno"}
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key={API_KEY}"
        
        payload = {
            "system_instruction": {"parts": [{"text": instruccion_completa}]},
            "contents": [{"parts": [{"text": pregunta_armada}]}],
            "generationConfig": {
                "temperature": 0.3,
                "responseMimeType": "application/json"
            }
        }
        
        respuesta_http = requests.post(url, json=payload)
        datos_json = respuesta_http.json()
        # NUEVO: Escudo protector. Verificamos si Google nos rechazó la petición
        if "error" in datos_json:
            print(f"Error de la API de Google: {datos_json['error']}")
            return {"estado": "error", "detalles": "Google API rechazó la solicitud", "google_error": datos_json["error"]}
        
        # Si no hay error, extraemos el texto normalmente
        texto_ia = datos_json["candidates"][0]["content"]["parts"][0]["text"]

        # --- PASO D: PROCESAR, GUARDAR Y RESPONDER ---
        respuesta_formateada = json.loads(texto_ia)
        
        mensaje_tutor = respuesta_formateada.get("mensaje", "Yachay ha respondido.")
        
        contenido = respuesta_formateada.get("contenido", {})
        es_correcto = contenido.get("correcto", False)
        tipo_mensaje = "correct" if es_correcto else "hint"
        
        guardar_mensaje_chat({
            "userId": consulta.userId,
            "sessionId": consulta.sessionId,
            "text": mensaje_tutor,
            "isUser": False, 
            "type": tipo_mensaje,
            "audioPath": None
        })
        
        return respuesta_formateada
            
    except Exception as e:
        print(f"Error procesando tutoría: {e}")
        return {"estado": "error", "detalles": str(e)}
    
# --- RUTAS DE BASE DE DATOS ---

@app.post("/api/usuarios")
def api_crear_usuario(perfil: UsuarioPerfil):
    try:
        # Llamamos a la nueva función robusta
        resultado = obtener_o_crear_usuario(perfil.dict())
        
        # Devolvemos un mensaje dinámico basado en la acción realizada
        if resultado["estado"] == "creado":
            return {"estado": "Usuario creado exitosamente", "accion": "bienvenida"}
        else:
            return {"estado": "Sesión iniciada correctamente", "accion": "continuar"}
            
    except Exception as e:
        return {"estado": "Error al procesar usuario", "detalles": str(e)}
    
@app.post("/api/login")
def api_login(perfil: UsuarioPerfil):
    try:
        resultado = obtener_o_crear_usuario(perfil.dict())
        return {"estado": "exitoso", "accion": resultado["estado"]}
    except Exception as e:
        return {"estado": "error", "detalles": str(e)}

@app.post("/api/progreso")
def api_actualizar_progreso(progreso: ProgresoMateria):
    try:
        actualizar_progreso_materia(progreso.dict())
        return {"estado": "Progreso actualizado"}
    except Exception as e:
        return {"estado": "Error actualizando progreso", "detalles": str(e)}

@app.post("/api/sesiones")
def api_registrar_sesion(sesion: SesionJuego):
    try:
        registrar_sesion_juego(sesion.dict())
        return {"estado": "Sesión registrada correctamente"}
    except Exception as e:
        return {"estado": "Error al registrar sesión", "detalles": str(e)}