import os
import sys
import base64
import json
import requests
from dotenv import load_dotenv

# Cargar variables de entorno del archivo .env
load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    print("❌ Error: GEMINI_API_KEY no encontrada en el archivo .env de backend_python.")
    sys.exit(1)

# Verificar soporte de micrófono
try:
    import sounddevice as sd
    import soundfile as sf
    has_mic = True
except ImportError:
    has_mic = False

print("=" * 55)
print("     PROBADOR DE TRANSCRIPCIÓN DE AUDIO - YACHAY AI")
print("=" * 55)
print(f"API Key detectada: {api_key[:10]}...{api_key[-5:] if len(api_key) > 10 else ''}")

# Paso 1: Obtener archivo WAV
wav_filename = "prueba_micro.wav"

if len(sys.argv) > 1:
    wav_filename = sys.argv[1]
    print(f"📁 Usando archivo de audio existente: '{wav_filename}'")
else:
    if not has_mic:
        print("\n❌ No tienes instaladas las librerías necesarias para grabar del micrófono.")
        print("Por favor instálalas ejecutando:")
        print("  pip install sounddevice soundfile requests python-dotenv")
        print("\nO también puedes pasarle un archivo WAV existente por parámetro:")
        print("  python test_transcribe.py ruta/a/tu/archivo.wav")
        sys.exit(1)
        
    print("\n🎤 Preparando grabación del micrófono...")
    print("Asegúrate de estar en un lugar silencioso. La grabación durará 3 segundos.")
    print("Presiona ENTER para comenzar a grabar...")
    input()
    
    sample_rate = 16000
    duration = 3.0  # segundos
    
    print("🔴 GRABANDO... Habla fuerte y claro (di 'Jallalla' o 'Kamisaraki'):")
    # Graba un canal (mono)
    recording = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=1)
    sd.wait()  # Espera a que termine la grabación
    print("⬛ GRABACIÓN FINALIZADA.")
    
    # Guarda en disco
    sf.write(wav_filename, recording, sample_rate)
    print(f"💾 Audio guardado exitosamente en: '{wav_filename}'")

# Paso 2: Leer el archivo WAV y codificar a Base64
try:
    with open(wav_filename, "rb") as f:
        audio_bytes = f.read()
    print(f"📦 Tamaño del archivo leído: {len(audio_bytes)} bytes")
except Exception as e:
    print(f"❌ Error al abrir o leer el archivo {wav_filename}: {e}")
    sys.exit(1)

base64_audio = base64.b64encode(audio_bytes).decode("utf-8")

# Paso 3: Llamar a la API REST de Gemini (Mismo payload que usa Flutter)
models = [
    "gemini-1.5-flash",
    "gemini-1.5-flash-latest",
    "gemini-2.0-flash"
]

target_word = "Jallalla"
print(f"\n🚀 Enviando transcripción a Gemini para la palabra objetivo '{target_word}'...")

payload = {
    "contents": [
        {
            "parts": [
                {
                    "text": f'You are a precise speech-to-text transcriber for children speaking Aymara. The child is trying to pronounce the target word "{target_word}". Listen to the audio and transcribe what they actually pronounced exactly as they said it. Do not correct their pronunciation or spelling. Do not add any punctuation, conversational text, notes, greetings, explanations or markdown formatting. Output only the plain transcribed words. If the audio is silent or unintelligible, reply with the word "{target_word}".'
                },
                {
                    "inlineData": {
                        "mimeType": "audio/wav",
                        "data": base64_audio
                    }
                }
            ]
        }
    ],
    "generationConfig": {
        "temperature": 0.1
    }
}

transcription_success = False

for model in models:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    print(f"\n📡 Conectando con el modelo: {model}...")
    
    try:
        response = requests.post(
            url,
            headers={"Content-Type": "application/json"},
            data=json.dumps(payload),
            timeout=15
        )
        
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            res_json = response.json()
            try:
                transcription = res_json["candidates"][0]["content"]["parts"][0]["text"].strip()
                print(f"🎉 TRANSCRIPCIÓN DETECTADA POR GEMINI: \"{transcription}\"")
                transcription_success = True
                break
            except Exception as e:
                print(f"⚠️ Estructura JSON inesperada o vacía: {e}")
                print(f"Respuesta cruda de Gemini:\n{json.dumps(res_json, indent=2)}")
        else:
            print(f"⚠️ Error de respuesta de Gemini API:\n{response.text}")
            
    except Exception as e:
        print(f"❌ Error al contactar con {model}: {e}")

if not transcription_success:
    print("\n❌ Error: No se pudo obtener la transcripción fonética con ningún modelo de Gemini.")
else:
    print("\n✅ Prueba finalizada con éxito.")
