# CONTRATO JSON-02

## Nombre

**Respuesta Estándar de Aymara**

---

## Objetivo

Definir la estructura JSON utilizada por los prompts del módulo de idioma Aymara para intercambiar información entre Gemini, el backend y Flutter.

---

## Descripción

El módulo de Aymara utiliza las capacidades multimodales de Gemini para generar actividades, analizar la pronunciación del estudiante y proporcionar retroalimentación educativa.

Este contrato establece una estructura uniforme para todas las respuestas del módulo, independientemente del tipo de actividad realizada.

No es un prompt.

No se envía a Gemini.

Es una especificación técnica que documenta cómo deben estructurarse las respuestas generadas por la IA.

---

## Quién lo utiliza

* **AI Engineer:** Diseña los prompts respetando esta estructura.
* **Backend:** Procesa la respuesta generada por Gemini.
* **Flutter:** Presenta las actividades y la retroalimentación al estudiante.

---

## Estructura general

```json
{
  "tipo": "",
  "mensaje": "",
  "contenido": {},
  "metadata": {}
}
```

---

## Descripción de los campos

| Campo     | Descripción                               |
| --------- | ----------------------------------------- |
| tipo      | Tipo de actividad o respuesta generada.   |
| mensaje   | Mensaje principal mostrado al estudiante. |
| contenido | Información específica de la actividad.   |
| metadata  | Información utilizada por el sistema.     |

---

## Ejemplo

```json
{
  "tipo": "evaluacion_pronunciacion",
  "mensaje": "¡Muy bien! 😊",
  "contenido": {
    "precision_porcentaje": 88,
    "transcripcion_detectada": "Jalala",
    "observaciones_foneticas": "La doble 'll' necesita mayor énfasis.",
    "requiere_repeticion": true
  },
  "metadata": {
    "palabra": "Jallalla",
    "categoria": "Saludos",
    "nivel": "Básico"
  }
}
```

---

## Observaciones

Los prompts **AYM-01**, **AYM-02** y **AYM-03** reutilizan esta estructura para mantener consistencia durante toda la práctica del idioma Aymara.

Aunque cada prompt genera información diferente (actividad, evaluación fonética o retroalimentación adaptativa), todos respetan este contrato de datos para facilitar la integración entre Gemini, el backend y Flutter.