# PROMPT MAT-01

## Nombre

**Generación de Ejercicios de Matemática**

---

## Objetivo

Generar un ejercicio de matemática adaptado a la edad, grado escolar, tema y nivel de dificultad del estudiante, promoviendo el razonamiento y evitando revelar la respuesta correcta.

---

## Descripción

Este prompt es el punto de inicio de una sesión de práctica de Matemática. Su función es crear actividades educativas contextualizadas que permitan al estudiante aplicar sus conocimientos de manera progresiva.

Los ejercicios deben ser adecuados para la edad del estudiante, utilizar un lenguaje sencillo y, siempre que sea posible, incorporar situaciones cotidianas relacionadas con el contexto boliviano para favorecer un aprendizaje más significativo.

La respuesta generada por Gemini debe ser estructurada en formato JSON para facilitar su procesamiento por el backend y su visualización en Flutter.

---

## Cuándo se utiliza

Al iniciar una sesión de práctica o cuando el estudiante solicita un nuevo ejercicio.

---

## Quién lo utiliza

* **Backend:** Envía la información del estudiante y solicita un nuevo ejercicio.
* **Gemini:** Genera el ejercicio siguiendo las reglas pedagógicas definidas en SYS-01.
* **Flutter:** Presenta el ejercicio al estudiante.

---

## Entradas

| Parámetro | Descripción                                                 |
| --------- | ----------------------------------------------------------- |
| edad      | Edad del estudiante                                         |
| grado     | Curso escolar                                               |
| materia   | Matemática                                                  |
| tema      | Tema específico (Multiplicaciones, Sumas, Fracciones, etc.) |
| nivel     | Básico, Intermedio o Avanzado                               |

---

## Salida esperada

Gemini debe generar un único ejercicio de matemática adaptado al perfil del estudiante.

El ejercicio debe:

* ser apropiado para la edad;
* respetar el nivel de dificultad solicitado;
* utilizar lenguaje sencillo;
* incluir un contexto cotidiano cuando sea posible;
* no mostrar la respuesta correcta;
* permitir que el estudiante responda por sí mismo.

---

## Formato de respuesta

Gemini debe responder **únicamente** con el siguiente objeto JSON:

```json
{
  "titulo": "",
  "tema": "",
  "nivel": "",
  "enunciado": "",
  "tipo_respuesta": "abierta"
}
```

### Descripción de los campos

| Campo          | Descripción                                                      |
| -------------- | ---------------------------------------------------------------- |
| titulo         | Nombre corto de la actividad.                                    |
| tema           | Tema matemático trabajado.                                       |
| nivel          | Nivel de dificultad del ejercicio.                               |
| enunciado      | Texto completo del ejercicio.                                    |
| tipo_respuesta | Tipo de respuesta esperada ("abierta", "opción múltiple", etc.). |

---

## Prompt

```text
    Genera un único ejercicio de matemática utilizando la siguiente información del estudiante.

    Edad: {edad}

    Grado: {grado}

    Materia: {materia}

    Tema: {tema}

    Nivel: {nivel}

    Instrucciones:
        - Genera únicamente un ejercicio.
        - No incluyas la respuesta.
        - Utiliza lenguaje sencillo para niños de 5 a 12 años.
        - Adapta la dificultad al nivel indicado.
        - Cuando sea posible utiliza ejemplos relacionados con la vida cotidiana del estudiante (familia, escuela, mercado, animales, juegos o situaciones comunes en Bolivia).
        - No agregues explicaciones adicionales.
        - Evita ejercicios excesivamente largos.
        - Devuelve únicamente un objeto JSON con el formato especificado.
```

---

## Ejemplo de entrada

```text
Edad: 8 años

Grado: 3ro de Primaria

Materia: Matemática

Tema: Multiplicaciones

Nivel: Básico
```

---

## Ejemplo de salida

```json
{
  "titulo": "Multiplicando grupos iguales",
  "tema": "Multiplicaciones",
  "nivel": "Básico",
  "enunciado": "María fue al mercado y compró 6 bolsas de naranjas. En cada bolsa hay 4 naranjas. ¿Cuántas naranjas compró en total?",
  "tipo_respuesta": "abierta"
}
```

---

## Criterios de aceptación

✓ Genera un único ejercicio.

✓ No revela la respuesta.

✓ La dificultad corresponde al nivel solicitado.

✓ El lenguaje es apropiado para niños.

✓ El contexto favorece el aprendizaje significativo.

✓ Devuelve un JSON válido.

✓ El ejercicio puede mostrarse directamente en Flutter sin modificaciones.

---

## Observaciones

Este prompt debe utilizarse siempre junto con **SYS-01**.

La respuesta en formato JSON permite que el backend procese fácilmente la actividad y que Flutter presente el ejercicio de manera uniforme.

En futuras versiones podrán incorporarse nuevos tipos de ejercicios (opción múltiple, verdadero/falso, completar espacios, problemas con imágenes o actividades multimodales) manteniendo la misma estructura de respuesta.
