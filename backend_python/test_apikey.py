"""
Script para verificar si tu API Key de Gemini es válida.
Ejecuta: python test_apikey.py
"""
import os
import requests
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("GEMINI_API_KEY", "")

print("=" * 60)
print("     VERIFICADOR DE API KEY - GEMINI / GOOGLE AI STUDIO")
print("=" * 60)
print(f"API Key: '{api_key[:15]}...{api_key[-5:]}'" if len(api_key) > 15 else f"API Key: '{api_key}'")
print(f"Longitud de la key: {len(api_key)} caracteres")

# Validación básica del formato
if not api_key:
    print("\n❌ ERROR: No hay API key en el archivo .env")
    print("   Agrega: GEMINI_API_KEY=tu_clave_aqui")
    exit(1)

if api_key.startswith("AIza"):
    print("✅ Formato de API Key parece correcto (empieza con AIza)")
elif api_key.startswith("AQ."):
    print("⚠️  ADVERTENCIA: Tu key empieza con 'AQ.' — esto parece un token de")
    print("   Firebase App Check o un token temporal, NO una API key de Gemini.")
    print("   Las API keys de Google AI Studio empiezan con 'AIza...'")
    print("\n   👉 Ve a https://aistudio.google.com/apikey para obtener una clave correcta.")
else:
    print(f"⚠️  Formato desconocido. Las API keys de Gemini empiezan con 'AIza...'")

# Probar listando modelos disponibles
print("\n📡 Probando conexión: listando modelos disponibles...")
url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"

try:
    response = requests.get(url, timeout=10)
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        models = data.get("models", [])
        print(f"\n✅ ¡CONEXIÓN EXITOSA! Se encontraron {len(models)} modelos disponibles.\n")
        
        # Mostrar modelos flash relevantes
        flash_models = [m["name"] for m in models if "flash" in m.get("name", "").lower()]
        print("Modelos Flash disponibles:")
        for m in flash_models[:10]:
            print(f"  • {m}")
    elif response.status_code == 400:
        print("\n❌ ERROR 400: API Key con formato inválido.")
        print("   Tu key no es reconocida como una API key válida de Google.")
        print("   👉 Ve a https://aistudio.google.com/apikey")
    elif response.status_code == 401:
        print("\n❌ ERROR 401: API Key no autorizada.")
        print("   La key fue revocada o es incorrecta.")
    elif response.status_code == 403:
        print("\n❌ ERROR 403: API Key sin permisos.")
        print("   Verifica que la API de Generative Language esté habilitada.")
    else:
        print(f"\n❌ Error inesperado: {response.text}")
        
except requests.exceptions.ConnectionError:
    print("❌ Error de conexión. Verifica tu internet.")
except Exception as e:
    print(f"❌ Error: {e}")
