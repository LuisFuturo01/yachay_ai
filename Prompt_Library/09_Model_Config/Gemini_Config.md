# CONFIGURACIÓN DEL MODELO GEMINI

## Objetivo

Documentar la configuración recomendada del modelo Gemini para el funcionamiento del MVP Yachay AI.

Estos parámetros fueron seleccionados para priorizar respuestas educativas consistentes, estables y fáciles de interpretar por el backend.

---

# Modelo recomendado

```
Gemini 3.5 Flash Lite
```

Este modelo ofrece un equilibrio entre velocidad de respuesta, costo y capacidad de razonamiento, siendo adecuado para un MVP educativo presentado durante un hackathon.

---

# Configuración recomendada

| Parámetro          | Valor recomendado                     | Justificación                                                                         |
| ------------------ | ------------------------------------- | ------------------------------------------------------------------------------------- |
| Modelo             | Gemini 3.5 Flash Lite                 | Buen rendimiento y baja latencia.                                                     |
| Temperature        | 0.3                                   | Reduce respuestas aleatorias y mejora la consistencia.                                |
| Max Output Tokens  | 512                                   | Suficiente para explicaciones educativas sin generar respuestas excesivamente largas. |
| Response MIME Type | application/json (cuando corresponda) | Facilita la integración con Backend y Flutter.                                        |
| Thinking Level     | Minimal                               | Disminuye el tiempo de respuesta durante la demo.                                     |

---

# Configuración para respuestas educativas

El modelo debe priorizar:

* claridad;
* consistencia;
* lenguaje sencillo;
* razonamiento guiado;
* respuestas estructuradas.

Debe evitar:

* respuestas demasiado extensas;
* cambios innecesarios de formato;
* múltiples soluciones simultáneas;
* contenido fuera del contexto educativo.

---

# Configuración para respuestas JSON

Cuando un prompt solicite un JSON:

* no agregar texto antes del objeto;
* no agregar texto después del objeto;
* respetar exactamente el esquema definido por el contrato correspondiente;
* mantener los nombres de los campos sin modificaciones.

---

# Integración futura con Vertex AI

Los mismos parámetros documentados en este archivo podrán configurarse posteriormente mediante la API de Vertex AI sin necesidad de modificar los prompts desarrollados durante el hackathon.

---

# Observaciones

Esta configuración fue diseñada específicamente para un entorno educativo donde la prioridad es la estabilidad del comportamiento del modelo y la facilidad de integración con el resto del sistema.
