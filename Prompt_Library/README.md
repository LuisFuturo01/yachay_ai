# Ingeniería de Prompts e Inteligencia Pedagógica

## Proyecto

**YACHAY AI**
Plataforma educativa con Inteligencia Artificial para niños y niñas de Bolivia.

---

# Descripción

Esta fase corresponde al trabajo realizado como **AI Engineer & Prompt Architect** dentro del hackathon **Build with AI La Paz 2026**.

El objetivo principal fue diseñar la inteligencia pedagógica del sistema, definiendo el comportamiento de Gemini para que actúe como un tutor educativo capaz de acompañar el aprendizaje de estudiantes de educación primaria, en lugar de responder como un chatbot conversacional.

Durante esta etapa no se entrenaron modelos de Machine Learning ni se desarrollaron modelos propios. En su lugar, se utilizó **Prompt Engineering** para controlar el comportamiento del modelo Gemini mediante instrucciones especializadas, contratos JSON y configuraciones orientadas a obtener respuestas consistentes, educativas y fáciles de integrar con el backend y la aplicación móvil.

---

# Objetivos de la fase

* Definir la identidad permanente del tutor virtual Yachay.
* Diseñar prompts especializados para Matemática.
* Diseñar prompts especializados para Ciencias Naturales.
* Diseñar prompts especializados para Ciencias Sociales.
* Diseñar prompts especializados para Idioma Aymara.
* Implementar estrategias de retroalimentación pedagógica.
* Diseñar aprendizaje adaptativo mediante IA.
* Definir contratos JSON para la integración con Backend y Flutter.
* Documentar la configuración recomendada del modelo Gemini.
* Implementar estrategias de control de alucinaciones.
* Validar el comportamiento de los prompts mediante Google AI Studio.
* Documentar el flujo completo de integración.

---

# Estructura del proyecto

```text
Prompt_Library/

├── 01_System_Prompt/
│   └── SYS-01_System_Prompt.md
│
├── 02_Matematica/
│   ├── MAT-01_Generacion_Ejercicios.md
│   ├── MAT-02_Correccion_Inteligente.md
│   ├── MAT-03_Explicacion_Guiada.md
│   └── MAT-04_Practica_Adaptativa.md
│
├── 03_Aymara/
│   ├── AYM-01_Generacion_Audios.md
│   ├── AYM-02_Evaluacion_Fonetica.md
│   └── AYM-03_Retroalimentacion.md
│
├── 04_Ciencias_Naturales/
│   ├── NAT-01_Generacion_Ejercicios.md
│   ├── NAT-02_Correccion_Inteligente.md
│   ├── NAT-03_Explicacion_Guiada.md
│   └── NAT-04_Practica_Adaptativa.md
│
├── 05_Ciencias_Sociales/
│   ├── SOC-01_Generacion_Ejercicios.md
│   ├── SOC-02_Correccion_Inteligente.md
│   ├── SOC-03_Explicacion_Guiada.md
│   └── SOC-04_Practica_Adaptativa.md
│
├── 06_JSON/
│   ├── JSON-01_Matematica.md
│   ├── JSON-02_Aymara.md
│   ├── JSON-03_Ciencias_Naturales.md
│   └── JSON-04_Ciencias_Sociales.md
│
├── 07_Test_Cases/
│   ├── TC-01_Multiplicaciones.md
│   ├── TC-02_Sumas.md
│   ├── TC-03_Aymara.md
│   ├── TC-04_Ciencias_Naturales.md
│   └── TC-05_Ciencias_Sociales.md
│
├── 08_Integracion/
│   └── Guia_Integracion.md
│
├── 09_Model_Config/
│   ├── Gemini_Config.md
│   ├── AI_Studio_Settings.md
│   └── Hallucination_Control.md
│
└── README.md
```

---

# Componentes desarrollados

## 1. System Prompt

Se diseñó un System Prompt permanente que define la identidad del tutor Yachay durante toda la conversación.

Este prompt establece reglas pedagógicas relacionadas con:

* identidad del tutor;
* tono de comunicación;
* comportamiento educativo;
* razonamiento guiado;
* adaptación al nivel del estudiante;
* uso de ejemplos del contexto boliviano;
* restricciones para evitar respuestas automáticas.

Todos los prompts especializados dependen de este componente.

---

## 2. Prompts de Matemática

Se desarrolló una biblioteca completa para Matemática compuesta por cuatro prompts especializados:

### MAT-01

Generación de ejercicios.

### MAT-02

Corrección inteligente.

### MAT-03

Explicación guiada paso a paso.

### MAT-04

Práctica adaptativa según el desempeño del estudiante.

---

## 3. Prompts de Ciencias Naturales

Se diseñó una biblioteca equivalente para Ciencias Naturales enfocada en la comprensión de fenómenos y conceptos científicos mediante ejemplos cotidianos.

Incluye:

* generación de actividades;
* retroalimentación educativa;
* explicación guiada;
* adaptación progresiva de dificultad.

---

## 4. Prompts de Ciencias Sociales

Se desarrolló una biblioteca para Ciencias Sociales orientada al aprendizaje del entorno, la historia, la cultura y la ciudadanía mediante actividades contextualizadas.

Incluye:

* generación de ejercicios;
* corrección inteligente;
* explicación paso a paso;
* práctica adaptativa.

---

## 5. Prompts de Idioma Aymara

Se diseñó un módulo especializado para el aprendizaje del idioma aymara utilizando las capacidades multimodales de Gemini.

Comprende:

### AYM-01

Generación de palabras y actividades.

### AYM-02

Evaluación fonética mediante análisis de audio.

### AYM-03

Retroalimentación adaptativa sobre la pronunciación.

El diseño contempla la evolución futura hacia reconocimiento de voz utilizando Gemini y Vertex AI.

---

## 6. Contratos JSON

Se documentaron contratos JSON estandarizados para cada módulo educativo.

Estos contratos permiten una comunicación uniforme entre:

* Gemini;
* Backend;
* Flutter.

Gracias a esta estructura, la interfaz puede procesar las respuestas sin depender de texto libre.

---

## 7. Casos de prueba

Se documentaron escenarios funcionales para validar el comportamiento del sistema.

Cada caso de prueba incluye:

* objetivo;
* componentes evaluados;
* datos de entrada;
* resultado esperado;
* ejemplo de respuesta;
* criterios de aceptación.

Los casos cubren Matemática, Idioma Aymara, Ciencias Naturales y Ciencias Sociales.

---

## 8. Configuración del modelo

Se documentó la configuración recomendada para utilizar Gemini dentro del proyecto.

Incluye:

* modelo recomendado;
* temperatura;
* longitud máxima;
* formato JSON;
* recomendaciones para Google AI Studio;
* preparación para integración mediante Vertex AI.

---

## 9. Control de alucinaciones

Se definieron estrategias para reducir respuestas inconsistentes del modelo.

Entre ellas:

* temperatura baja;
* instrucciones estrictas;
* contratos JSON;
* validación estructurada;
* separación entre System Prompt y prompts específicos;
* respuestas controladas para el entorno educativo.

---

## 10. Integración

Se documentó el flujo completo de interacción entre la aplicación y Gemini.

```text
Flutter

↓

Backend

↓

Gemini API

↓

System Prompt

↓

Prompt especializado

↓

Respuesta JSON

↓

Backend

↓

Flutter
```

También se documentó la responsabilidad de cada componente dentro de la arquitectura del MVP.

---

# Validación

La validación funcional se realizó utilizando **Google AI Studio**.

Durante las pruebas se verificó:

* mantenimiento de la identidad del tutor;
* cumplimiento de las reglas pedagógicas;
* adaptación del nivel de dificultad;
* consistencia del formato JSON;
* respuestas ante entradas inválidas;
* retroalimentación educativa;
* funcionamiento del aprendizaje adaptativo;
* evaluación fonética para el módulo de Aymara.

Debido a que Vertex AI requiere la configuración de facturación en Google Cloud, las pruebas funcionales del hackathon se realizaron íntegramente en Google AI Studio, garantizando la compatibilidad posterior con la API de Gemini.

---

# Herramientas utilizadas

Durante esta fase se utilizaron las siguientes tecnologías:

* Gemini API
* Google AI Studio
* Vertex AI (configuración documentada para integración)
* Markdown
* JSON

La ingeniería de prompts fue diseñada para ser compatible con futuras implementaciones mediante Vertex AI sin modificar la lógica pedagógica desarrollada.

---

# Alcance

Esta fase incluye:

* diseño del comportamiento de Gemini;
* ingeniería de prompts;
* diseño pedagógico;
* contratos JSON;
* configuración del modelo;
* documentación técnica;
* validación funcional;
* integración conceptual con Backend y Flutter.

No incluye:

* entrenamiento de modelos;
* creación de modelos propios;
* infraestructura en Google Cloud;
* desarrollo del backend;
* desarrollo de Flutter;
* despliegue en producción.

---

# Resultados

Al finalizar esta fase se obtuvo:

* un System Prompt completamente definido;
* bibliotecas de prompts para cuatro áreas de aprendizaje;
* contratos JSON estandarizados;
* documentación técnica de integración;
* configuración recomendada para Gemini;
* estrategias de control de alucinaciones;
* casos de prueba funcionales;
* guía de uso en Google AI Studio;
* documentación preparada para integración mediante Vertex AI.

Todo el material desarrollado constituye la base de la inteligencia pedagógica utilizada por YACHAY AI durante la demostración del hackathon.

---

# Próxima fase

La siguiente etapa del proyecto consiste en integrar la biblioteca de prompts mediante la API de Gemini para que el backend pueda consumirlos y enviar las respuestas estructuradas a la aplicación Flutter.

Esta integración permitirá demostrar un flujo completo donde Yachay AI genera actividades, analiza respuestas, adapta la dificultad y acompaña el aprendizaje del estudiante como un tutor inteligente.
