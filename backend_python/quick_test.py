import os
import json
import requests
from dotenv import load_dotenv

# Cargar variables de entorno desde el archivo .env de backend_python
load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    print("❌ Error: GEMINI_API_KEY no encontrada en el archivo .env.")
    print("Asegúrate de tener un archivo .env con la variable GEMINI_API_KEY=tu_api_key")
    exit(1)

model = "gemini-3.5-flash"
url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"

payload = {
    "contents": [
        {
            "parts": [
                {
                    "text": "Hola, responde con un saludo corto en español indicando que eres Yachay."
                }
            ]
        }
    ],
    "generationConfig": {
        "temperature": 0.5
    }
}

print("=" * 60)
print(f"📡 Enviando saludo rápido a {model}...")
print("=" * 60)

try:
    response = requests.post(
        url,
        headers={"Content-Type": "application/json"},
        data=json.dumps(payload),
        timeout=30
    )
    
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 200:
        res_json = response.json()
        try:
            texto_respuesta = res_json["candidates"][0]["content"]["parts"][0]["text"].strip()
            print("\n🎉 Respuesta recibida exitosamente:")
            print(f"👉 {texto_respuesta}\n")
            print("✅ ¡La conexión con Gemini 3.5 Flash está funcionando perfectamente!")
        except Exception as e:
            print(f"⚠️ Estructura JSON inesperada: {e}")
            print(f"Respuesta cruda:\n{json.dumps(res_json, indent=2)}")
    else:
        print(f"❌ Error de respuesta (HTTP {response.status_code}):")
        print(response.text)

except Exception as e:
    print(f"❌ Error de red/conexión: {e}")
