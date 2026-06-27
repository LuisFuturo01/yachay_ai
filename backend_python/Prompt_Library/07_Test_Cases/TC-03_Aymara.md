# CASO DE PRUEBA TC-03

## Nombre

**Evaluación de Pronunciación en Aymara**

---

## Objetivo

Validar que Gemini utilice sus capacidades multimodales para analizar la pronunciación de una palabra en aymara y generar retroalimentación educativa.

---

## Descripción

Este caso evalúa el funcionamiento conjunto de AYM-01, AYM-02 y AYM-03 mediante el análisis de un audio enviado por el estudiante.

El objetivo no es realizar reconocimiento de voz tradicional, sino aprovechar Gemini para:

- transcribir el audio;
- comparar la pronunciación con la palabra objetivo;
- estimar una precisión;
- generar recomendaciones educativas.

---

## Componentes evaluados

- SYS-01
- AYM-01
- AYM-02
- AYM-03

---

## Datos de entrada

```text
Edad:
8 años

Categoría:
Saludos

Palabra objetivo:
Jallalla

Audio del estudiante:
"Jalala"
```

---

## Resultado esperado

Gemini debe:

- reconocer la palabra pronunciada;
- detectar diferencias fonéticas;
- estimar un porcentaje de precisión;
- explicar qué sonido mejorar;
- mantener un tono motivador.

---

## Ejemplo de respuesta esperada

```json
{
  "precision_porcentaje": 88,
  "transcripcion_detectada": "Jalala",
  "observaciones_foneticas": "La doble 'll' necesita mayor énfasis.",
  "feedback_texto": "¡Muy bien! 😊 Intenta marcar un poco más la doble 'll'.",
  "requiere_repeticion": true
}
```

---

## Criterios de aceptación

✓ Analiza correctamente el audio.

✓ Genera retroalimentación educativa.

✓ Utiliza lenguaje apropiado para niños.

✓ Devuelve un JSON válido.

✓ Motiva al estudiante.

---

## Observaciones

Este caso demuestra el uso de capacidades multimodales de Gemini para apoyar el aprendizaje del idioma aymara, una de las funcionalidades diferenciadoras del MVP.