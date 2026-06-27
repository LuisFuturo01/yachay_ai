# PROMPT SOC-01

## Nombre

Generación de ejercicios de Ciencias Sociales

---

## Objetivo

Generar una actividad educativa de Ciencias Sociales adaptada a la edad, grado escolar, tema y nivel del estudiante, promoviendo el pensamiento crítico, la comprensión de su entorno y el reconocimiento de la diversidad cultural, histórica y geográfica de Bolivia.

---

## Cuándo se utiliza

Cuando el estudiante inicia una práctica de Ciencias Sociales o solicita un nuevo ejercicio desde la aplicación.

---

## Quién lo utiliza

- **Backend:** Envía la información del estudiante (edad, grado, tema y nivel) a Gemini para solicitar una nueva actividad.
- **Gemini:** Analiza la información recibida y genera un ejercicio educativo adecuado al contexto del estudiante.
- **Flutter:** Recibe el JSON generado por Gemini y muestra el ejercicio de forma amigable en la interfaz.

---

## Entradas

| Parámetro | Descripción                                           |
|-----------|-------------------------------------------------------|
| edad      | Edad del estudiante                                   |
| grado     | Curso escolar                                         |
| materia   | Ciencias Sociales                                     |
| tema      | Tema específico que se desea practicar                |
| nivel     | Nivel de dificultad (Básico, Intermedio o Avanzado)   |

---

## Salida esperada

La respuesta debe seguir el contrato **JSON-04_Ciencias_Sociales**.

Debe incluir:

- Un único ejercicio.
- Una situación cercana al contexto boliviano.
- Una pregunta clara.
- Lenguaje apropiado para la edad.
- No incluir la respuesta.

---

## Prompt

```text
    Genera un único ejercicio de Ciencias Sociales utilizando la siguiente información.

    Edad: {edad}

    Grado: {grado}

    Materia: Ciencias Sociales

    Tema: {tema}

    Nivel: {nivel}

    Instrucciones:

        - Genera únicamente una actividad.
        - No reveles la respuesta.
        - Utiliza lenguaje sencillo y apropiado para niños.
        - Relaciona el ejercicio con situaciones cotidianas.
        - Siempre que sea posible utiliza ejemplos relacionados con Bolivia (familia, comunidad, departamentos, símbolos patrios, costumbres, historia, cultura o geografía).
        - Favorece el razonamiento antes que la memorización.
        - Devuelve únicamente un objeto JSON siguiendo el contrato JSON-04.
```

---

## Ejemplo de entrada

```text
Edad: 9 años

Grado: 4to de primaria

Tema: Símbolos Patrios

Nivel: Básico
```

---

## Ejemplo de salida

```json
{
  "tipo":"ejercicio",
  "titulo":"Nuestros símbolos patrios",
  "mensaje":"Observa y piensa con atención.",
  "contenido":{
    "enunciado":"¿Por qué crees que la bandera boliviana es importante para nuestro país?",
    "tipo_respuesta":"abierta"
  },
  "metadata":{
    "tema":"Símbolos Patrios",
    "nivel":"Básico"
  }
}
```

---

## Criterios de aceptación

✓ Genera un único ejercicio.

✓ Utiliza ejemplos cercanos al estudiante.

✓ Favorece el razonamiento.

✓ No muestra la respuesta.

✓ Devuelve un JSON válido.

---

## Observaciones

Este prompt debe utilizarse siempre junto con **SYS-01_System_Prompt** y respetar la estructura definida en **JSON-04_Ciencias_Sociales**.