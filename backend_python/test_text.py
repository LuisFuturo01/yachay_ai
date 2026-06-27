import os
import sys
import json
import requests
from dotenv import load_dotenv

# Cargar variables de entorno del archivo .env
load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    print("❌ Error: GEMINI_API_KEY no encontrada en el archivo .env de backend_python.")
    sys.exit(1)

print("=" * 55)
print("        PROBADOR DE CONEXIÓN TEXTO - GEMINI API")
print("=" * 55)
print(f"API Key: {api_key[:10]}...{api_key[-5:] if len(api_key) > 10 else ''}")

# Modelos a probar (actualizados junio 2026)
models = [
    "gemini-2.0-flash",
    "gemini-2.0-flash-lite",
    "gemini-2.5-flash-preview-05-20",
]

payload = {
    "contents": [
        {
            "parts": [
                {"text": "Hola, ¿puedes responderme? Escribe exactamente: '¡Hola! La API de Gemini está conectada y funcionando con éxito.'"}
            ]
        }
    ]
}

success = False

for model in models:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    print(f"\n📡 Enviando mensaje de prueba a: {model}...")
    
    try:
        response = requests.post(
            url,
            headers={"Content-Type": "application/json"},
            data=json.dumps(payload),
            timeout=10
        )
        
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            res_json = response.json()
            try:
                reply = res_json["candidates"][0]["content"]["parts"][0]["text"].strip()
                print(f"\n🎉 RESPUESTA DE GEMINI:\n\"{reply}\"")
                success = True
                break
            except Exception as e:
                print(f"⚠️ Error al decodificar respuesta JSON: {e}")
                print(f"Respuesta cruda:\n{json.dumps(res_json, indent=2)}")
        else:
            print(f"⚠️ Error de respuesta de Gemini API:\n{response.text}")
            
    except Exception as e:
        print(f"❌ Error de red al conectar: {e}")

if success:
    print("\n✅ La API Key está activa y funcionando correctamente para texto.")
else:
    print("\n❌ Error: No se pudo conectar con éxito con ningún modelo.")
