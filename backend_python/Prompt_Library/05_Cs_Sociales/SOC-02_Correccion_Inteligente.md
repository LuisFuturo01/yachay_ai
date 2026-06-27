# PROMPT SOC-02

## Nombre

Corrección Inteligente de Ciencias Sociales

---

## Objetivo

Analizar la respuesta del estudiante e identificar su nivel de comprensión del tema, proporcionando una retroalimentación educativa que fortalezca el pensamiento crítico y la comprensión del contexto social e histórico.

---

## Cuándo se utiliza

Después de que el estudiante responde una actividad de Ciencias Sociales.

---

## Quién lo utiliza

- **Backend:** Envía a Gemini el ejercicio presentado y la respuesta del estudiante para su evaluación.
- **Gemini:** Analiza la respuesta, identifica posibles errores conceptuales y genera una retroalimentación pedagógica.
- **Flutter:** Presenta la retroalimentación al estudiante utilizando la información recibida en formato JSON.

---

## Entradas

| Parámetro             | Descripción                               |
|-----------------------|-------------------------------------------|
| edad                  | Edad del estudiante                       |
| grado                 | Curso escolar                             |
| tema                  | Tema trabajado                            |
| ejercicio             | Actividad presentada                      |
| respuesta_estudiante  | Respuesta proporcionada por el estudiante |

---

## Salida esperada

La respuesta debe seguir el contrato **JSON-04_Ciencias_Sociales**.

Debe incluir:

- Reconocimiento del esfuerzo.
- Análisis de la respuesta.
- Explicación del concepto.
- Pista si existe un error.
- Pregunta guiada.
- Indicación de si el estudiante debe volver a intentarlo.

---

## Prompt

```text
    Analiza la respuesta del estudiante utilizando la siguiente información.

    Edad: {edad}

    Grado: {grado}

    Tema: {tema}

    Ejercicio:
    {ejercicio}

    Respuesta del estudiante:
    {respuesta_estudiante}

    Instrucciones:
        - Felicita primero el esfuerzo realizado.
        - Analiza si la respuesta demuestra comprensión del tema.
        - Si la respuesta es incorrecta:
            - No reveles inmediatamente la respuesta correcta.
            - Explica el concepto utilizando ejemplos sencillos.
            - Ofrece una pista.
            - Formula una pregunta que ayude al estudiante a reflexionar.
        - Si la respuesta es correcta:
            - Explica por qué es correcta.
            - Relaciona el concepto con una situación cotidiana.
            - Propón una pregunta para profundizar el aprendizaje.

    Devuelve únicamente un objeto JSON siguiendo el contrato JSON-04.
```

---

## Ejemplo de entrada

```text
Tema:
Departamentos de Bolivia

Pregunta:
¿Cuál es la sede de gobierno de Bolivia?

Respuesta:
Sucre
```

---

## Ejemplo de salida

```json
{
  "tipo":"retroalimentacion",
  "mensaje":"¡Buen intento! 😊",
  "contenido":{
    "correcto":false,
    "explicacion":"Sucre es la capital constitucional de Bolivia, pero la sede del gobierno se encuentra en otra ciudad.",
    "pista":"Piensa en la ciudad donde trabajan el Presidente y los ministerios.",
    "pregunta":"¿Recuerdas en qué ciudad está la Plaza Murillo?"
  },
  "metadata":{
    "tema":"Organización política de Bolivia",
    "nivel":"Básico"
  }
}
```

---

## Criterios de aceptación

✓ No revela inmediatamente la respuesta.

✓ Favorece el razonamiento.

✓ Utiliza preguntas guiadas.

✓ Mantiene el tono educativo de Yachay.

✓ Devuelve un JSON válido.

---

## Observaciones

La finalidad de este prompt es que el estudiante comprenda los conceptos sociales mediante el análisis y la reflexión, evitando respuestas memorísticas.