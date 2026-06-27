# PROMPT MAT-02

## Nombre

**Corrección Inteligente de Respuestas**

---

## Objetivo

Analizar la respuesta enviada por el estudiante, identificar si es correcta o incorrecta, detectar posibles errores conceptuales y generar una retroalimentación pedagógica que favorezca el razonamiento antes que la memorización.

---

## Descripción

Este prompt constituye el núcleo del tutor inteligente de Matemática. Su función no es únicamente verificar si una respuesta es correcta, sino comprender el posible razonamiento del estudiante, identificar errores frecuentes y ofrecer una guía personalizada que le permita descubrir la respuesta por sí mismo.

La retroalimentación debe seguir las reglas establecidas en el System Prompt, manteniendo un tono motivador y evitando revelar inmediatamente la solución cuando exista un error.

La respuesta se devuelve en formato JSON para facilitar su integración con Flutter y permitir mostrar cada componente de la retroalimentación de forma independiente.

---

## Cuándo se utiliza

Después de que el estudiante responde un ejercicio de Matemática.

---

## Quién lo utiliza

* **Backend:** Envía el ejercicio y la respuesta del estudiante.
* **Gemini:** Analiza la respuesta y genera la retroalimentación.
* **Flutter:** Presenta el mensaje, las pistas y las preguntas guiadas al estudiante.

---

## Entradas

| Parámetro            | Descripción                         |
| -------------------- | ----------------------------------- |
| edad                 | Edad del estudiante                 |
| grado                | Curso escolar                       |
| tema                 | Tema trabajado                      |
| ejercicio            | Ejercicio presentado                |
| respuesta_estudiante | Respuesta enviada por el estudiante |

---

## Salida esperada

Gemini debe:

    * analizar la respuesta del estudiante;
    * identificar si es correcta;
    * detectar posibles errores conceptuales;
    * explicar el concepto relacionado;
    * generar una pista cuando sea necesario;
    * formular una pregunta guiada;
    * decidir si el estudiante debe realizar un nuevo intento.

---

## Formato de respuesta

Gemini debe responder únicamente con el siguiente JSON.

```json
{
  "correcto": false,
  "mensaje": "",
  "analisis": "",
  "explicacion": "",
  "pista": "",
  "pregunta_guiada": "",
  "nuevo_intento": true,
  "reto": ""
}
```

### Descripción de los campos

| Campo           | Descripción                                                   |
| --------------- | ------------------------------------------------------------- |
| correcto        | Indica si la respuesta es correcta.                           |
| mensaje         | Mensaje inicial de motivación.                                |
| analisis        | Explicación breve del resultado obtenido por el estudiante.   |
| explicacion     | Explicación del concepto matemático involucrado.              |
| pista           | Ayuda para orientar el siguiente intento. Vacío si no aplica. |
| pregunta_guiada | Pregunta que incentive el razonamiento.                       |
| nuevo_intento   | Indica si el estudiante debe volver a intentar el ejercicio.  |
| reto            | Pequeño reto adicional cuando la respuesta fue correcta.      |

---

## Prompt

```text
    Analiza la respuesta enviada por el estudiante.

    Edad:
    {edad}

    Grado:
    {grado}

    Tema:
    {tema}

    Ejercicio:
    {ejercicio}

    Respuesta del estudiante:
    {respuesta_estudiante}

    Instrucciones:

    - Analiza el posible razonamiento utilizado por el estudiante.
    - Si la respuesta es correcta:
        • felicita primero el esfuerzo;
        • explica brevemente por qué la respuesta es correcta;
        • propone un pequeño reto relacionado con el mismo tema.
    - Si la respuesta es incorrecta:
        • no digas únicamente que está mal;
        • no reveles inmediatamente la respuesta correcta;
        • identifica el posible error conceptual;
        • explica el concepto utilizando palabras sencillas;
        • proporciona una única pista;
        • formula una pregunta guiada;
        • invita al estudiante a intentarlo nuevamente.
    - Utiliza un lenguaje apropiado para niños y evita respuestas demasiado largas.
    - Devuelve únicamente un objeto JSON con el formato especificado.
```

---

## Ejemplo de entrada

```text
    Ejercicio:

    7 × 8 = ?

    Respuesta del estudiante:

    54
```

---

## Ejemplo de salida

```text
¡Buen intento! 😊

Estás muy cerca.

Recuerda que multiplicar significa formar grupos iguales.

Si sabes cuánto es 7 × 7, solamente debes agregar otro grupo de 7.

¿Qué resultado obtienes ahora?
```

---

## Criterios de aceptación

✓ No entrega inmediatamente la respuesta.

✓ Explica el error.

✓ Motiva al estudiante.

✓ Formula una pregunta.

✓ Mantiene el tono de Yachay.

---

## Observaciones

Debe utilizarse siempre junto con SYS-01.
