# PROMPT MAT-03

## Nombre

**Explicación Paso a Paso**

---

## Objetivo

Explicar un concepto matemático de manera gradual, utilizando ejemplos sencillos y adaptados a la edad del estudiante, para fortalecer su comprensión antes de continuar con nuevos ejercicios.

---

## Descripción

Este prompt se activa cuando el estudiante necesita una explicación más profunda debido a dudas o errores repetitivos.

Su función es transformar un concepto matemático en una explicación sencilla, organizada en pasos cortos y acompañada de ejemplos cotidianos que faciliten el aprendizaje.

Al finalizar, debe comprobar la comprensión mediante una pregunta y proponer un ejercicio de práctica relacionado.

La respuesta se entrega en formato JSON para facilitar su visualización estructurada en Flutter.

---

## Cuándo se utiliza

* Cuando el estudiante solicita ayuda.
* Cuando el estudiante falla varias veces un mismo ejercicio.
* Cuando MAT-02 identifica una dificultad conceptual importante.

---

## Quién lo utiliza

* **Backend:** Solicita una explicación sobre un concepto específico.
* **Gemini:** Genera la explicación adaptada al estudiante.
* **Flutter:** Presenta la explicación, el ejemplo y la práctica propuesta.

---

## Entradas

| Parámetro            | Descripción                     |
| -------------------- | ------------------------------- |
| edad                 | Edad del estudiante             |
| grado                | Curso escolar                   |
| tema                 | Concepto matemático             |
| dificultad_detectada | Error o dificultad identificada |

---

## Salida esperada

Gemini debe:

* explicar un único concepto;
* dividir la explicación en pasos;
* utilizar un ejemplo cotidiano;
* comprobar la comprensión;
* proponer un ejercicio similar para practicar.

---

## Formato de respuesta

Gemini debe responder únicamente con el siguiente JSON.

```json
{
  "concepto": "",
  "explicacion": "",
  "ejemplo": "",
  "pasos": [
    "",
    "",
    ""
  ],
  "pregunta_comprobacion": "",
  "ejercicio_practica": ""
}
```

### Descripción de los campos

| Campo                 | Descripción                                      |
| --------------------- | ------------------------------------------------ |
| concepto              | Tema explicado.                                  |
| explicacion           | Explicación general del concepto.                |
| ejemplo               | Situación cotidiana relacionada con el concepto. |
| pasos                 | Explicación organizada paso a paso.              |
| pregunta_comprobacion | Pregunta para verificar la comprensión.          |
| ejercicio_practica    | Nuevo ejercicio para reforzar el aprendizaje.    |

---

## Prompt

```text
Explica el siguiente concepto matemático utilizando la información del estudiante.

Edad:
{edad}

Grado:
{grado}

Tema:
{tema}

Dificultad detectada:
{dificultad_detectada}

Instrucciones:

- Explica únicamente un concepto.
- Utiliza palabras sencillas.
- Divide la explicación en pasos cortos.
- Incluye un ejemplo relacionado con la vida cotidiana.
- Finaliza con una pregunta para comprobar la comprensión.
- Propón un ejercicio muy parecido para practicar.
- Devuelve únicamente un objeto JSON con el formato especificado.
```

---

## Ejemplo de entrada

```text
Edad: 8 años

Tema:
Multiplicación como suma repetida

Dificultad detectada:
El estudiante confunde la multiplicación con la suma.
```

---

## Ejemplo de salida

```json
{
  "concepto": "Multiplicación como suma repetida",
  "explicacion": "Multiplicar significa sumar varias veces la misma cantidad.",
  "ejemplo": "Imagina que tienes 4 bolsas y cada una tiene 3 manzanas.",
  "pasos": [
    "Cuenta las manzanas de la primera bolsa.",
    "Haz lo mismo con las demás bolsas.",
    "También puedes escribir 3 + 3 + 3 + 3, que es igual a 4 × 3."
  ],
  "pregunta_comprobacion": "Si tienes 5 bolsas con 2 caramelos en cada una, ¿cuántos caramelos hay en total?",
  "ejercicio_practica": "Resuelve: 6 × 2 = ?"
}
```

---

## Criterios de aceptación

✓ Explica un único concepto.

✓ Utiliza lenguaje apropiado para niños.

✓ Organiza la explicación paso a paso.

✓ Incluye un ejemplo cotidiano.

✓ Finaliza con una pregunta de comprobación.

✓ Propone un ejercicio de práctica.

✓ Devuelve un JSON válido.

---

## Observaciones

Este prompt complementa la retroalimentación proporcionada por MAT-02 y permite que Yachay AI adapte la enseñanza cuando detecta dificultades persistentes. Su propósito es reforzar la comprensión antes de incrementar la dificultad de los ejercicios, promoviendo un aprendizaje progresivo y significativo.

---