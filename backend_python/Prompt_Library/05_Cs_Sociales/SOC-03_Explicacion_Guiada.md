# PROMPT SOC-03

## Nombre

Explicación Guiada de Ciencias Sociales

---

## Objetivo

Explicar un concepto de Ciencias Sociales mediante ejemplos cotidianos y situaciones cercanas al contexto del estudiante, favoreciendo la comprensión progresiva y el pensamiento crítico.

---

## Cuándo se utiliza

Cuando el estudiante solicita ayuda adicional o presenta dificultades repetidas en un mismo tema.

---

## Quién lo utiliza

- **Backend:** Solicita una explicación específica enviando el tema y la dificultad detectada.
- **Gemini:** Genera una explicación adaptada a la edad y grado escolar del estudiante.
- **Flutter:** Presenta la explicación organizada dentro de la interfaz de aprendizaje.

---

## Entradas

| Parámetro             | Descripción                       |
|-----------------------|-----------------------------------|
| edad                  | Edad del estudiante               |
| grado                 | Curso escolar                     |
| tema                  | Concepto que necesita explicación |
| dificultad_detectada  | Error o dificultad identificada   |

---

## Salida esperada

La respuesta debe seguir el contrato **JSON-04_Ciencias_Sociales**.

Debe incluir:

- Explicación sencilla.
- Ejemplo relacionado con Bolivia.
- Explicación paso a paso.
- Pregunta de comprobación.
- Ejercicio corto.

---

## Prompt

```text
  Explica el siguiente concepto de Ciencias Sociales.

  Edad: {edad}

  Grado: {grado}

  Tema: {tema}

  Dificultad detectada:
  {dificultad_detectada}

  Instrucciones:

    - Explica únicamente un concepto.
    - Utiliza lenguaje sencillo.
    - Divide la explicación en pasos.
    - Incluye un ejemplo relacionado con la vida cotidiana o el contexto boliviano.
    - Finaliza con una pregunta para comprobar la comprensión.
    - Propón un ejercicio corto.
    - Devuelve únicamente un objeto JSON siguiendo el contrato JSON-04.
```

---

## Ejemplo de entrada

```text
Tema:
Departamentos de Bolivia

Dificultad:
Confunde departamento con ciudad.
```

---

## Ejemplo de salida

```json
{
  "tipo":"explicacion",
  "mensaje":"Vamos a aprenderlo juntos. 😊",
  "contenido":{
    "concepto":"Un departamento es una división grande del país que contiene varias ciudades y municipios.",
    "ejemplo":"La Paz es un departamento y también tiene una ciudad llamada La Paz.",
    "pregunta":"¿Crees que Cochabamba también es un departamento?",
    "ejercicio":"Escribe el nombre de dos departamentos de Bolivia."
  },
  "metadata":{
    "tema":"División política de Bolivia"
  }
}
```

---

## Criterios de aceptación

✓ Explica un único concepto.

✓ Utiliza ejemplos del contexto boliviano.

✓ Sigue una secuencia lógica.

✓ Incluye una pregunta.

✓ Propone un ejercicio de práctica.

---

## Observaciones

Este prompt busca fortalecer la comprensión conceptual antes de avanzar hacia nuevos contenidos.