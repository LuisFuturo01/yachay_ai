# CONTRATO JSON-03

## Nombre

Respuesta estándar de Ciencias Naturales

---

## Objetivo

Definir la estructura JSON utilizada por los prompts del módulo de Ciencias Naturales para intercambiar información entre Gemini, el backend y la aplicación Flutter.

Este contrato garantiza que todas las respuestas generadas por Gemini mantengan un formato uniforme, facilitando su procesamiento y visualización dentro del MVP.

---

## Descripción

Los prompts de Ciencias Naturales (NAT-01, NAT-02, NAT-03 y NAT-04) generan diferentes tipos de respuestas, como ejercicios, retroalimentaciones, explicaciones o actividades adaptativas.

Aunque el contenido cambia según el prompt, todas las respuestas deben respetar la misma estructura JSON.

Este documento **no es un prompt**.

No se envía a Gemini.

Es una especificación técnica utilizada durante el desarrollo e integración del proyecto.

---

## Quién lo utiliza

- **AI Engineer:** Diseña los prompts respetando esta estructura.
- **Backend:** Valida, procesa y distribuye la información recibida desde Gemini.
- **Flutter:** Consume cada campo del JSON para construir la interfaz del estudiante sin interpretar texto libre.

---

## Estructura general

```json
{
  "tipo":"",
  "titulo":"",
  "mensaje":"",
  "contenido":{},
  "metadata":{}
}
```

---

## Descripción de los campos

| Campo     | Descripción                                                                                   |
|-----------|-----------------------------------------------------------------------------------------------|
| tipo      | Tipo de respuesta generada (ejercicio, retroalimentacion, explicacion o practica_adaptativa). |
| titulo    | Nombre corto de la actividad o explicación.                                                   |
| mensaje   | Mensaje principal mostrado al estudiante.                                                     |
| contenido | Información específica correspondiente al tipo de respuesta.                                  |
| metadata  | Información utilizada por el sistema para clasificación y seguimiento.                        |

---

## Ejemplo

```json
{
  "tipo":"retroalimentacion",
  "titulo":"Seres vivos",
  "mensaje":"¡Buen intento! 😊",
  "contenido":{
      "correcto":false,
      "explicacion":"Los seres vivos nacen, crecen, se alimentan y se reproducen.",
      "pista":"Piensa si una piedra puede crecer sola.",
      "pregunta":"¿Las plantas crecen con el tiempo?"
  },
  "metadata":{
      "tema":"Seres vivos",
      "nivel":"Básico"
  }
}
```

---

## Observaciones

Cada prompt puede utilizar únicamente los campos necesarios dentro de **contenido**, manteniendo siempre la estructura general definida en este documento.

Este contrato debe ser utilizado por:

  - NAT-01
  - NAT-02
  - NAT-03
  - NAT-04

para mantener consistencia durante toda la experiencia de aprendizaje.