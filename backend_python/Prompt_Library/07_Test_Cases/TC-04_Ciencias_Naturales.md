# CASO DE PRUEBA TC-04

## Nombre

**Aprendizaje Adaptativo de Ciencias Naturales**

---

## Objetivo

Validar que Yachay AI pueda generar ejercicios, corregir respuestas, explicar conceptos y adaptar la dificultad durante una sesión de aprendizaje de Ciencias Naturales.

---

## Descripción

Este caso evalúa el funcionamiento conjunto de los prompts del módulo de Ciencias Naturales.

Se verifica que Gemini pueda:

- generar un ejercicio;
- analizar la respuesta del estudiante;
- explicar el concepto cuando exista una dificultad;
- adaptar el siguiente ejercicio según el desempeño.

---

## Componentes evaluados

- SYS-01
- NAT-01
- NAT-02
- NAT-03
- NAT-04

---

## Datos de entrada

```text
Edad:
8 años

Grado:
3ro de Primaria

Tema:
Seres vivos

Nivel:
Básico

Ejercicio:
¿Cuál de estos es un ser vivo?

A) Piedra
B) Árbol
C) Mesa

Respuesta del estudiante:
Piedra
```

---

## Resultado esperado

Gemini debe:

- reconocer que la respuesta es incorrecta;
- felicitar el esfuerzo;
- explicar qué caracteriza a un ser vivo;
- utilizar un ejemplo cotidiano;
- formular una pregunta guiada;
- generar un nuevo ejercicio de refuerzo sin aumentar la dificultad.

---

## Ejemplo de respuesta esperada

```json
{
  "correcto": false,
  "mensaje": "¡Buen intento! 😊",
  "analisis": "Estás aprendiendo a identificar los seres vivos.",
  "explicacion": "Los seres vivos nacen, crecen, se alimentan y pueden reproducirse.",
  "pista": "Piensa cuál de las opciones puede crecer con el tiempo.",
  "pregunta_guiada": "¿Una piedra puede crecer por sí sola?",
  "nuevo_intento": true,
  "nivel": "Básico"
}
```

---

## Criterios de aceptación

✓ Genera retroalimentación educativa.

✓ Utiliza lenguaje apropiado para niños.

✓ No revela únicamente si está bien o mal.

✓ Formula una pregunta guiada.

✓ Mantiene la identidad pedagógica de Yachay.

✓ Devuelve un JSON válido.

---

## Observaciones

Este caso demuestra la capacidad de Gemini para actuar como tutor educativo en Ciencias Naturales, reforzando conceptos antes de incrementar la dificultad y manteniendo un aprendizaje adaptativo durante toda la interacción.