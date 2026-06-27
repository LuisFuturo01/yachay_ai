import os
import sys

# Verificar si las librerías requeridas están instaladas
try:
    import speech_recognition as sr
    has_sr = True
except ImportError:
    has_sr = False

try:
    import sounddevice as sd
    import soundfile as sf
    has_mic = True
except ImportError:
    has_mic = False

print("=" * 55)
print("    PROBADOR DE SPEECH-TO-TEXT (STT) - GOOGLE API")
print("=" * 55)

if not has_sr:
    print("\n❌ Error: La librería 'speech_recognition' no está instalada.")
    print("Por favor, instálala ejecutando en tu consola:")
    print("  pip install SpeechRecognition sounddevice soundfile")
    print("\n(Nota: Si vas a grabar con micrófono, sounddevice y soundfile son recomendados en Windows)")
    sys.exit(1)

# Paso 1: Obtener el archivo de audio (.wav)
wav_filename = "prueba_stt.wav"

if len(sys.argv) > 1:
    wav_filename = sys.argv[1]
    print(f"📁 Cargando archivo de audio existente: '{wav_filename}'")
else:
    if not has_mic:
        print("\n❌ Faltan dependencias para grabar audio desde el micrófono.")
        print("Por favor instálalas ejecutando:")
        print("  pip install sounddevice soundfile SpeechRecognition")
        print("\nO bien, ejecuta el script pasándole un archivo de audio existente:")
        print("  python test_stt.py ruta/a/tu/archivo.wav")
        sys.exit(1)
        
    print("\n🎤 Preparando grabación de micrófono de tu PC...")
    print("La grabación durará 3 segundos.")
    print("Presiona ENTER para comenzar a grabar...")
    input()
    
    sample_rate = 16000
    duration = 3.0  # segundos
    
    print("🔴 GRABANDO... Habla ahora (di 'Jallalla' o cualquier frase):")
    # Graba en canal mono
    recording = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=1)
    sd.wait()  # Espera a que termine la grabación
    print("⬛ GRABACIÓN FINALIZADA.")
    
    # Guardar en archivo WAV
    sf.write(wav_filename, recording, sample_rate)
    print(f"💾 Guardado como '{wav_filename}'")

# Paso 2: Ejecutar el reconocimiento de voz (Speech-to-Text)
print(f"\n⚙️ Procesando '{wav_filename}'...")
recognizer = sr.Recognizer()

try:
    # Cargar el archivo WAV en el reconocedor
    with sr.AudioFile(wav_filename) as source:
        audio_data = recognizer.record(source)
    
    # Transcribir usando la API de Google Web Speech (gratuita, sin keys)
    print("📡 Transcribiendo audio con Google STT (es-BO)...")
    transcription = recognizer.recognize_google(audio_data, language="es-BO")
    print("-" * 55)
    print(f"🎉 TEXTO DETECTADO POR EL STT: \"{transcription}\"")
    print("-" * 55)
    print("✅ Prueba finalizada con éxito.")
    
except sr.UnknownValueError:
    print("\n❌ Google STT no pudo entender el audio.")
    print("Esto ocurre si el archivo está en silencio, tiene mucho ruido o el formato no es claro.")
except sr.RequestError as e:
    print(f"\n❌ Error de conexión con el servidor de Google Speech Recognition: {e}")
except Exception as e:
    print(f"\n❌ Error al procesar el archivo de audio: {e}")
