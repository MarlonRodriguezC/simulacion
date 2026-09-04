# Bitácora Unidad 4: Oscilación y Sincronía - Kuramoto Abisal

---

## Proyecto Funcional y Publicado

- **URL Pública:** [https://editor.p5js.org/mugsky/sketches/NWV-d32Ek](https://editor.p5js.org/mugsky/sketches/NWV-d32Ek)

- **Modo LAB / Visor HUD:** Pantalla interactiva en tiempo real con resolución nativa retro (400x300 proyectada a viewport dinámico con CRT scanlines). Simula la interfaz del casco de buzo permitiendo monitorear el Faro de Sincronía/Acoplamiento (`SYNC %`), gestionar la reserva de Oxígeno (`O2 AIR`), seleccionar la potencia del arpón (3 modos), contabilizar peces cazados (`CAZADOS`) y ejecutar la percusión/daño por disparo.

---

## Referencia Estética y Mecánica

- **Concepto:** Minijuego de cacería táctico con perspectiva en primera persona (FPS) inspirado en los clásicos del género (*Doom*, *Wolfenstein 3D*), trasladado a un entorno abisal retro. Se integra la simulación de cardumen mediante el modelo de Kuramoto y fuerzas de comportamiento de Flocking (cohesión, alineamiento, separación) para recrear cómo los peces se agrupan, coordinan su nado y reaccionan al peligro.

![Referencia Doom](../assets/unidad_4/doom_referencia.jpeg)
![Referencia Wolfenstein](../assets/unidad_4/wolfenstein_referencia.png)

---

## Ficha del Modelo de Kuramoto y Mecánicas Integradas

### Ecuación General Utilizada
$$\frac{d\theta_i}{dt} = \omega_i + \frac{K}{N} \sum_{j=1}^{N} \sin(\theta_j - \theta_i)$$

- **$\theta_i$ (Fase del Pez $i$):** Representa la posición actual en el ciclo de oscilación y pulso bioluminiscente de cada pez.
- **$\omega_i$ (Frecuencia Natural):** Velocidad intrínseca de oscilación asignada individualmente (`random(0.02, 0.05)`).
- **$K$ (Fuerza de Acoplamiento):** Parámetro de cohesión rítmica del agua abisal. Aumenta con la inmovilidad del buzo y cae drásticamente ante disparos o desplazamientos.
- **$N$ (Vecinos Locales):** Cantidad de peces detectados dentro del radio de percepción ($<70\text{px}$).
- **$\sin(\theta_j - \theta_i)$:** Término de acoplamiento no lineal que acelera o frena la oscilación del pez para sincronizar su fase con la del cardumen local.

### Parametrización Inicial y Variables de Cacería
- `K_base`: $0.02$ (recuperación progresiva hacia el acoplamiento en reposo).
- `radius_perception`: $70\text{px}$ (red topológica local).
- `N_agents`: $8$ agentes con identidades sonoras únicas (escala de 8 notas en Tone.js).
- `K_disruption`: $-0.08$ por disparo de arpón.
- **Sistema de Salud y Durabilidad:** Cada pez nace con $100\text{ HP}$. Al recibir daño parcial parpadea en color naranja/rojo y entra en estado de huida acelerada.
- **Selector de Potencia del Arpón (3 Botones):**
  - *Modo 1 (3 Tiros):* Consumo de $-4\text{ O}_2$ | Daño $35\text{ HP}$ (Requiere 3 disparos para neutralizar).
  - *Modo 2 (2 Tiros):* Consumo de $-8\text{ O}_2$ | Daño $50\text{ HP}$ (Requiere 2 disparos para neutralizar).
  - *Modo 3 (1 Tiro):* Consumo de $-16\text{ O}_2$ | Daño $100\text{ HP}$ (Neutraliza de 1 solo disparo).

---

## Registro de Pruebas y Comportamientos Emergentes

| Prueba | Configuración y Entorno | Resultado Observado |
| :--- | :--- | :--- |
| **1. Acoplamiento Nulo ($K \to 0$)** | Movimiento continuo del buzo o disparos constantes. | **Desorden Total.** Los peces oscilan a su frecuencia natural $\omega_i$, las conexiones de fase se rompen y la bioluminiscencia titila descoordinada. |
| **2. Transición Progresiva (Reposo)** | Buzo estático en el fondo ($Y = 220$) sin disparar. | **Organización Emergente.** $K$ incrementa gradualmente ($0\% \to 100\%$). Nacen clústeres rítmicos locales que contagian al grupo entero hasta nadar en unísono armónico. |
| **3. Perturbación por Disparo y Daño** | Disparo de arpón sobre un pez del cardumen. | **Desagregación y Pánico.** $K$ se desploma. El pez impactado pierde vida, cambia a tono naranja, activa su nota musical en Tone.js y acelera abruptamente rompiendo la formación. |
| **4. Selección de Potencia y Gestión de $O_2$** | Alternancia entre botones P1, P2 y P3 en la StatusBar. | **Estrategia Performática.** Disparar en Modo 3 elimina al pez de un golpe pero agota drásticamente la barra de $O_2$, obligando a subir a superficie ($Y \le 45$) a recargar aire. |
| **5. Eliminación y Respawn** | Reducir la vida de un pez a $0\text{ HP}$. | **Contador de Bajas e Inserción.** Se incrementa la métrica `CAZADOS` en el HUD y el pez reaparece por los bordes laterales o fondo del mapa con salud regenerada. |

---

## Score y Experiencia Performativa

| Estado del Sistema | Intención Auditiva / Visual | Acciones del Performer |
| :--- | :--- | :--- |
| **Fase 1: Calma y Acoplamiento** | Cohesión rítmica armónica, pulso bioluminiscente coordinado y líneas de red estables. | Dejar al buzo en reposo en el lecho marino para que el indicador de `SYNC` alcance su valor máximo. |
| **Fase 2: Gestión Táctica y Disparo** | Decisión estratégica entre gasto de oxígeno y velocidad de neutralización. | Seleccionar entre los modos P1, P2 o P3 según el aire disponible, apuntar al cardumen con la mira reticular y disparar. |
| **Fase 3: Asfixia y Emergencia** | Caída crítica de reserva de aire ($O_2 < 25\%$), alerta visual roja en la StatusBar. | Mantener pulsada la tecla `ESPACIO` para ascender rápidamente a la superficie y recargar oxígeno antes del `GAME OVER`. |

---

## Bitácora de Uso y Criterio frente a IA

| Prompt / Consulta a IA | Sugerencia Recibida de la IA | Decisión y Corrección Aplicada | Razón de la Decisión |
| :--- | :--- | :--- | :--- |
| *"¿Cómo hacer que la sincronización de Kuramoto active sonidos en p5.js?"* | Disparar sonidos en cada frame dentro del loop `draw()` usando condicionales de fase. | **Rechazada.** Se implementó un evento discreto al recibir impacto e interactuar con sintetizadores polifónicos en Tone.js. | Disparar audio en cada frame saturaba el buffer de audio y bloqueaba la ejecución del canvas. |
| *"Modificar la variable K de Kuramoto mediante un reloj automático."* | Crear un `setInterval` que cambie $K$ de 0 a 1 cada 5 segundos. | **Rechazada.** Se ató la variación de $K$ a la acción directa del usuario (movimiento y disparos). | La guía exige expresamente que el sistema sea performativo y no una animación predeterminada. |
| *"Diseñar la interfaz y selector de potencia del arpón."* | Usar entradas `<input type="range">` y botones HTML fuera del canvas. | **Modificada.** Se dibujó una botonera retro integrada en la propia `pixelBuffer` con tipografía 'Courier New' y lógica de click por coordenadas. | Preserva la estética retro pixel art e inmersión dentro del visor del buzo. |
| *"Revisar error de audio donde no sonaba Tone.js al disparar."* | Desactivar comprobación de contexto de Tone. | **Corregida.** Se ajustó la condicional en `triggerSound()` y se añadió `Tone.start()` en el evento `mousePressed()`. | Los navegadores exigen una interacción explícita del usuario para habilitar el contexto de audio (`AudioContext`). |

---

## Autoevaluación Ponderada

| Criterio | Peso | Justificación de Cumplimiento | Valoración | Aporte |
| :--- | :---: | :--- | :---: | :---: |
| **Requisitos Mínimos Cumplidos** | 25% | 8 agentes móviles con síntesis sonora individual, $K$ dinámico en tiempo real, HUD con 3 botones de potencia de arpón, medidor de $O_2$, acoplamiento `SYNC` y marcador de bajas. | 100% | 25.0% |
| **Explicación de Variables del Modelo** | 25% | Documentación matemática y aplicada de $\theta_i$, $\omega_i$, $K$, $N$ y $\sin(\theta_j - \theta_i)$ adaptados al comportamiento de los peces abisales. | 100% | 25.0% |
| **Explicación del Comportamiento Emergente** | 25% | Análisis de cómo las fluctuaciones de $K$ (por reposo o disparos) generan transiciones entre caos, cardúmenes locales y sincronía global. | 100% | 25.0% |
| **Demostración de Objetivos de la Unidad** | 25% | Integración de Kuramoto y Flocking dentro de una experiencia de minijuego FPS interactiva, expresiva y performativa. | 100% | 25.0% |
| **TOTAL PUNTOS** | **100%** | | | **100.0%** |

**Nota Propuesta:** 5.0 / 5.0
