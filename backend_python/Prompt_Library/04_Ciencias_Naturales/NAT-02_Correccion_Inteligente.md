# PROMPT NAT-02

## Nombre

Corrección Inteligente de Ciencias Naturales

---

## Objetivo

Analizar la respuesta del estudiante, identificar posibles errores conceptuales y brindar una retroalimentación que favorezca la comprensión científica mediante preguntas guiadas.

---

## Cuándo se utiliza

Después de que el estudiante responde una actividad.

---

## Quién lo utiliza

- Backend.
- Gemini.
- Flutter.

---

## Entradas

| Parámetro             | Descripción               |
|-----------------------|---------------------------|
| edad                  | Edad del estudiante       |
| grado                 | Curso escolar             |
| tema                  | Tema trabajado            |
| ejercicio             | Actividad presentada      |
| respuesta_estudiante  | Respuesta del estudiante  |

---

## Salida esperada

Debe seguir el contrato **JSON-03**.

Debe incluir:

- reconocimiento del esfuerzo;
- análisis conceptual;
- explicación;
- pista;
- pregunta guiada;
- indicación de si debe volver a intentarlo.

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
        - Felicita primero el esfuerzo.
        - Analiza si la respuesta demuestra comprensión del concepto.
        - Si existe un error:
            - no reveles inmediatamente la respuesta;
            - explica el concepto de forma sencilla;
            - ofrece una pista;
            - realiza una pregunta que ayude a reflexionar.
        - Si la respuesta es correcta:
            - explica por qué es correcta;
            - relaciona el concepto con una situación cotidiana;
            - propone una pregunta de profundización.

    Devuelve únicamente un objeto JSON siguiendo el contrato JSON-03.
```

---

## Ejemplo de entrada

```text
Tema:
Seres vivos

Pregunta:
¿Las piedras son seres vivos?

Respuesta:
Sí.
```

---

## Ejemplo de salida

```json
{
  "tipo":"retroalimentacion",
  "mensaje":"¡Buen intento! 😊",
  "contenido":{
    "correcto":false,
    "explicacion":"Los seres vivos nacen, crecen, se alimentan y se reproducen. Las piedras no realizan estas funciones.",
    "pista":"Piensa si una piedra puede crecer por sí sola.",
    "pregunta":"¿Has visto alguna piedra convertirse en una planta o un animal?"
  },
  "metadata":{
    "tema":"Seres vivos",
    "nivel":"Básico"
  }
}
```

---

## Criterios de aceptación

✓ No entrega inmediatamente la respuesta.

✓ Explica el concepto.

✓ Motiva al estudiante.

✓ Utiliza preguntas guiadas.

✓ Devuelve JSON válido.

---

## Observaciones

La prioridad es desarrollar comprensión científica, no memorizar definiciones.