# CASO DE PRUEBA TC-02

## Nombre

**Generación y Corrección de Ejercicios de Suma**

---

## Objetivo

Validar que Yachay AI pueda generar ejercicios básicos de suma y proporcionar retroalimentación educativa adaptada al desempeño del estudiante.

---

## Descripción

Este caso evalúa la generación de ejercicios mediante MAT-01 y la retroalimentación mediante MAT-02.

---

## Componentes evaluados

- SYS-01
- MAT-01
- MAT-02

---

## Datos de entrada

```text
Edad:
6 años

Grado:
1ro de Primaria

Tema:
Sumas

Nivel:
Básico

Ejercicio:
5 + 4 = ?

Respuesta del estudiante:
8
```

---

## Resultado esperado

Gemini debe:

- detectar el error;
- explicar qué significa sumar;
- utilizar un ejemplo sencillo;
- formular una pregunta;
- solicitar un nuevo intento.

---

## Ejemplo de respuesta esperada

```json
{
  "correcto": false,
  "mensaje": "¡Muy bien por intentarlo! 😊",
  "analisis": "Casi lo logras.",
  "explicacion": "Sumar significa juntar cantidades.",
  "pista": "Cuenta cinco dedos y luego agrega cuatro más.",
  "pregunta_guiada": "¿Cuántos dedos tienes ahora?",
  "nuevo_intento": true
}
```

---

## Criterios de aceptación

✓ Utiliza lenguaje sencillo.

✓ Detecta correctamente el error.

✓ No revela inmediatamente la respuesta.

✓ Formula una pregunta guiada.

✓ Mantiene una actitud positiva.

---

## Observaciones

Este caso demuestra que la lógica pedagógica funciona para otros temas matemáticos además de las multiplicaciones.