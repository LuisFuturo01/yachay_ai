from firebase_admin import firestore

# Inicializamos el cliente aquí también o lo importamos
# Asumiendo que firebase_admin ya se inicializó en main.py
db = firestore.client()

def obtener_o_crear_usuario(datos_usuario: dict):
    # Referencia al documento del usuario
    ref = db.collection("users").document(datos_usuario["uid"])
    doc = ref.get()
    
    if not doc.exists:
        # Si no existe, creamos el perfil inicial
        ref.set({
            "name": datos_usuario.get("name", "Nuevo Estudiante"),
            "avatarId": datos_usuario.get("avatarId", "avatar_default"),
            "totalPoints": 0,
            "achievements": [],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "lastActive": firestore.SERVER_TIMESTAMP
        })
        return {"estado": "creado"}
    else:
        # Si ya existe, solo actualizamos su última fecha de conexión
        ref.update({"lastActive": firestore.SERVER_TIMESTAMP})
        return {"estado": "sesion_iniciada"}
def actualizar_progreso_materia(datos_progreso: dict):
    # Subcolección: /users/{userId}/progress/{subjectId}
    db.collection("users").document(datos_progreso["userId"]) \
      .collection("progress").document(datos_progreso["subjectId"]) \
      .set({
          "currentLevel": datos_progreso["currentLevel"],
          "maxLevelReached": datos_progreso["maxLevelReached"],
          "completedLessonsCount": datos_progreso["completedLessonsCount"],
          "lastUpdated": firestore.SERVER_TIMESTAMP
      }, merge=True) # merge=True actualiza sin borrar otros campos

def registrar_sesion_juego(datos_sesion: dict):
    # Subcolección: /users/{userId}/sessions/{sessionId}
    db.collection("users").document(datos_sesion["userId"]) \
      .collection("sessions").document(datos_sesion["sessionId"]) \
      .set({
          "subjectId": datos_sesion["subjectId"],
          "level": datos_sesion["level"],
          "status": datos_sesion["status"],
          "correctAnswers": datos_sesion["correctAnswers"],
          "totalQuestions": datos_sesion["totalQuestions"],
          "pointsEarned": datos_sesion["pointsEarned"],
          "startedAt": firestore.SERVER_TIMESTAMP,
          "completedAt": firestore.SERVER_TIMESTAMP
      })

def guardar_mensaje_chat(datos_chat: dict):
    # Subcolección: /users/{userId}/sessions/{sessionId}/chats/{messageId}
    # Usamos add() al final para que genere el ID del mensaje automáticamente
    db.collection("users").document(datos_chat["userId"]) \
      .collection("sessions").document(datos_chat["sessionId"]) \
      .collection("chats").add({
          "text": datos_chat["text"],
          "isUser": datos_chat["isUser"],
          "type": datos_chat["type"],
          "audioPath": datos_chat["audioPath"],
          "timestamp": firestore.SERVER_TIMESTAMP
      })