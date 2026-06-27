# CASO DE PRUEBA TC-01

## Nombre

**Corrección Inteligente de Multiplicaciones**

---

## Objetivo

Verificar que Yachay AI actúe como un tutor educativo durante la resolución de ejercicios de multiplicación, guiando al estudiante sin proporcionar inmediatamente la respuesta correcta.

---

## Descripción

Este caso de prueba valida el comportamiento conjunto del System Prompt (SYS-01) y los prompts de Matemática (MAT-02 y MAT-03).

El objetivo es comprobar que Gemini:

- detecte errores correctamente;
- genere retroalimentación pedagógica;
- formule preguntas guiadas;
- motive al estudiante;
- espere un nuevo intento antes de revelar la solución.

---

## Componentes evaluados

- SYS-01
- MAT-02
- MAT-03

---

## Datos de entrada

```text
Edad:
8 años

Grado:
3ro de Primaria

Materia:
Matemática

Tema:
Multiplicaciones

Ejercicio:
7 × 8 = ?

Respuesta del estudiante:
54
```

---

## Resultado esperado

Gemini debe:

- felicitar el esfuerzo;
- identificar que la respuesta es incorrecta;
- explicar el concepto de multiplicación;
- proporcionar una pista;
- formular una pregunta guiada;
- solicitar un nuevo intento.

No debe revelar inmediatamente que la respuesta correcta es 56.

---

## Ejemplo de respuesta esperada

```json
{
  "correcto": false,
  "mensaje": "¡Buen intento! 😊",
  "analisis": "Tu respuesta está muy cerca.",
  "explicacion": "Multiplicar significa sumar grupos iguales.",
  "pista": "Recuerda cuánto es 7 × 7.",
  "pregunta_guiada": "¿Qué ocurre si sumas otro grupo de 7?",
  "nuevo_intento": true
}
```

---

## Criterios de aceptación

✓ No revela inmediatamente la respuesta.

✓ Mantiene el rol de tutor.

✓ Utiliza lenguaje apropiado.

✓ Formula preguntas.

✓ Motiva al estudiante.

✓ Devuelve un JSON válido.

---

## Observaciones

Este caso demuestra la principal funcionalidad pedagógica del MVP: enseñar mediante razonamiento y acompañamiento, en lugar de responder automáticamente.