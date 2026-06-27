# GUÍA DE INTEGRACIÓN

## Objetivo

Explicar cómo interactúan los prompts, los contratos JSON y los diferentes componentes del sistema durante una sesión de aprendizaje del estudiante.

Esta guía sirve como referencia para el equipo de Backend, Flutter y AI Engineer durante la integración del MVP Yachay AI.

---

# Arquitectura general

```
                Flutter
                   │
                   ▼
              Backend API
                   │
                   ▼
              Gemini API
                   │
                   ▼
      System Prompt (SYS-01)
                   │
                   ▼
      Prompt específico según módulo
                   │
                   ▼
        Respuesta estructurada (JSON)
                   │
                   ▼
              Backend API
                   │
                   ▼
                Flutter
```

---

# Flujo de Matemática

### Paso 1

El estudiante selecciona la materia **Matemática**.

### Paso 2

Flutter solicita un nuevo ejercicio.

### Paso 3

El Backend envía a Gemini:

* SYS-01
* MAT-01

### Paso 4

Gemini genera un ejercicio y responde utilizando el contrato **JSON-01**.

### Paso 5

Flutter presenta el ejercicio.

### Paso 6

El estudiante responde.

### Paso 7

Backend envía:

* SYS-01
* MAT-02

### Paso 8

Gemini analiza la respuesta y devuelve una retroalimentación educativa utilizando **JSON-01**.

### Paso 9

Si el estudiante solicita ayuda o presenta varias dificultades consecutivas, Backend envía:

* SYS-01
* MAT-03

Gemini genera una explicación guiada.

### Paso 10

Cuando existe suficiente historial de desempeño, Backend envía:

* SYS-01
* MAT-04

Gemini adapta la dificultad y genera el siguiente ejercicio.

---

# Flujo de Aymara

### Paso 1

El estudiante selecciona **Idioma Aymara**.

### Paso 2

Flutter solicita una nueva actividad.

### Paso 3

Backend envía:

* SYS-01
* AYM-01

### Paso 4

Gemini genera:

* palabra objetivo;
* significado;
* instrucción;
* texto para síntesis de voz.

La respuesta utiliza el contrato **JSON-02**.

### Paso 5

Flutter reproduce el audio generado.

### Paso 6

El estudiante pronuncia la palabra.

### Paso 7

Flutter envía el audio grabado al Backend.

### Paso 8

Backend envía a Gemini:

* SYS-01
* AYM-02
* palabra objetivo
* archivo de audio

### Paso 9

Gemini:

* transcribe el audio;
* compara la pronunciación;
* calcula una precisión aproximada;
* identifica dificultades fonéticas.

### Paso 10

Backend solicita:

* SYS-01
* AYM-03

Gemini genera una retroalimentación motivadora utilizando el contrato **JSON-02**.

### Paso 11

Flutter muestra:

* porcentaje de precisión;
* palabra detectada;
* observaciones;
* recomendaciones;
* botón para volver a intentar.

---

# Flujo de Ciencias Naturales

### Paso 1

El estudiante selecciona **Ciencias Naturales**.

### Paso 2

Backend envía:

* SYS-01
* NAT-01

### Paso 3

Gemini genera un ejercicio utilizando **JSON-03**.

### Paso 4

El estudiante responde.

### Paso 5

Backend envía:

* SYS-01
* NAT-02

Gemini analiza la respuesta.

### Paso 6

Si el estudiante necesita apoyo adicional:

* SYS-01
* NAT-03

Gemini explica el concepto paso a paso.

### Paso 7

Cuando existe historial suficiente:

* SYS-01
* NAT-04

Gemini adapta la dificultad y genera un nuevo ejercicio.

---

# Flujo de Ciencias Sociales

### Paso 1

El estudiante selecciona **Ciencias Sociales**.

### Paso 2

Backend envía:

* SYS-01
* SOC-01

### Paso 3

Gemini genera un ejercicio utilizando **JSON-04**.

### Paso 4

El estudiante responde.

### Paso 5

Backend envía:

* SYS-01
* SOC-02

Gemini analiza la respuesta.

### Paso 6

Si existen errores repetitivos:

* SYS-01
* SOC-03

Gemini explica el concepto utilizando ejemplos del contexto boliviano.

### Paso 7

Cuando corresponde:

* SYS-01
* SOC-04

Gemini adapta la dificultad y propone una nueva actividad.

---

# Prompts utilizados

| Prompt | Función                                        |
| ------ | ---------------------------------------------- |
| SYS-01 | Identidad y comportamiento del tutor Yachay    |
| MAT-01 | Generación de ejercicios de Matemática         |
| MAT-02 | Corrección inteligente                         |
| MAT-03 | Explicación guiada                             |
| MAT-04 | Práctica adaptativa                            |
| AYM-01 | Generación de práctica de pronunciación        |
| AYM-02 | Evaluación fonética                            |
| AYM-03 | Retroalimentación adaptativa                   |
| NAT-01 | Generación de ejercicios de Ciencias Naturales |
| NAT-02 | Corrección inteligente                         |
| NAT-03 | Explicación guiada                             |
| NAT-04 | Práctica adaptativa                            |
| SOC-01 | Generación de ejercicios de Ciencias Sociales  |
| SOC-02 | Corrección inteligente                         |
| SOC-03 | Explicación guiada                             |
| SOC-04 | Práctica adaptativa                            |

---

# Contratos JSON

| Archivo | Utilización        |
| ------- | ------------------ |
| JSON-01 | Matemática         |
| JSON-02 | Idioma Aymara      |
| JSON-03 | Ciencias Naturales |
| JSON-04 | Ciencias Sociales  |

Cada contrato define la estructura que Gemini debe devolver para que Backend y Flutter puedan procesar la información sin depender de texto libre.

---

# Flujo general de comunicación

```
Flutter
    │
    ▼
Selecciona materia
    │
    ▼
Backend
    │
    ▼
SYS-01
+
Prompt específico
    │
    ▼
Gemini
    │
    ▼
Respuesta JSON
    │
    ▼
Backend
    │
    ▼
Flutter actualiza la interfaz
```

---

# Resultado esperado

Con esta integración, el MVP de **Yachay AI** demuestra durante el hackathon un flujo completo de aprendizaje asistido por Inteligencia Artificial donde Gemini:

* genera actividades educativas;
* analiza las respuestas del estudiante;
* explica conceptos paso a paso;
* adapta la dificultad según el desempeño;
* evalúa la pronunciación en idioma aymara mediante capacidades multimodales;
* devuelve respuestas estructuradas en formato JSON;
* mantiene una identidad pedagógica consistente gracias al System Prompt;
* acompaña al estudiante como un tutor inteligente, motivador y adaptativo.

Esta arquitectura permite integrar fácilmente nuevos módulos educativos manteniendo la misma lógica de funcionamiento y reutilizando la infraestructura de prompts y contratos JSON definidos para el proyecto.
