# CONTRATO JSON-01

## Nombre

**Respuesta Estándar de Matemática**

---

## Objetivo

Definir la estructura JSON utilizada por los prompts del módulo de Matemática para intercambiar información entre Gemini, el backend y Flutter.

Este documento establece un contrato de integración que garantiza que todas las respuestas generadas por la IA mantengan un formato uniforme, independientemente del prompt utilizado.

---

## Descripción

Los prompts de Matemática (**MAT-01**, **MAT-02**, **MAT-03** y **MAT-04**) generan distintos tipos de respuestas, como ejercicios, retroalimentación, explicaciones o actividades adaptativas. Sin embargo, todas deben seguir una estructura consistente para facilitar su procesamiento.

Este contrato permite que:

* Gemini devuelva información organizada.
* El backend procese fácilmente cada respuesta.
* Flutter muestre cada componente de la respuesta sin interpretar texto libre.

No es un prompt.

No se envía a Gemini.

Es una especificación técnica utilizada durante el desarrollo del proyecto para definir el formato de intercambio de información entre los componentes del sistema.

---

## Quién lo utiliza

* **AI Engineer:** Diseña los prompts respetando esta estructura.
* **Backend:** Valida y procesa la respuesta generada por Gemini.
* **Flutter:** Consume cada campo del JSON para construir la interfaz del estudiante.

---

## Estructura general

```json id="j9rxmz"
{
  "tipo": "",
  "titulo": "",
  "mensaje": "",
  "contenido": {},
  "metadata": {}
}
```

---

## Descripción de los campos

| Campo     | Descripción                                                                                        |
| --------- | -------------------------------------------------------------------------------------------------- |
| tipo      | Tipo de respuesta generada (ejercicio, retroalimentación, explicación, práctica adaptativa, etc.). |
| titulo    | Nombre corto de la actividad o respuesta.                                                          |
| mensaje   | Texto principal dirigido al estudiante.                                                            |
| contenido | Información específica generada por cada prompt.                                                   |
| metadata  | Información adicional utilizada por el sistema.                                                    |

---

## Ejemplo

```json id="mjlwm4"
{
  "tipo": "retroalimentacion",
  "titulo": "Corrección de ejercicio",
  "mensaje": "¡Buen intento! 😊",
  "contenido": {
    "correcto": false,
    "explicacion": "Multiplicar significa sumar grupos iguales.",
    "pista": "Piensa cuánto es 7 × 7.",
    "pregunta_guiada": "¿Qué ocurre si sumas otro grupo de 7?",
    "nuevo_intento": true
  },
  "metadata": {
    "tema": "Multiplicaciones",
    "nivel": "Básico"
  }
}
```

---

## Observaciones

Los prompts **MAT-01**, **MAT-02**, **MAT-03** y **MAT-04** reutilizan esta estructura para mantener consistencia durante todas las actividades de Matemática.

Aunque cada prompt genera información diferente (ejercicios, correcciones, explicaciones o prácticas adaptativas), todos respetan este contrato de datos para facilitar la integración entre Gemini, el backend y Flutter.