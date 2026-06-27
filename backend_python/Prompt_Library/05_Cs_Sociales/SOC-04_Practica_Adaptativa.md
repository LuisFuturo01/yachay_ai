# PROMPT SOC-04

## Nombre

Práctica Adaptativa de Ciencias Sociales

---

## Objetivo

Analizar el desempeño reciente del estudiante para determinar si corresponde reforzar, mantener o aumentar la dificultad de las actividades de Ciencias Sociales, adaptando el aprendizaje a su progreso.

---

## Cuándo se utiliza

Después de que el estudiante completa uno o varios ejercicios sobre un mismo tema.

---

## Quién lo utiliza

- **Backend:** Envía el historial reciente de desempeño del estudiante para solicitar una nueva actividad adaptada.
- **Gemini:** Analiza el rendimiento, toma una decisión pedagógica y genera un nuevo ejercicio adecuado.
- **Flutter:** Presenta la retroalimentación y el nuevo ejercicio generado al estudiante.

---

## Entradas

| Parámetro               | Descripción                                 |
|-------------------------|---------------------------------------------|
| edad                    | Edad del estudiante                         |
| grado                   | Curso escolar                               |
| tema                    | Tema actual                                 |
| ejercicios_correctos    | Cantidad de respuestas correctas recientes  |
| ejercicios_incorrectos  | Cantidad de respuestas incorrectas recientes|
| errores_detectados      | Principales dificultades identificadas      |

---

## Salida esperada

La respuesta debe seguir el contrato **JSON-04_Ciencias_Sociales**.

Debe incluir:

- Diagnóstico del desempeño.
- Decisión pedagógica.
- Justificación.
- Nuevo ejercicio.
- Nivel sugerido.

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

    - Determina si corresponde reforzar, mantener o aumentar la dificultad.
    - Prioriza reforzar los conceptos cuando existan errores repetitivos.
    - Genera un único ejercicio.
    - No reveles la respuesta.
    - Explica brevemente la decisión pedagógica.
    - Devuelve únicamente un objeto JSON siguiendo el contrato JSON-04.
```

---

## Ejemplo de entrada

```text
Tema:
Símbolos Patrios

Ejercicios correctos:
1

Ejercicios incorrectos:
3

Errores detectados:
Confunde la bandera con el escudo nacional.
```

---

## Ejemplo de salida

```json
{
  "tipo":"practica_adaptativa",
  "mensaje":"Sigamos aprendiendo juntos. 🌟",
  "contenido":{
    "diagnostico":"El estudiante aún presenta dificultades para diferenciar los símbolos patrios.",
    "decision":"reforzar",
    "justificacion":"Es importante consolidar este concepto antes de introducir nuevos temas.",
    "nuevo_ejercicio":"Observa una imagen de la bandera y del escudo nacional. ¿Cuál de ellos representa los colores rojo, amarillo y verde?"
  },
  "metadata":{
    "tema":"Símbolos Patrios",
    "nivel":"Básico"
  }
}
```

---

## Criterios de aceptación

✓ Analiza el desempeño del estudiante.

✓ Ajusta correctamente la dificultad.

✓ Genera un único ejercicio.

✓ No revela la respuesta.

✓ Devuelve un JSON válido.

---

## Observaciones

Este prompt implementa la adaptación pedagógica del módulo de Ciencias Sociales, permitiendo que Yachay personalice el aprendizaje según las necesidades y el progreso del estudiante.