# Bitácora Unidad 4: Oscilación y Sincronía - Kuramoto Abisal

---

## 1. Proyecto Funcional y Publicado

- **URL Pública:** [https://editor.p5js.org/mugsky/sketches/NWV-d32Ek) 

- **Modo LAB / Visor HUD:** Pantalla interactiva en tiempo real que simula la interfaz del casco de buzo, permitiendo monitorear el Faro de Sincronía LED (`DISPERSO`, `ACOPLÁNDOSE`, `UNÍSONO`), controlar el acoplamiento y ejecutar la percusión por disparo.

---

## 2. Ficha del Modelo de Kuramoto

### Ecuación General Utilizada
$$\frac{d\theta_i}{dt} = \omega_i + \frac{K}{N} \sum_{j=1}^{N} \sin(\theta_j - \theta_i)$$

- **$\theta_i$ (Fase del Pez $i$):** Representa la posición actual en el ciclo de oscilación o "respiración bioluminiscente" del pez.
- **$\omega_i$ (Frecuencia Natural):** Velocidad intrínseca de oscilación de cada pez cuando no está influenciado por el grupo (`random(0.02, 0.05)`).
- **$K$ (Fuerza de Acoplamiento):** Parámetro global/local de cohesión rítmica del agua abisal.
- **$N$ (Vecinos Locales):** Cantidad de peces detectados dentro del radio de percepción ($<70\text{px}$).
- **$\sin(\theta_j - \theta_i)$:** Término de acoplamiento no lineal que acelera o desacelera al pez para sincronizar su fase con la de sus vecinos.

### Parametrización Inicial
- `K_base`: $0.05$ (recuperación progresiva hacia el estado de sincronía).
- `radius_perception`: $70\text{px}$ (red de topología local).
- `N_agents`: $8$ agentes.
- `K_disruption`: $-0.08$ por disparo de arpón.

### Justificación de Modificaciones respecto al Modelo Básico
* **Topología Local en lugar de Global:** En el modelo original de Kuramoto todos los osciladores interactúan con todos. En este proyecto se condicionó la interacción a un radio de visión ($<70\text{px}$). 
* **Justificación de Diseño:** Permite que emerjan "bolsones" o clústeres locales de sincronía que navegan por la pantalla antes de consolidarse en un cardumen global, lo que hace el comportamiento visual y espacial mucho más rico y orgánico.

---

## 3. Registro de Pruebas y Comportamientos Emergentes

| Prueba | Configuración de $K$ y Entorno | Resultado Observado |
| :--- | :--- | :--- |
| **1. Acoplamiento Nulo ($K = 0$)** | $K=0$, sin interacciones de fase. | **Desorden Total.** Cada pez oscila a su propia frecuencia natural $\omega_i$. Las luces bioluminiscentes titilan a ritmos completamente descoordinados y el grupo se dispersa en el espacio. |
| **2. Transición Progresiva (Reposo)** | $K$ incrementa gradualmente sin disparos. | **Organización Parcial a Estable.** Aparecen pequeños grupos rítmicos locales que luego contagian al resto de la población. El indicador del HUD pasa de `DISPERSO` a `ACOPLÁNDOSE` y finalmente a `UNÍSONO`. |
| **3. Perturbación Percutiva (Disparo)** | Disparo de arpón en el centro del cardumen. | **Desagregación Caótica.** $K$ cae drásticamente. Los peces se asustan, rompen filas, sus ritmos de pulso bioluminiscente pierden coherencia y el HUD alerta inmediatamente en rojo con el texto `DISPERSO`. |
| **4. Síntesis Sonora Seleccionada** | Clic directo sobre un pez individual. | **Respuesta Multicanal.** Suena el tono exacto mapeado a la fase de ese pez en la escala musical asignada (`notasPeces[id]`), confirmando auditivamente la alteración de su ciclo. |

---

## 4. Score y Experiencia Performativa

| Estado del Sistema | Intención Auditiva / Visual | Acciones del Performer |
| :--- | :--- | :--- |
| **Fase 1: Calma Abisal (Sincronía)** | Cohesión rítmica armónica, pulso bioluminiscente al unísono. | Dejar el sistema en reposo ($K \to \text{máx}$). El Faro LED brilla en verde constante al ritmo del grupo. |
| **Fase 2: Intervención Percutiva (Ataque)** | Ruptura tímbrica y visual, ritmo caótico polisincrónico. | Disparar repetidamente el arpón para golpear peces clave, desplomando $K$ y haciendo sonar notas individuales en contratiempo. |
| **Fase 3: Reorganización Emergente** | Reestructuración progresiva de ondas y tonos de retorno. | Cessar disparos y ajustar el control de oxígeno para observar el fenómeno de autoorganización rítmica en directo. |

---

## 5. Bitácora de Uso y Criterio frente a IA

| Prompt / Consulta a IA | Sugerencia Recibida de la IA | Decisión y Corrección Aplicada | Razón de la Decisión |
| :--- | :--- | :--- | :--- |
| *"¿Cómo hacer que la sincronización de Kuramoto active sonidos en p5.js?"* | Disparar sonidos en cada frame dentro del loop `draw()` usando condicionales de fase. | **Rechazada.** Se implementó un evento discreto al interactuar con el pez e integrarlo con sintetizadores polifónicos en Tone.js. | Disparar audio continuo en cada frame saturaba el buffer de audio y bloqueaba el hilo principal de ejecución. |
| *"Modificar la variable K de Kuramoto mediante un reloj automático."* | Crear un `setInterval` que cambie $K$ de 0 a 1 cada 5 segundos de forma automática. | **Rechazada.** Se ató la variación de $K$ a la acción directa del usuario mediante el disparo de arpón. | La guía exige expresamente que el sistema sea performativo y no una simple animación predeterminada o temporizada. |
| *"Diseñar la interfaz de sincronía para el HUD."* | Colocar un slider de porcentaje estándar de HTML. | **Modificada.** Se construyó un Faro LED bioluminiscente con texto dinámico (`DISPERSO`, `ACOPLÁNDOSE`, `UNÍSONO`). | Refuerza la identidad estética abisal y la comunicación visual perceptible exigida en la rúbrica. |

---

## 5. Autoevaluación Ponderada

| Criterio | Peso | Qué demuestra la evidencia | Valoración (0-100) | Aporte Calculado | 
| :--- | :---: | :--- | :---: | :---: | :--- |
| **Requisitos Mínimos Cumplidos** | 25% | 8 agentes móviles, 4 personalidades audiovisuales, $K$ modificable en tiempo real, 2 formas de interacción performativa y comunicación de 3 estados del colectivo. | **100%** | 25.0% | 
| **Explicación de Variables del Modelo** | 25% | Explicación formal y aplicada de $\theta_i$, $\omega_i$, $K$, $N$ y $\sin(\theta_j - \theta_i)$ dentro del contexto del comportamiento de los peces abisales. | **100%** | 25.0% | 
| **Explicación del Comportamiento Emergente** | 25% | Sustento de cómo las variaciones de $K$ producen las transiciones entre desorden, acoplamiento y unísono visual y sonoro. | **100%** | 25.0% | 
| **Demostración de Objetivos de la Unidad** | 25% | Integración de Kuramoto como instrumento audiovisual performativo no sustituible por temporizadores o secuenciadores tradicionales. | **100%** | 25.0% | 
| **TOTAL PUNTOS** | **100%** | | | **100.0%** | **Nota Propuesta: 5.0 / 5.0** |
