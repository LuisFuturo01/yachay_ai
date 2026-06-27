# PROMPT AYM-01

## Nombre

Generación de Práctica de Pronunciación en Aymara

---

## Objetivo

Generar una actividad de pronunciación para que el estudiante practique vocabulario básico en idioma aymara.

La actividad debe incluir la palabra objetivo, su significado, una breve instrucción y el texto que posteriormente será utilizado por el sistema de síntesis de voz (Text-to-Speech) para generar el audio que escuchará el estudiante.

---

## Cuándo se utiliza

Cuando el estudiante inicia una nueva práctica de pronunciación en idioma aymara.

---

## Quién lo utiliza

* **Backend:** Solicita una nueva actividad de pronunciación.
* **Gemini:** Genera la práctica.
* **Servicio TTS:** Convierte el texto proporcionado por Gemini en audio.
* **Flutter:** Reproduce el audio y muestra la actividad al estudiante.

---

## Entradas

| Parámetro | Descripción                                                    |
| --------- | -------------------------------------------------------------- |
| edad      | Edad del estudiante                                            |
| nivel     | Nivel de dificultad (Básico, Intermedio, Avanzado)             |
| categoría | Saludos, animales, colores, números, familia, naturaleza, etc. |

---

## Salida esperada

Gemini debe devolver un único objeto JSON con:

* palabra en aymara
* significado
* categoría
* instrucción para el estudiante
* texto que será utilizado para generar el audio

---

## Prompt

```text
    Genera una actividad de pronunciación para un estudiante.

    Edad:
    {edad}

    Nivel:
    {nivel}

    Categoría:
    {categoria}

    Instrucciones:

    - Selecciona una única palabra o frase corta en idioma aymara.
    - Utiliza vocabulario apropiado para niños.
    - Incluye el significado en español.
    - Escribe una instrucción breve para el estudiante.
    - Devuelve únicamente un objeto JSON.
    - El campo "texto_audio" debe contener exactamente el texto que posteriormente será convertido en audio mediante un servicio de síntesis de voz.

    Utiliza exactamente este formato:

    {
    "palabra": "",
    "significado": "",
    "categoria": "",
    "instruccion": "",
    "texto_audio": ""
    }
```

---

## Ejemplo de entrada

```text
    Edad: 8 años

    Nivel: Básico

    Categoría: Saludos
```

---

## Ejemplo de salida

```json
    {
    "palabra": "Jallalla",
    "significado": "¡Bienvenido! / ¡Felicidades!",
    "categoria": "Saludos",
    "instruccion": "Escucha atentamente la pronunciación y luego intenta repetir la palabra.",
    "texto_audio": "Jallalla"
    }
```

---

## Criterios de aceptación

✓ Genera una sola actividad.

✓ Utiliza vocabulario adecuado para niños.

✓ Incluye significado.

✓ Devuelve un JSON válido.

✓ El campo "texto_audio" coincide exactamente con la palabra objetivo.

---

## Observaciones

Gemini no genera el audio directamente.

El backend utilizará el campo "texto_audio" para enviarlo a un servicio de Text-to-Speech, que producirá el audio reproducido en la aplicación.
