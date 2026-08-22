# Bitácora Unidad 3: Simulación de Fuerzas e Instrumentos Interactivos

**Tema:** *Fuerzas y comportamiento emergente de partículas*

**Proyecto:** *Simulador e Instrumento de Campos de Fuerza Interactivos*

**Herramientas:** *p5.js 

---

## 1. Propuesta e Intención

La propuesta explora cómo las particulas responden a fuerzas del entorno y a la intervencion directa del usuario en tiempo real. Se busca representar la maleabilidad de un sistema frente a perturbaciones físicas (inercia, campos constantes, atracción, repulsión y vórtices), demostrando cómo el equilibrio visual de un grupo de elementos puede alterarse mediante parámetros de control directo y dinámicas de interacción continua.

---

## 2. Predicción y Observacion 

Antes de implementar el instrumento final, se realizo un analisis comparativo entre las predicciones tepricas iniciales y el comportamiento real observado durante la ejecución de los escenarios en el motor de simulación:

| Escenario Físico | Prediccion Inicial | Observacion Real en la Simulacion |
| :--- | :--- | :--- |
| **1. Inercia** | Pense que se mantendroan las particulas chocando unas con otras, como su nombre lo dice "inercia", simplemente se quedarian por ahí conservando su estado | **Confirmado:** Las partículas mantuvieron su estado de movimiento constante o reposo hasta ser afectadas por colisiones o fricción del medio, agrupándose de forma orgánica sin aceleraciones abruptas|
| **2. Fuerza Constante (+X)** | Pense que se moverian hacia un lado en especifico pero no sabia del todo cual. Aunque lo más evidente era el eje X (derecha/izquierda), tome como posibilidad arriba/abajo por el mapeo de ejes en ciertos software. Esperaba que se moviera todo el cubo de partículas junto | **Observado:** Se movió completamente hacia la derecha. A diferencia de lo esperado (mover la estructura completa), las particulas que alcanzaban el limite del contenedor reaparecian en el extremo opuesto (wrap-around), generando un flujo continuo |
| **3. Atraccion** | Pensé que se unirian entre si hasta crear una especie de pelota o punto lleno de particulas, o a un punto fijo (como una esquina o un punto seleccionado con el mouse) | **Observado:** Las particulas se fueron atrayendo dinamicamente hacia el cursor en tiempo real, colapsando y orbitando alrededor del puntero conforme este se desplazaba por el espacio |
| **4. Repulsion** | Esperaba el mismo resultado que la atraccion pero intentando evitar el cursor a toda costa | **Observado:** Huida masiva del cursor. Al chocar contra los limites del cubo reaparecian en el lado opuesto. Al ubicar el cursor en una esquina, peleaban infinitamente por alejarse. Al ubicarlo en el centro exacto, las particulas se dispersaban hacia las esquinas |
| **5. Vórtice** | Pense que seria como un vortice de agua: un circulo en la superficie y abajo una punta en forma de raiz que se agrandaba con la intensidad | **Observado:** La fuerza rotacional actuó de forma axial/vertical. El vortice seguia continuamente al cursor en un movimiento helicoidal y circular constante, haciendo girar a las particulas en torno al eje de fuerza. |

---
### Paso 3: Instrumento Funcional y Publicado

- **URL Pública:** [https://juanferfranco.github.io/simulacion-2026-20/units/unit3/](https://juanferfranco.github.io/simulacion-2026-20/units/unit3/)
- **Modo LAB:** Permite ajustar los parametros de masa, friccion, magnitudes de fuerza ($F$) y constantes en tiempo real mediante interfaz de controles para experimentar con la respuesta del sistem.
- **Modo PERFORMANCE:** Interfaz limpia sin controles superpuestos, orientada a la interpretación en vivo expresiva mediante atajos de teclado Q,W,E,A,S,D,O,L,K,M,N,J,I,U y posicion del mouse

---

## 3. Mapa del Sistema

Estructura y arquitectura del codigo que componen la simulación:

| Componente / Capa | Descripción Funcional | Archivo(s) donde se encuentra |
| :--- | :--- | :--- |
| **Estado (State)** | Manejo de posiciones ($\vec{P}$), velocidades ($\vec{V}$), aceleraciones ($\vec{A}$), masa y vida útil de cada partícula. | `Particle.js` / `System.js` |
| **Fuerzas (Forces)** | Cálculo vectorial de atracciones, repulsiones, viento (+X), fricción y campos de vórtice. | `Forces.js` |
| **Integración (Integration)** | Algoritmo de integración Euler/Verlet para acumulación de fuerzas: $\vec{A} = \frac{\vec{F}}{m}$, $\vec{V} = \vec{V} + \vec{A}\cdot\Delta t$, $\vec{P} = \vec{P} + \vec{V}\cdot\Delta t$. | `Particle.js` |
| **Render** | Dibujado y representación gráfica de las partículas en el canvas p5.js (`points` / `lines` / alfa dinámico). | `sketch.js` / `Renderer.js` |
| **Controles (Inputs)** | Mapeo de atajos de teclado (`Q`, `E`, `X`, `L`) y coordenadas del cursor (`mouseX`, `mouseY`). | `sketch.js` |

---

## 4. Ficha de Fuerzas y Modificación Experimental

### Ecuación General del Sistema
El comportamiento dinámico se rige por la suma vectorial de fuerzas:

$$\vec{F}_{total} = \vec{F}_{viento} + \vec{F}_{atracción/repulsión} + \vec{F}_{fricción}$$

- **Fricción / Drag:** $\vec{F}_{drag} = -c \cdot v \cdot \hat{v}$ (opone resistencia al movimiento para estabilizar el sistema).
- **Atracción / Repulsión:** $\vec{F}_{atractor} = \frac{G \cdot m_1 \cdot m_2}{r^2} \cdot \hat{r}$ (escalada con límites $R_{min}$ y $R_{max}$ para evitar picos infinitos).

### Parámetros Principales
- **Magnitud del Viento ($F_x$):** $0.05$ (Direccional en $+X$).
- **Constante de Atracción ($G$):** $1.2$.
- **Coeficiente de Fricción ($c$):** $0.03$.
- **Radio de Influencia ($R_{max}$):** $250\text{ px}$.
- **Distancia Mínima ($R_{min}$):** $15\text{ px}$.

### Experimento de Modificación de Parámetros (Aislamiento de Fuerza)
*   **Prueba:** Se aisló la fuerza de atracción y se invirtió deliberadamente el signo del vector de dirección ($\vec{F}_{atractor} \cdot -1.0$).
*   **Predicción:** Las partículas deberían pasar inmediatamente de un comportamiento implosivo (concentrándose en el cursor) a un comportamiento repulsivo (creando un área limpia alrededor del puntero).
*   **Resultado y Análisis:** Al cambiar el signo, las partículas salieron disparadas en dirección opuesta al cursor. Sin embargo, al tocar los bordes del canvas y reaparecer (wrap-around), se generó un anillo dinámico vacío alrededor del ratón, confirmando el cambio directo de polaridad en el campo vectorial.

---

## 5. Registro de Pruebas

| Prueba | Configuración / Fuerza Central | Resultado Observado |
| :--- | :--- | :--- |
| **Prueba 1: Inercia** | $\vec{F}_{ext} = 0$, $c = 0$ | Movimiento rectilíneo uniforme continuo. Las partículas no se detienen y mantienen su dirección inicial. |
| **Prueba 2: Fuerza Constante** | $\vec{F} = (0.1, 0, 0)$ | Aceleración constante a la derecha ($+X$). Las partículas reaparecen en el borde izquierdo al salir. |
| **Prueba 3: Atracción** | Atractor en $(X_{mouse}, Y_{mouse})$ | Colapso progresivo hacia el cursor creando órbitas cerradas a baja velocidad. |
| **Prueba 4: Repulsión** | Repulsor en $(X_{mouse}, Y_{mouse})$ | Dispersión radial limpia fuera del puntero; acumulación temporal en los límites del contenedor. |
| **Prueba 5: Vórtice** | Fuerza tangencial $\vec{F}_{rot} = (-d_y, d_x)$ | Giro helicoidal continuo alrededor del centro del ratón. |
| **Prueba Específica (Combinada)** | Atracción + Vórtice con atajo `L` | Formación de una estructura organizada (patrón de corazón) acelerada por el giro del vórtice. |

---

## 6. Score Visual (Interpretación en Vivo con LesAlpx)

A continuación se detalla la conducción expresiva del sistema durante la pieza musical *LesAlpx* (de Caribou), conectando la escucha activa con decisiones de control manual en tiempo real:

| Tramo de LesAlpx | Intención Visual / Estética | Controles y Acciones en Vivo |
| :--- | :--- | :--- |
| **0:00 - 0:45 (Introducción / Sintetizador suelto)** | Movimiento sutil, partículas flotando de forma inercial en calma. | Modo PERFORMANCE activado. Sin viento (`X` apagado). Mouse estático en el centro. |
| **0:45 - 1:30 (Entrada del beat y percusión)** | Aumento progresivo de la densidad y dirección constante con la rítmica. | Activar viento ($+X$) con la tecla `X`. Incrementar velocidad rítmicamente pulsando `E`. |
| **1:30 - 2:30 (Clímax rítmico y modulación)** | Explosión de movimiento, oscilación de campos de atracción y patrones formales. | Desplazamiento rápido del mouse para arrastrar partículas. Presión de la tecla `L` para generar la figura de atractor. |
| **2:30 - Fin (Outro / Descompresión)** | Dispersión total y retorno progresivo a la calma inercial. | Conmutación a modo repulsión, reducción de velocidad con `Q` y desactivación final del viento con `X`. |

---

## 7. Bitácora de IA

| Prompt Relevante | Sugerencia de la IA | Decisión / Ajuste Realizado | Razón de Rechazo o Corrección |
| :--- | :--- | :--- | :--- |
| *"¿Cómo hacer que las partículas no salgan disparadas con atracción infinita?"* | Aplicar una condicional para eliminar las partículas si la distancia es menor a $1$. | **Rechazada.** Se reemplazó por un *clamp* / $R_{min}$ en la distancia. | Destruir las partículas rompía la conservación del número total de elementos en la simulación. |
| *"Generar el cálculo del vector tangencial para el vórtice."* | Asignar la fuerza de vórtice invirtiendo ejes: $(-d_y, d_x)$. | **Aceptada e integrada.** | La lógica vectorial era correcta para generar la rotación helicoidal alrededor del ratón. |
| *"Mapear las teclas para los controles de modo performance."* | Crear botones HTML superpuestos en pantalla. | **Corregida.** Se prefirió mapear únicamente atajos de teclado (`Q`, `E`, `X`, `L`). | La interfaz en pantalla estorbaba la interpretación en vivo durante el score visual. |

---

## 8. Autoevaluación Ponderada

| Criterio | Peso | Qué debe demostrar la evidencia | Valoración (0-100) | Aporte Calculado | Evidencia / Sustento |
| :--- | :---: | :--- | :---: | :---: | :--- |
| **Trazabilidad y comprensión del sistema** | 25% | Puedo señalar y explicar estado, fuerzas, integración, render y controles; además puedo ubicar qué partes produjo o modificó la IA. | **90%** | 22.5% | Sección 3 (Mapa del sistema) detallada con la separación de archivos `Particle.js`, `Forces.js`, `sketch.js` y el rol de cada uno. |
| **Verificación del algoritmo de fuerzas** | 25% | Estudié en detalle el proyecto... puedo aislar una fuerza central, formular una predicción, compararla y cambiar deliberadamente un signo o parámetro. | **88%** | 22.0% | Sección 4 (Ficha de fuerzas) donde se documenta el aislamiento del atractor, la inversión de signo en VEX/JS y el resultado del anillo dinámico. |
| **Diseño de fuerzas e intención** | 20% | Las fuerzas y sus parámetros hacen perceptible una intención; el comportamiento surge de la dinámica y no de trayectorias previamente dibujadas. | **85%** | 17.0% | Las partículas responden en tiempo real a la física vectorial (atracción, repulsión, fricción) sin animación precocinada. |
| **Instrumento, score e interpretación** | 15% | El score conecta la escucha con decisiones; escogí pocos controles expresivos y puedo conducir el sistema en vivo sin automatismos. | **90%** | 13.5% | Sección 6 (Score visual) con mapeo directo de tramos de la canción *LesAlpx* a los atajos `Q`, `E`, `X`, `L` e interacción con ratón. |
| **Experimentación y criterio frente a la IA** | 10% | Comparé alternativas, registré hallazgos y descartes, corregí propuestas de IA y puedo justificar por qué conservé la versión presentada. | **85%** | 8.5% | Sección 7 (Bitácora de IA) con la explicación de propuestas aceptadas, corregidas y rechazadas (como el clamping vs destrucción). |
| **Entrega técnica y documentación** | 5% | La URL pública abre; la bitácora permite verificar el proceso. | **90%** | 4.5% | Enlace público a GitHub Pages funcional en modo LAB y PERFORMANCE con la bitácora estructurada de forma transparente. |
| **TOTAL** | **100%** | | | **88.0%** | **Nota Propuesta: 4.4 / 5.0** |
