# CONFIGURACIÓN DE GOOGLE AI STUDIO

## Objetivo

Documentar la configuración utilizada durante el diseño, desarrollo y validación de los prompts de Yachay AI en Google AI Studio.

Este documento permite que cualquier integrante del equipo pueda reproducir las mismas pruebas realizadas por el AI Engineer.

---

# Plataforma utilizada

**Google AI Studio**

Modelo utilizado durante las pruebas:

```
Gemini 3.5 Flash Lite
```

---

# Configuración utilizada

| Parámetro         | Valor utilizado                  |
| ----------------- | -------------------------------- |
| Modelo            | Gemini 3.5 Flash Lite            |
| Thinking Level    | Minimal                          |
| Structured Output | Activado cuando se requería JSON |
| Function Calling  | Desactivado                      |
| Code Execution    | Desactivado                      |
| Grounding         | Desactivado                      |
| URL Context       | Desactivado                      |
| Media Resolution  | Default                          |
| Output Length     | 65536                            |
| Stop Sequences    | No utilizadas                    |

---

# Configuración de Safety

Se mantuvo la configuración predeterminada de Google AI Studio.

No fue necesario modificar los filtros de seguridad debido a que el proyecto genera exclusivamente contenido educativo dirigido a niños.

---

# Prompts cargados

Durante las pruebas se utilizaron los siguientes prompts:

## Prompt principal

* SYS-01

## Matemática

* MAT-01
* MAT-02
* MAT-03
* MAT-04

## Idioma Aymara

* AYM-01
* AYM-02
* AYM-03

## Ciencias Naturales

* NAT-01
* NAT-02
* NAT-03
* NAT-04

## Ciencias Sociales

* SOC-01
* SOC-02
* SOC-03
* SOC-04

---

# Contratos JSON utilizados

* JSON-01
* JSON-02
* JSON-03
* JSON-04

Estos contratos permitieron validar que Gemini devolviera respuestas estructuradas y consistentes durante las pruebas.

---

# Tipo de pruebas realizadas

Se realizaron pruebas para validar:

* generación de ejercicios;
* corrección inteligente;
* explicaciones guiadas;
* práctica adaptativa;
* evaluación fonética en aymara;
* generación de respuestas JSON;
* mantenimiento de la identidad pedagógica de Yachay.

---

# Observaciones

Google AI Studio fue utilizado como entorno de experimentación para diseñar y ajustar el comportamiento de Gemini antes de su futura integración mediante API.

Durante el hackathon no fue necesario desplegar infraestructura adicional ni configurar servicios avanzados de Google Cloud.
