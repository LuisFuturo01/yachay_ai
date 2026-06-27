# PROMPT AYM-03

## Nombre

Retroalimentación Adaptativa de Pronunciación

---

## Objetivo

Interpretar el resultado de la evaluación fonética y decidir el siguiente paso pedagógico para el estudiante.

La dificultad y las recomendaciones deben adaptarse según el nivel de pronunciación detectado.

---

## Cuándo se utiliza

Después de recibir el resultado generado por el prompt AYM-02.

---

## Quién lo utiliza

* **Backend:** Envía el resultado de la evaluación fonética.
* **Gemini:** Decide la acción pedagógica.
* **Flutter:** Muestra el mensaje y la siguiente actividad.

---

## Entradas

| Parámetro               | Descripción                |
| ----------------------- | -------------------------- |
| palabra_objetivo        | Palabra practicada         |
| precision_porcentaje    | Resultado de la evaluación |
| observaciones_foneticas | Errores detectados         |

---

## Salida esperada

Gemini debe devolver un único objeto JSON indicando:

* mensaje para el estudiante;
* acción recomendada;
* dificultad siguiente;
* nueva palabra si corresponde.

---

## Prompt

```text
    Analiza el resultado de la evaluación fonética.

    Palabra:

    {palabra_objetivo}

    Precisión:

    {precision_porcentaje}

    Observaciones:

    {observaciones_foneticas}

    Reglas pedagógicas:

    - Si la precisión es mayor o igual al 90 %, felicita al estudiante y genera una nueva palabra del mismo nivel.
    - Si la precisión está entre 70 % y 89 %, felicita al estudiante e invita a repetir una vez más la misma palabra.
    - Si la precisión es menor al 70 %, explica brevemente qué sonido debe mejorar y selecciona una palabra más sencilla para reforzar la pronunciación.
    - Mantén siempre un tono positivo y motivador.

    Devuelve únicamente el siguiente JSON:

    {
    "mensaje": "",
    "accion": "",
    "siguiente_nivel": "",
    "proxima_palabra": ""
    }
```

---

## Ejemplo de entrada

```text
Palabra:

Jallalla

Precisión:

88

Observaciones:

La doble "ll" se pronunció con poca intensidad.
```

---

## Ejemplo de salida

```json
    {
    "mensaje": "¡Muy buen trabajo! 😊 Pronunciaste la palabra casi perfectamente. Vamos a repetirla una vez más para fortalecer el sonido 'll'.",
    "accion": "repetir",
    "siguiente_nivel": "Básico",
    "proxima_palabra": "Jallalla"
    }
```

---

## Criterios de aceptación

✓ La decisión depende del porcentaje de precisión.

✓ La retroalimentación es educativa y motivadora.

✓ La siguiente actividad se adapta al desempeño del estudiante.

✓ Devuelve un JSON válido.

---

## Observaciones

Este prompt representa la **inteligencia adaptativa** del módulo de pronunciación. No solo evalúa el desempeño del estudiante, sino que decide el siguiente paso de aprendizaje, demostrando una experiencia personalizada basada en IA, uno de los objetivos principales del MVP de YACHAY AI para la hackathon.
