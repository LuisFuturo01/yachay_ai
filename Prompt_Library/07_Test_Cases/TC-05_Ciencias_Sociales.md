# CASO DE PRUEBA TC-05

## Nombre

**Aprendizaje Adaptativo de Ciencias Sociales**

---

## Objetivo

Validar que Yachay AI pueda generar actividades de Ciencias Sociales, corregir respuestas, explicar conceptos relacionados con Bolivia y adaptar la dificultad según el desempeño del estudiante.

---

## Descripción

Este caso evalúa el funcionamiento conjunto de los prompts del módulo de Ciencias Sociales.

Se verifica que Gemini pueda:

- generar un ejercicio;
- analizar la respuesta del estudiante;
- explicar el concepto cuando exista una dificultad;
- adaptar el siguiente ejercicio según el progreso observado.

---

## Componentes evaluados

- SYS-01
- SOC-01
- SOC-02
- SOC-03
- SOC-04

---

## Datos de entrada

```text
Edad:
9 años

Grado:
4to de Primaria

Tema:
Símbolos Patrios de Bolivia

Nivel:
Básico

Ejercicio:
¿Cuál es la bandera oficial de Bolivia?

Respuesta del estudiante:
La bandera de La Paz.
```

---

## Resultado esperado

Gemini debe:

- detectar el error conceptual;
- felicitar el esfuerzo;
- explicar la diferencia entre un símbolo patrio nacional y un símbolo departamental;
- utilizar un ejemplo relacionado con Bolivia;
- formular una pregunta guiada;
- generar un nuevo ejercicio manteniendo el mismo nivel de dificultad.

---

## Ejemplo de respuesta esperada

```json
{
  "correcto": false,
  "mensaje": "¡Buen intento! 😊",
  "analisis": "Estás relacionando símbolos importantes de Bolivia.",
  "explicacion": "Cada departamento tiene sus propios símbolos, pero Bolivia también tiene símbolos que representan a todo el país.",
  "pista": "Piensa en la bandera con tres franjas de colores que vemos en los actos escolares.",
  "pregunta_guiada": "¿Recuerdas cuáles son esos tres colores?",
  "nuevo_intento": true,
  "nivel": "Básico"
}
```

---

## Criterios de aceptación

✓ Detecta correctamente el error.

✓ Explica el concepto utilizando ejemplos del contexto boliviano.

✓ Utiliza lenguaje sencillo.

✓ Motiva al estudiante.

✓ Genera una pregunta guiada.

✓ Devuelve un JSON válido.

---

## Observaciones

Este caso demuestra que Gemini puede actuar como un tutor de Ciencias Sociales, promoviendo el razonamiento y el aprendizaje progresivo sobre la historia, cultura y organización de Bolivia sin limitarse a indicar respuestas correctas o incorrectas.