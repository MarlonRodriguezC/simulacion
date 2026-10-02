# Bitácora de Proyecto: Instrumento Visual Autónomo (Stereo Love Edition)

---
**Link del proyecto:** https://editor.p5js.org/mugsky/sketches/3au_23V7T  
---

## 1. Concepto y Visión Visual

Este proyecto es un **instrumento visual interactivo en tiempo real** diseñado para ser interpretado en vivo como acompañamiento a piezas de música electrónica, específicamente configurado para el tema clásico *Stereo Love* (Edward Maya & Vika Jigulina).

El sistema simula un ecosistema de agentes autónomos que navegan entre tres regímenes de movimiento fundamentados en modelos físicos y biológicos:
1. **Comportamiento Fisárico (Physarum polycephalum):** Formación orgánica de venas y redes de transporte mediante deposición y lectura de un mapa de feromonas/rastros.
2. **Comportamientos Colectivos de Reynolds (Flocking / Steering Behaviors):** Dinámicas de enjambre guiadas por fuerzas de separación, alineación y cohesión.
3. **Campos de Vectores y Ruido Simplex/Perlin (Flow Fields):** Navegación fluida guiada por campos continuos de fuerzas.

---

## 2. Marco Teórico y Referencias

### Referencia Principal del Modelo Physarum
La arquitectura base de los agentes y la lectura de sensores ambientales está fuertemente inspirada en el tutorial de **Patt Vira** (*p5.js Coding Tutorial | Slime Molds (Physarum)*, disponible en [YouTube](https://www.youtube.com/watch?v=VyXxSNcgDtg)), fundamentado en el modelo de Jeff Jones (2010) y el trabajo visual de Sage Jensen.

### A. Algoritmo Physarum (Venas Orgánicas)
Basado en el modelo de Jones (2010), cada agente posee tres sensores ubicados al frente ($S_F$), a la izquierda ($S_L$) y a la derecha ($S_R$) definidos por una distancia de offset ($SO$) y un ángulo de apertura ($SA$).

$$\vec{x}_{\text{sensor}} = \vec{x}_{\text{agente}} + SO \cdot \begin{pmatrix} \cos(\theta + \alpha) \\ \sin(\theta + \alpha) \end{pmatrix}$$

El agente lee la densidad luminosa del buffer de píxeles (`gfx.pixels`) en el canal rojo y reorienta su ángulo de navegación $\theta$ hacia la mayor concentración de rastro. Posteriormente, deposita color en la textura, la cual se evapora en cada cuadro aplicando un factor de decaimiento:

$$I_{t+1}(x,y) = I_t(x,y) \cdot \lambda \quad (\text{donde } \lambda \approx 0.92)$$

### B. Steering Behaviors (Reynolds Flocking)
Cada partícula calcula fuerzas de maniobra limitadas por una fuerza máxima ($\vec{F}_{\text{max}}$) y una velocidad máxima ($\vec{v}_{\text{max}}$):

$$\vec{F}_{\text{steer}} = \text{truncate}\left( \frac{\vec{d}}{\Vert{}\vec{d}\Vert{}} v_{\text{max}} - \vec{v}, F_{\text{max}} \right)$$

* **Separación:** Evita el hacinamiento local mediante repulsión inversamente proporcional a la distancia.
* **Alineación:** Conforma el rumbo promedio de los vecinos en un radio definido.
* **Cohesión:** Atrae a la partícula hacia el centro de masa local del enjambre.

### C. Campos de Flujo (Flow Fields)
Se utiliza un espacio vectorial basado en ruido Perlin 3D ($x, y, t$), convirtiendo el valor continuo $[0, 1]$ a un ángulo $\theta \in [0, 4\pi]$ para generar corrientes suaves y no repetitivas.

---

## 3. Arquitectura del Código

El sistema está compuesto por tres archivos principales organizados modularmente:
* `index.html`: Carga de la librería p5.js y vinculación de scripts.
* `mold.js`: Clase Mold (Agente individual, sensores, fuerzas y físicas).
* `sketch.js`: Loop de renderizado, buffer gráfico off-screen y eventos de teclado.

### Optimización de Rendimiento
Para evitar cuellos de botella en la lectura de memoria de píxeles durante el uso en pantalla completa (especialmente en pantallas de alta densidad Retina/4K), se implementaron las siguientes medidas:
* **Fijación de Pixel Density:** Declaración explícita de `pixelDensity(1)` tanto en el canvas principal como en el buffer secundario `d`.
* **Buffer Off-screen:** Los agentes de Physarum leen y escriben sobre un `p5.Graphics` independiente (`d`), el cual se renderiza como imagen directa en el canvas principal para no saturar el DOM.
* **Referenciación Directa de Píxeles:** Evaporación acelerada de rastros mediante punteros locales sobre `d.pixels`.

---

## 4. Guía de Interacción y Mapa de Controles (Live Performance)

El instrumento cuenta con 6 modos de funcionamiento que combinan los motores físicos básicos y un conjunto de disparadores cromáticos y gestuales para el seguimiento de la música:

| Tecla | Acción / Modo | Descripción en Vivo |
| :--- | :--- | :--- |
| **`1`** | Physarum Puro | Venas neón delgadas y redes de transporte orgánico. |
| **`2`** | Flocking Puro | Enjambre interactivo con dinámicas de grupo. |
| **`3`** | Flow Field | Corrientes de ruido Perlin y líneas de campo vectoriales. |
| **`4`** | Physarum + Flocking | **Híbrido:** Agentes agrupados que trazan cordones pulsantes de luz. |
| **`5`** | Flow Field + Physarum | **Híbrido:** Auroras boreales y mar de corrientes luminosas. |
| **`6`** | Supernova | Flocking en vórtice orbital centrado. |
| **`ESPACIO`** | Strobe Flash | Destello de luz aleatorio entre Rosa Neón y Azul Ciano al ritmo del kick. |
| **`C`** | Estallido Radial | Onda de choque que impulsa físicamente a los agentes hacia afuera. |
| **`D`** | Corazón / Atracción | En Modo 3 atrae todo al centro; en Modos 2/4/6 forma una cardioide. |
| **`Mantener Q`**| Reversa de Agentes | Invierte instantáneamente los vectores de velocidad de todas las partículas. |
| **`Mantener V`**| Vórtice | Atrae a los agentes a una espiral logarítmica central. |
| **`G`** | Glitch RGB | Desfase cromático analógico en las capas de color. |
| **`L`** | Inversión de Color | Alterna entre fondo negro neón y fondo blanco de alto contraste. |
| **`P` / `ENTER`**| Pantalla Completa | Activa/desactiva el modo fullscreen sin interrupciones. |
| **`H`** | Ocultar HUD | Muestra u oculta el menú flotante y el puntero del mouse. |
| **`A / Z`** | Ángulo $SA$ | Alterna entre redes muy ramificadas (`A`) o hilos rectos (`Z`). |
| **`S / X`** | Distancia $SO$ | Alterna entre autopistas gruesas (`S`) o manchas locales (`X`). |
| **`Mouse`** | Atracción Manual | Mantiene presionado para atraer agentes a la posición del cursor. |

---

## 5. Autoevaluación y Conclusiones

