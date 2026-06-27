# PROMPT NAT-01

## Nombre

Generación de ejercicios de Ciencias Naturales

---

## Objetivo

Generar una actividad educativa de Ciencias Naturales adaptada a la edad, grado escolar, tema y nivel del estudiante, fomentando la observación, la curiosidad y el razonamiento científico mediante situaciones cercanas a su entorno.

---

## Cuándo se utiliza

Cuando el estudiante inicia una práctica de Ciencias Naturales o solicita un nuevo ejercicio.

---

## Quién lo utiliza

- **Backend:** Solicita un nuevo ejercicio enviando la información del estudiante.
- **Gemini:** Genera una actividad personalizada.
- **Flutter:** Presenta el ejercicio al estudiante.

---

## Entradas

| Parámetro | Descripción                   |
|-----------|-------------------------------|
| edad      | Edad del estudiante           |
| grado     | Curso escolar                 |
| materia   | Ciencias Naturales            |
| tema      | Tema específico               |
| nivel     | Básico, Intermedio o Avanzado |

---

## Salida esperada

La respuesta debe generarse siguiendo el contrato **JSON-03_Ciencias_Naturales**.

Debe incluir:

- Un único ejercicio.
- Un contexto cotidiano.
- Una pregunta clara.
- No incluir la respuesta.
- Un lenguaje apropiado para la edad.

---

## Prompt

```text
  Genera un único ejercicio de Ciencias Naturales utilizando la siguiente información.

    Edad: {edad}

    Grado: {grado}

    Materia: Ciencias Naturales

    Tema: {tema}

    Nivel: {nivel}

  Instrucciones:

    - Genera solamente una actividad.
    - No reveles la respuesta.
    - Utiliza lenguaje sencillo.
    - Favorece la observación y el razonamiento.
    - Utiliza ejemplos relacionados con Bolivia cuando sea posible (animales, plantas, clima, agua, montañas, comunidad, escuela o familia).
    - Evita preguntas que solo requieran memorizar.
    - Devuelve únicamente un objeto JSON siguiendo el contrato JSON-03.
```

---

## Ejemplo de entrada

```text
Edad: 8 años

Grado: 3ro de primaria

Tema: Seres vivos

Nivel: Básico
```

---

## Ejemplo de salida

```json
{
  "tipo":"ejercicio",
  "titulo":"Observando las plantas",
  "mensaje":"Observa con atención.",
  "contenido":{
    "enunciado":"En el patio de tu escuela hay una planta pequeña y un árbol grande. ¿Qué características tienen ambos que permiten decir que son seres vivos?",
    "tipo_respuesta":"abierta"
  },
  "metadata":{
    "tema":"Seres vivos",
    "nivel":"Básico"
  }
}
```

---

## Criterios de aceptación

✓ Genera un solo ejercicio.

✓ Utiliza contexto cotidiano.

✓ Promueve la observación.

✓ No muestra la respuesta.

✓ Devuelve un JSON válido.

---

## Observaciones

Debe utilizarse siempre junto con el **SYS-01_System_Prompt** y respetar el contrato **JSON-03_Ciencias_Naturales**.