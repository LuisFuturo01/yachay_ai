# PROMPT AYM-02

## Nombre

Evaluación Fonética mediante Audio

---

## Objetivo

Evaluar la pronunciación del estudiante utilizando un archivo de audio y compararlo con la palabra objetivo en idioma aymara.

Gemini debe analizar el audio, identificar cómo fue pronunciada la palabra y proporcionar una retroalimentación educativa.

---

## Cuándo se utiliza

Después de que el estudiante escucha la palabra y envía su pronunciación mediante el micrófono.

---

## Quién lo utiliza

* **Flutter:** Graba la voz del estudiante.
* **Backend:** Envía el archivo de audio junto con la palabra objetivo a Gemini.
* **Gemini:** Analiza el audio y genera la evaluación.
* **Flutter:** Presenta la retroalimentación al estudiante.

---

## Entradas

| Parámetro        | Descripción                                |
| ---------------- | ------------------------------------------ |
| palabra_objetivo | Palabra que el estudiante debía pronunciar |
| audio_estudiante | Archivo de audio grabado por el estudiante |

---

## Salida esperada

Gemini debe devolver únicamente un objeto JSON que incluya:

* porcentaje de precisión
* transcripción detectada
* observaciones fonéticas
* retroalimentación educativa
* indicador de si debe repetir la práctica

---

## Prompt

```text
  Escucha cuidadosamente el archivo de audio enviado.

  El estudiante intenta pronunciar la siguiente palabra en idioma aymara:

  Palabra objetivo:

  {palabra_objetivo}

  Analiza el audio considerando los siguientes aspectos:

  - identifica la palabra pronunciada;
  - compara la pronunciación con la palabra objetivo;
  - detecta sonidos omitidos o reemplazados;
  - considera que el estudiante tiene entre 5 y 12 años, por lo que pequeñas variaciones son aceptables;
  - utiliza un tono positivo y motivador.

  Devuelve únicamente el siguiente JSON:

  {
    "precision_porcentaje": 0,
    "transcripcion_detectada": "",
    "observaciones_foneticas": "",
    "feedback_texto": "",
    "requiere_repeticion": false
  }
```

---

## Ejemplo de entrada

```text
  Palabra objetivo:

  Jallalla

  Audio:

  (audio_estudiante.wav)
```

---

## Ejemplo de salida

```json
  {
    "precision_porcentaje": 88,
    "transcripcion_detectada": "Jalala",
    "observaciones_foneticas": "La pronunciación es correcta en general, pero la doble 'll' se escuchó de forma más suave.",
    "feedback_texto": "¡Muy bien! 😊 Estuviste muy cerca. Intenta marcar un poco más el sonido 'll' y volver a intentarlo.",
    "requiere_repeticion": true
  }
```

---

## Criterios de aceptación

✓ Analiza el audio.

✓ Genera una transcripción aproximada.

✓ Evalúa la pronunciación.

✓ Devuelve un JSON válido.

✓ Mantiene un lenguaje apropiado para niños.

---

## Observaciones

Este prompt aprovecha la capacidad multimodal de Gemini para analizar directamente archivos de audio enviados por el backend, sin necesidad de entrenar modelos personalizados de reconocimiento de voz.
