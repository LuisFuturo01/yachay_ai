# CONTROL DE ALUCINACIONES

## Objetivo

Definir las estrategias utilizadas para minimizar respuestas inconsistentes, información inventada y formatos incorrectos generados por Gemini durante el funcionamiento de Yachay AI.

---

# ¿Qué es una alucinación?

Una alucinación ocurre cuando un modelo de Inteligencia Artificial genera información incorrecta, inventada o inconsistente que no fue solicitada o que no respeta las instrucciones recibidas.

En un entorno educativo esto puede provocar:

* respuestas incorrectas;
* formatos JSON inválidos;
* explicaciones confusas;
* cambios inesperados en el comportamiento del tutor.

---

# Estrategias implementadas

## 1. System Prompt estricto

SYS-01 define la identidad permanente de Yachay.

Esto evita que Gemini responda como un chatbot genérico y mantiene un comportamiento pedagógico consistente.

---

## 2. Prompts especializados

Cada tarea utiliza un prompt independiente.

Ejemplos:

* MAT-01 únicamente genera ejercicios.
* MAT-02 únicamente corrige respuestas.
* MAT-03 únicamente explica conceptos.
* AYM-02 únicamente evalúa pronunciación.

Separar responsabilidades reduce la probabilidad de respuestas ambiguas.

---

## 3. Temperature baja

Se recomienda utilizar:

```
Temperature = 0.3
```

Una temperatura baja produce respuestas más estables y reduce la variabilidad en ejercicios, explicaciones y estructuras JSON.

---

## 4. Contratos JSON

Cada módulo utiliza un contrato JSON previamente definido.

Gemini debe respetar exactamente esa estructura.

Esto evita:

* campos inesperados;
* nombres inconsistentes;
* respuestas difíciles de procesar por el backend.

---

## 5. Validación en Google AI Studio

Cada prompt fue probado manualmente verificando:

* identidad del tutor;
* lenguaje apropiado;
* coherencia pedagógica;
* estructura JSON;
* adaptación de dificultad;
* retroalimentación motivadora.

---

# Buenas prácticas

Antes de incorporar un nuevo prompt al proyecto se recomienda verificar:

✓ Mantiene la identidad de Yachay.

✓ No entrega respuestas inmediatamente.

✓ Utiliza lenguaje adecuado para niños.

✓ Devuelve JSON válido cuando corresponde.

✓ No mezcla funciones de distintos prompts.

✓ Respeta el límite de longitud establecido.

---

# Resultado esperado

Aplicando estas estrategias se obtiene un tutor educativo consistente, capaz de generar respuestas predecibles, estructuradas y apropiadas para estudiantes de educación primaria.

---

# Observaciones

El control de alucinaciones en este proyecto se basa principalmente en el diseño de prompts, la configuración del modelo y la validación manual en Google AI Studio, sin necesidad de entrenar modelos personalizados ni modificar la arquitectura interna de Gemini.
