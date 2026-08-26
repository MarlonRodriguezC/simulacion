# Bitácora Unidad 3: Simulación de Fuerzas e Instrumentos Interactivos

---

## 1. Instrumento Funcional y Publicado

- **URL Pública:** [https://juanferfranco.github.io/simulacion-2026-20/units/unit3/](https://juanferfranco.github.io/simulacion-2026-20/units/unit3/) (no funciona la mia aun, asi que Puedes ver la demostración en vivo en este [Video de YouTube](https://youtu.be/Ge2GJpJwvb8)._
- **Modo LAB:** Modo con interfaz gráfica para ajustar parámetros.
- **Modo PERFORMANCE:** Modo limpio sin controles en pantalla, enfocado en la interpretación en vivo con el teclado y el ratón.

---

## 2. Mapa del Sistema

| Componente / Capa | Descripción Funcional | Archivo(s) donde se encuentra |
| :--- | :--- | :--- |
| **Estado (State)** | Manejo de 131,072 partículas instanciadas en WebGPU, controlando sus posiciones (`positionBuffer`) y velocidades (`velocityBuffer`) mediante TSL (Three.js Shading Language). | `src/simulation/createSimulation.js` |
| **Fuerzas (Forces)** | Cálculo vectorial en Compute Shader de viento, fuerza radial (atracción/repulsión), vórtice tangencial ($\vec{tangent} = \vec{z} \times \vec{radial}$), turbulencia continua (jitter) y fricción (drag). | `src/simulation/createSimulation.js` (`updateParticles`) |
| **Integración (Integration)** | Integración de fuerzas y velocidad usando el método de Euler ($\vec{v} += \vec{F} \cdot dt$, $\vec{p} += \vec{v} \cdot dt$), límite máximo de velocidad y lógica de rebote dinámico en límite esférico con impulso interior. | `src/simulation/createSimulation.js` (`updateParticles`) |
| **Render** | Renderizado gráfico estilizado con `THREE.SpriteNodeMaterial` y `AdditiveBlending`, aplicando mapas de opacidad retro a partir de la textura ASCII generada dinámicamente en canvas 2D. | `src/simulation/createSimulation.js` / `src/simulation/asciiTexture.js` |
| **Controles (Inputs / UI)** | Interfaz gráfica interactiva en pantalla (Sliders, botones y checkboxes en HTML) para ajustar los valores de simulación y conmutar modos en tiempo real. | `src/ui/labPanel.js` |
| **Parámetros y Orquestación** | Definición de Uniforms expuestos a la GPU y mapeo de eventos de teclado masivo (WASD, Q/E, X, Space, Presets 1-5, Lethal FX) e interacción con el cursor por Raycaster. | `src/main.js` / `src/simulation/parameters.js` |

---

## 3. Ficha de Fuerzas

### Ecuación General del Sistema
$$\vec{F}_{total} = \vec{F}_{viento} + \vec{F}_{radial} + \vec{F}_{vórtice} + \vec{F}_{jitter} + \vec{F}_{drag}$$

- **Fuerza Radial (Atracción / Repulsión):** 
  $$\vec{F}_{radial} = \frac{\vec{r}}{\max(\|\vec{r}\|, \text{softening})} \cdot \frac{\text{radialStrength}}{\|\vec{r}\|^2}$$
- **Vórtice Tangencial:** 
  $$\vec{F}_{vórtice} = (\vec{z} \times \hat{r}) \cdot \text{vortexStrength}$$
- **Drag / Fricción:** 
  $$\vec{F}_{drag} = -\vec{v} \cdot \text{dragCoefficient}$$

### Parámetros Principales (`parameters.js`)
- `radialStrength`: $2.2$
- `vortexStrength`: $1.4$
- `dragCoefficient`: $0.12$
- `softening`: $0.35$
- `maxSpeed`: $5.0$

### Predicciones y Decisiones de Diseño
* **Predicción:** Al pasar `radialStrength` a un valor altamente negativo ($-18.0$, preset Supernova), las partículas romperán la estructura colapsada alrededor del cursor y serán expulsadas hacia afuera.
* **Decisión de Diseño:** Implementar rebote dinámico en el límite esférico exterior para evitar que las partículas se pierdan infinitamente en el espacio al sufrir repulsión extrema.

---

## 4. Registro de Pruebas

| Prueba | Configuración / Fuerza Central | Resultado Observado |
| :--- | :--- | :--- |
| **1. Inercia** | Fuerzas deshabilitadas. | Pensé que se mantendrían las partículas chocando unas con otras, como su nombre lo dice "inercia", simplemente se quedarían por ahí conservando su estado. **Observado:** Las partículas mantuvieron su movimiento rectilíneo o reposo sin detenerse. |
| **2. Fuerza Constante (+X)** | Viento en $+X$. | Pensé que se moverían hacia un lado en específico pero no sabía del todo cuál. Aunque lo más evidente era el eje X (derecha/izquierda), tomé como posibilidad arriba/abajo por el mapeo de ejes en ciertos software. Esperaba que se moviera todo el cubo de partículas junto. **Observado:** Se movió completamente hacia la derecha. Al colisionar con el límite rebotan activamente. |
| **3. Atracción** | Radial Activado (Positivo). | Pensé que se unirían entre sí hasta crear una especie de pelota o punto lleno de partículas, o a un punto fijo (como una esquina o un punto seleccionado con el mouse). **Observado:** Las partículas se fueron atrayendo dinámicamente hacia el cursor en tiempo real, colapsando y orbitando alrededor del puntero. |
| **4. Repulsión** | Radial Activado (Negativo). | Esperaba el mismo resultado que la atracción pero intentando evitar el cursor a toda costa. **Observado:** Huida masiva del cursor. Al chocar contra los límites del cubo reaparecían o rebotaban. Al ubicar el cursor en una esquina, peleaban infinitamente por alejarse. Al ubicarlo en el centro exacto, las partículas se dispersaban hacia las esquinas. |
| **5. Vórtice** | Vórtice Activado. | Pensé que sería como un vórtice de agua: un círculo en la superficie y abajo una punta en forma de raíz que se agrandaba con la intensidad. **Observado:** La fuerza rotacional actuó de forma axial/vertical. El vórtice seguía continuamente al cursor en un movimiento helicoidal y circular constante. |
| **Prueba Específica (Preset Supernova)** | `Digit2`: `radialStrength = -18.0`, Drag = $0$, Vórtice = $0$. | Explosión radial inmediata desde la posición del puntero, colisionando y rebotando dinámicamente en las paredes del límite esférico. |

---

## 5. Score Visual (Interpretación en Vivo con LesAlpx)

| Tramo de LesAlpx | Intención Visual / Estética | Controles y Acciones en Vivo |
| :--- | :--- | :--- |
| **0:00 - 0:45 (Introducción / Sintetizador suelto)** | Flotación en calma. | Modo PERFORMANCE activado (`P`). Viento desactivado (`X`). Cursor estático en el centro. |
| **0:45 - 1:30 (Entrada del beat y percusión)** | Dirección rítmica constante. | Viento en $+X$ pulsando `D`. Incremento de velocidad continua manteniendo `E`. |
| **1:30 - 2:30 (Clímax rítmico y modulación)** | Explosión visual y cambios abruptos de dinámica. | Presets numéricos: `1` (Anillo Saturno) y `3` (Tornado). Golpes con la tecla `Space` (Kick Boom). |
| **2:30 - Fin (Outro / Descompresión)** | Dispersión radial y retorno a suspensión fluida. | Dispersión con la tecla `KeyL`, freno con `X` y retorno a Zero Gravity con `U`. |

---

## 6. Bitácora de IA

| Prompt Relevante | Sugerencia de la IA | Decisión / Ajuste Realizado | Razón de Rechazo o Corrección |
| :--- | :--- | :--- | :--- |
| *"¿Cómo evitar que las partículas salgan disparadas con velocidad infinita al acercarse al atractor?"* | Eliminar las partículas si su distancia al atractor es menor a $0.01$. | **Rechazada.** Se aplicó un valor de `softening` en la división del vector radial en TSL. | Eliminar partículas rompía el buffer fijo de $131,072$ elementos instanciados en WebGPU. |
| *"Calcular la fuerza de vórtice en 3D."* | Usar el producto cruz entre el vector $Z$ y la dirección radial. | **Aceptada e integrada.** | Genera la rotación periférica exacta en TSL. |
| *"Crear botones en la pantalla para activar los efectos visuales."* | Agregar un panel HTML con botones para cada efecto FX. | **Corregida.** Se prefirió mapear la batería de efectos directo al teclado (`O`, `L`, `K`, `J`, `I`, `U`, `H`, `M`, `N`). | La interfaz visual saturaba la pantalla y estorbaba la interpretación en vivo durante el modo PERFORMANCE. |

---

## 7. Autoevaluación Ponderada

| Criterio | Peso | Qué debe demostrar la evidencia | Valoración (0-100) | Aporte Calculado | Evidencia / Sustento |
| :--- | :---: | :--- | :---: | :---: | :--- |
| **Trazabilidad y comprensión del sistema** | 25% | Puedo señalar y explicar estado, fuerzas, integración, render y controles; además puedo ubicar qué partes produjo o modificó la IA. | **90%** | 22.5% | [Sección 2. Mapa del Sistema](#2-mapa-del-sistema) |
| **Verificación del algoritmo de fuerzas** | 25% | Estudié en detalle el proyecto... puedo aislar una fuerza central, formular una predicción, compararla y cambiar deliberadamente un signo o parámetro. | **88%** | 22.0% | [Sección 3. Ficha de Fuerzas](#3-ficha-de-fuerzas) y [Sección 4. Registro de Pruebas](#4-registro-de-pruebas) |
| **Diseño de fuerzas e intención** | 20% | Las fuerzas y sus parámetros hacen perceptible una intención; el comportamiento surge de la dinámica y no de trayectorias previamente dibujadas. | **85%** | 17.0% | [Sección 3. Ficha de Fuerzas](#3-ficha-de-fuerzas) |
| **Instrumento, score e interpretación** | 15% | El score conecta la escucha con decisiones; escogí pocos controles expresivos y puedo conducir el sistema en vivo sin automatismos. | **90%** | 13.5% | [Sección 5. Score Visual](#5-score-visual-interpretación-en-vivo-con-lesalpx) |
| **Experimentación y criterio frente a la IA** | 10% | Comparé alternativas, registré hallazgos y descartes, corregí propuestas de IA y puedo justificar por qué conservé la versión presentada. | **85%** | 8.5% | [Sección 6. Bitácora de IA](#6-bitácora-de-ia) |
| **Entrega técnica y documentación** | 5% | La URL pública abre; la bitácora permite verificar el proceso. | **90%** | 0% | [Sección 1. Instrumento Funcional y Publicado](#1-instrumento-funcional-y-publicado) |
| **TOTAL PUNTOS** | **100%** | | | **88.0%** | **Nota Propuesta: 4.2 / 5.0** |
