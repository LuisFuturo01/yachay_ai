# CONTRATO JSON-04

## Nombre

Respuesta estándar de Ciencias Sociales

---

## Objetivo

Definir la estructura JSON utilizada por los prompts del módulo de Ciencias Sociales para el intercambio de información entre Gemini, el backend y Flutter.

El propósito es mantener un formato uniforme independientemente del tipo de actividad generada por la IA.

---

## Descripción

Los prompts de Ciencias Sociales (SOC-01, SOC-02, SOC-03 y SOC-04) generan distintos tipos de respuestas, incluyendo ejercicios, retroalimentaciones, explicaciones y prácticas adaptativas.

Este documento define un contrato técnico que garantiza consistencia entre todos los componentes del sistema.

Este documento **no es un prompt**.

No se envía a Gemini.

Es una especificación técnica para el desarrollo del proyecto.

---

## Quién lo utiliza

- **AI Engineer:** Diseña los prompts respetando este contrato.
- **Backend:** Procesa y valida las respuestas generadas por Gemini.
- **Flutter:** Utiliza cada campo del JSON para construir la interfaz del estudiante.

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

| Campo     | Descripción                                             |
|-----------|---------------------------------------------------------|
| tipo      | Tipo de respuesta generada por Gemini.                  |
| titulo    | Nombre corto de la actividad.                           |
| mensaje   | Texto principal mostrado al estudiante.                 |
| contenido | Información específica de la actividad o explicación.   |
| metadata  | Información adicional utilizada por el sistema.         |

---

## Ejemplo

```json
{
  "tipo":"explicacion",
  "titulo":"Departamentos de Bolivia",
  "mensaje":"Aprendamos juntos 😊",
  "contenido":{
      "concepto":"Un departamento es una división territorial del país.",
      "ejemplo":"La Paz es un departamento de Bolivia.",
      "pregunta":"¿Conoces otro departamento?",
      "ejercicio":"Escribe el nombre de dos departamentos."
  },
  "metadata":{
      "tema":"División política",
      "nivel":"Básico"
  }
}
```

---

## Observaciones

Todos los prompts del módulo de Ciencias Sociales deben reutilizar este contrato.

Prompts asociados:

  - SOC-01
  - SOC-02
  - SOC-03
  - SOC-04