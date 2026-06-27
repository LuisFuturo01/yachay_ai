# PROMPT NAT-03

## Nombre

Explicación Guiada de Ciencias Naturales

---

## Objetivo

Explicar un concepto científico utilizando ejemplos sencillos, observaciones del entorno y un proceso paso a paso que facilite la comprensión del estudiante.

---

## Cuándo se utiliza

Cuando el estudiante solicita ayuda o presenta dificultades repetidas en un mismo tema.

---

## Quién lo utiliza

- Backend.
- Gemini.
- Flutter.

---

## Entradas

| Parámetro            | Descripción          |
|----------------------|----------------------|
| edad                 | Edad                 |
| grado                | Curso                |
| tema                 | Concepto científico  |
| dificultad_detectada | Error identificado   |

---

## Salida esperada

Debe seguir el contrato **JSON-03**.

Debe incluir:

- explicación sencilla;
- ejemplo cotidiano;
- pasos;
- pregunta de comprobación;
- ejercicio corto.

---

## Prompt

```text
  Explica el siguiente concepto científico.

  Edad: {edad}

  Grado: {grado}

  Tema: {tema}

  Dificultad detectada:
  {dificultad_detectada}

  Instrucciones:

    - Explica un único concepto.
    - Utiliza palabras sencillas.
    - Relaciona el tema con situaciones del entorno.
    - Divide la explicación en pasos.
    - Incluye un ejemplo cotidiano.
    - Finaliza con una pregunta.
    - Propón un pequeño ejercicio.
    - Devuelve únicamente un objeto JSON siguiendo el contrato JSON-03.
```

---

## Ejemplo de entrada

```text
Tema:
El ciclo del agua

Dificultad:
No comprende cómo se forman las nubes.
```

---

## Ejemplo de salida

```json
{
  "tipo":"explicacion",
  "mensaje":"Vamos a descubrirlo juntos. 🌧️",
  "contenido":{
    "concepto":"El agua se calienta con el Sol y sube en forma de vapor. Cuando el vapor se enfría, forma pequeñas gotas que crean las nubes.",
    "ejemplo":"Cuando hierves agua, puedes ver vapor subir. Algo parecido ocurre en la naturaleza.",
    "pregunta":"¿Qué crees que pasa cuando las nubes tienen mucha agua?",
    "ejercicio":"Dibuja el recorrido del agua desde un río hasta una nube."
  },
  "metadata":{
    "tema":"Ciclo del agua"
  }
}
```

---

## Criterios de aceptación

✓ Explica un solo concepto.

✓ Usa ejemplos cotidianos.

✓ Sigue un orden lógico.

✓ Incluye pregunta.

✓ Incluye actividad.

---

## Observaciones

Las explicaciones deben favorecer la comprensión antes que la memorización.