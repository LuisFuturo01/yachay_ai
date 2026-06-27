# PROMPT NAT-04

## Nombre

Práctica Adaptativa de Ciencias Naturales

---

## Objetivo

Analizar el desempeño reciente del estudiante para decidir si corresponde reforzar, mantener o aumentar la dificultad de las actividades de Ciencias Naturales.

---

## Cuándo se utiliza

Después de resolver uno o varios ejercicios.

---

## Quién lo utiliza

- Backend.
- Gemini.
- Flutter.

---

## Entradas

| Parámetro               | Descripción               |
|-------------------------|---------------------------|
| edad                    | Edad                      |
| grado                   | Curso                     |
| tema                    | Tema actual               |
| ejercicios_correctos    | Cantidad de aciertos      |
| ejercicios_incorrectos  | Cantidad de errores       |
| errores_detectados      | Dificultades observadas   |

---

## Salida esperada

Debe seguir el contrato **JSON-03**.

Debe incluir:

- diagnóstico;
- decisión pedagógica;
- justificación;
- nuevo ejercicio;
- nivel siguiente.

---

## Prompt

```text
Analiza el desempeño reciente del estudiante.

Edad: {edad}

Grado: {grado}

Tema: {tema}

Ejercicios correctos:
{ejercicios_correctos}

Ejercicios incorrectos:
{ejercicios_incorrectos}

Errores detectados:
{errores_detectados}

Instrucciones:

- Decide si corresponde reforzar, mantener o aumentar la dificultad.
- Prioriza reforzar conceptos antes de avanzar.
- Genera un único ejercicio.
- No incluyas la respuesta.
- Justifica brevemente la decisión pedagógica.
- Devuelve únicamente un objeto JSON siguiendo el contrato JSON-03.
```

---

## Ejemplo de entrada

```text
Tema:
El ciclo del agua

Correctos:
1

Incorrectos:
3

Errores:
Confunde evaporación con lluvia.
```

---

## Ejemplo de salida

```json
{
  "tipo":"practica_adaptativa",
  "mensaje":"Sigamos practicando, vas muy bien. 😊",
  "contenido":{
    "diagnostico":"El estudiante aún confunde las etapas del ciclo del agua.",
    "decision":"reforzar",
    "justificacion":"Es importante consolidar el concepto antes de aumentar la dificultad.",
    "nuevo_ejercicio":"Observa una olla con agua caliente. ¿Qué sucede con el vapor que sale de ella?"
  },
  "metadata":{
    "tema":"Ciclo del agua",
    "nivel":"Básico"
  }
}
```

---

## Criterios de aceptación

✓ Analiza el desempeño.

✓ Adapta la dificultad.

✓ Genera un solo ejercicio.

✓ No revela la respuesta.

✓ Devuelve JSON válido.

---

## Observaciones

Este prompt implementa la personalización educativa para Ciencias Naturales, permitiendo que Yachay adapte el aprendizaje al progreso de cada estudiante.