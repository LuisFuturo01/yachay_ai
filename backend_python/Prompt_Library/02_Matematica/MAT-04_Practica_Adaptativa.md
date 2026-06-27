# PROMPT MAT-04

## Nombre

**Práctica Adaptativa de Matemática**

---

## Objetivo

Analizar el desempeño reciente del estudiante y decidir el siguiente paso pedagógico, ajustando automáticamente la dificultad del próximo ejercicio según sus fortalezas y dificultades para favorecer un aprendizaje progresivo y personalizado.

---

## Descripción

Este prompt representa el componente de **adaptación inteligente** de Yachay AI para Matemática.

Su función es interpretar el rendimiento reciente del estudiante, identificar patrones de aprendizaje y tomar decisiones pedagógicas antes de generar el siguiente ejercicio.

A diferencia de MAT-01, que únicamente crea actividades, este prompt primero evalúa el desempeño del estudiante y luego decide si debe:

* mantener el nivel actual;
* aumentar la dificultad;
* disminuir temporalmente la dificultad;
* reforzar un concepto específico.

La adaptación debe priorizar el aprendizaje antes que el avance de nivel, evitando que el estudiante se frustre o memorice respuestas sin comprender el concepto.

La respuesta se entrega en formato JSON para facilitar la integración con Flutter y el backend.

---

## Cuándo se utiliza

Después de que el estudiante completa uno o varios ejercicios de un mismo tema.

También puede ejecutarse al finalizar una sesión de práctica para determinar cuál será la siguiente actividad.

---

## Quién lo utiliza

* **Backend:** Envía el historial reciente de desempeño del estudiante.
* **Gemini:** Analiza el rendimiento y determina la siguiente estrategia de aprendizaje.
* **Flutter:** Presenta el mensaje motivador y el nuevo ejercicio adaptado.

---

## Entradas

| Parámetro              | Descripción                                           |
| ---------------------- | ----------------------------------------------------- |
| edad                   | Edad del estudiante                                   |
| grado                  | Curso escolar                                         |
| tema                   | Tema trabajado                                        |
| ejercicios_correctos   | Cantidad de ejercicios respondidos correctamente      |
| ejercicios_incorrectos | Cantidad de ejercicios respondidos incorrectamente    |
| errores_detectados     | Principales errores identificados durante la práctica |

---

## Salida esperada

Gemini debe:

* analizar el desempeño reciente;
* identificar fortalezas y dificultades;
* decidir el nivel adecuado para continuar;
* justificar brevemente la decisión pedagógica;
* generar un nuevo ejercicio adaptado;
* mantener un tono positivo y motivador.

---


## Formato de respuesta

Gemini debe responder únicamente con el siguiente objeto JSON.

```json
{
  "diagnostico": "",
  "decision_pedagogica": "",
  "justificacion": "",
  "nivel_siguiente": "",
  "mensaje": "",
  "nuevo_ejercicio": {
    "titulo": "",
    "tema": "",
    "nivel": "",
    "enunciado": "",
    "tipo_respuesta": "abierta"
  }
}
```

### Descripción de los campos

| Campo               | Descripción                                                   |
| ------------------- | ------------------------------------------------------------- |
| diagnostico         | Resumen del desempeño observado.                              |
| decision_pedagogica | Acción recomendada: mantener, aumentar, disminuir o reforzar. |
| justificacion       | Explicación breve de la decisión tomada.                      |
| nivel_siguiente     | Nivel recomendado para el siguiente ejercicio.                |
| mensaje             | Mensaje motivador dirigido al estudiante.                     |
| nuevo_ejercicio     | Nuevo ejercicio adaptado al desempeño del estudiante.         |

---

## Prompt

```text
Analiza el desempeño reciente del estudiante.

Edad:
{edad}

Grado:
{grado}

Tema:
{tema}

Ejercicios correctos:
{ejercicios_correctos}

Ejercicios incorrectos:
{ejercicios_incorrectos}

Errores detectados:
{errores_detectados}

Instrucciones:

- Analiza el rendimiento general del estudiante.
- Identifica fortalezas y dificultades observadas.
- Determina una única decisión pedagógica entre las siguientes opciones:
    • mantener dificultad;
    • aumentar dificultad;
    • disminuir dificultad;
    • reforzar el concepto.
- Si existen errores repetitivos, prioriza reforzar el concepto antes de aumentar el nivel.
- Justifica brevemente la decisión tomada.
- Genera un único ejercicio adaptado al nivel recomendado.
- No incluyas la respuesta correcta.
- Utiliza lenguaje apropiado para niños de 5 a 12 años.
- Siempre que sea posible utiliza ejemplos relacionados con situaciones cotidianas de Bolivia.
- Devuelve únicamente un objeto JSON con el formato especificado.
```

---


## Ejemplo de entrada

```text
Edad: 8 años

Grado: 3ro de Primaria

Tema:
Multiplicaciones

Ejercicios correctos:
1

Ejercicios incorrectos:
4

Errores detectados:
El estudiante confunde la multiplicación con la suma repetida y presenta dificultades para identificar grupos iguales.
```

---

## Ejemplo de salida

```json
{
  "diagnostico": "El estudiante demuestra interés por resolver los ejercicios, pero aún presenta dificultades para comprender la multiplicación como suma repetida.",
  "decision_pedagogica": "reforzar concepto",
  "justificacion": "Antes de aumentar la dificultad es importante fortalecer el concepto de grupos iguales para construir una base sólida.",
  "nivel_siguiente": "Básico",
  "mensaje": "¡Lo estás haciendo muy bien! 😊 Cada intento te ayuda a aprender. Practiquemos una vez más con un ejemplo parecido.",
  "nuevo_ejercicio": {
    "titulo": "Grupos de caramelos",
    "tema": "Multiplicaciones",
    "nivel": "Básico",
    "enunciado": "Lucía tiene 4 bolsitas y en cada una hay 3 caramelos. ¿Cuántos caramelos tiene en total?",
    "tipo_respuesta": "abierta"
  }
}
```

---

## Criterios de aceptación

✓ Analiza el desempeño reciente del estudiante.

✓ Identifica correctamente fortalezas y dificultades.

✓ Toma una decisión pedagógica coherente.

✓ No incrementa la dificultad cuando existen errores conceptuales repetitivos.

✓ Genera un ejercicio adaptado al nivel recomendado.

✓ Mantiene un tono positivo y motivador.

✓ Devuelve un JSON válido.

✓ Respeta las reglas establecidas en SYS-01.

---

## Observaciones

Este prompt implementa la **adaptación pedagógica** del MVP de Yachay AI y constituye una de las principales evidencias del uso de Inteligencia Artificial durante la demostración del hackathon.

Mientras que **MAT-01** genera ejercicios de forma estática, **MAT-04** toma decisiones basadas en el desempeño del estudiante para personalizar la experiencia de aprendizaje. Esto permite demostrar que Yachay AI no solo presenta actividades, sino que acompaña activamente el proceso educativo ajustando la dificultad según las necesidades individuales del niño.

---