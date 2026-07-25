# Bitácora Reto 07: Navegar la Incertidumbre

**Festival:** *Historia y filosofia*

**Tematica:** *Evolucion humana*

**Proyecto:** *Caminata Generativa con Ruido de Perlin y Distribuciones*

**Herramienta:** *Houdini*


## Propuesta

La propuesta plantea una caminata generativa continua donde el visitante no controla la trayectoria, sino que altera el espacio, demostranod como el humano se puede transformar y acoplar a las diferentes situaciones y espacios

---

## Procedimienoto

 - Introduccion: Primero se tomo como punto de inicio la simulacion del ruido de perlin de la actividad 6
 - Primer paso: necesitaremos crear un agente el cual sera el que camine sobre el terreno ya creado, para esto  se usara uno de los modelos de Mixamo con su respectiva       animacion de
   caminata, cabe aclarar que  para este ejemplo el rigging de estos mdoelos funciona totalmente con los nodos que vamos a usar para calcular  y caminar sobre los terrenos que
   se crearan de forma autogenerada
   ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-rigging.png)
   
- Segundo paso: exportaremos el modelo en el nodo "agent 1" y su animacion en "agentclip1", luego los conectaremos a agentprep1, el cual mas adelante nos ayudara a hacer que nuestra animacion se vea fluida y los pasos colisionen bien con el teerreno, por ultimo conectaremos agentterrainadaptation1, el cual hara todo el trabajo de que nuestro personaje logre caminar entre el terreno montañoso

  ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-agente-composicion.png)
   
  Lastimosamente nuestro personaje se sentira como si si se estuviese resbalando mas que como si estuviese caminando por encima del    terreno

   ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-personaje-error.png)

  Para esto, se usara el agentprep1, el cual le diremos a houdini cuales son los huesos que pertecen, a la pierna, la rodilla y el     pie y generar un foot locking, una red de canales que puede avisar a houdini cuando los pies estan colisionando en el suelo y   cuando no, de paso al crer el footlocking se creara este nodo, el cual no se tendra que conectar a ningun lado, pero si se debera conservar en el archivo, ya que como ya dije son los canales que mejoraran nuestra caminata
  
  ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-foot-plant-channels.png)

  Apenas este aparesca en en grid, nuestro modelo tomara esta forma
  
  ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-piernas-error.png)

  Vemos que los pies estan mas abajo de lo normal, esto se debe a que tenemos que ajutar los joints de los pies del modelo, por defecto estaran en los tobillos asi que tendremos que acomodarlos en el talon

  ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-acomodacion.png)
  
  
--


## ⚠️ 4. Dificultades y Soluciones

* **Dificultad:** Los saltos largos (*Lévy Flight*) sacaban las partículas del lienzo 9:16 de forma irrecuperable.
* **Solución:** Se implementó una regla de bordes "toroidales" (wrap-around) y una fuerza magnética leve basada en distribución normal que atrae suavemente la caminata hacia el centro cuando se aleja demasiado.

---

## 🖼️ 5. Evidencias Visuales

![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-rigging.png)

> **Nota:** La animación muestra cómo la presencia del visitante rompe el equilibrio del ruido de Perlin generando trayectorias excepcionales hacia los bordes.

---

## 🤖 6. Uso de IA Generativa y Cambios Realizados

* **Propuesta inicial de la IA:** La IA sugirió una estructura de código dividida en un *switch/case* con 5 estados independientes para los 5 momentos.
* **Cambio y criterio propio:** Rechacé la división por estados independientes porque el encargo exigía una *pieza única coherente*. En su lugar, utilicé la IA únicamente para depurar la fórmula matemática del cálculo gaussiano con `randomGaussian()` y combiné los 5 comportamientos en un solo vector de fuerzas sumadas.

---

## 📝 7. Autoevaluación

| Criterio | Cumplo | No cumplo | Evidencia en la bitácora |
| :--- | :---: | :---: | :--- |
| **Encargo completo:** interpreto los cinco momentos dentro de un mismo sistema visual. | **[X]** | [ ] | Sección 1: Traducción conceptual de los 5 momentos en un mismo lienzo 9:16. |
| **Simulación con intención:** utilizo al menos tres conceptos de la unidad para comunicar las ideas del encargo. | **[X]** | [ ] | Sección 1 y 2: Uso de *Caminata Aleatoria*, *Ruido de Perlin*, *Distribución Normal* y *Lévy Flight*. |
| **Interacción significativa:** la interacción modifica el comportamiento o las probabilidades del sistema, que también funciona sin intervención. | **[X]** | [ ] | Sección 1 (Momento 5) y Sección 3: La posición del cursor altera la escala del ruido y la varianza de la distribución. |
| **Prototipo funcional:** la experiencia puede ejecutarse y recorrerse completa sin errores que impidan comprenderla. | **[X]** | [ ] | Enlace funcional a p5.js y ejecución probada a pantalla completa en formato 9:16. |
| **Proceso documentado:** la bitácora evidencia avances, decisiones, dificultades, soluciones, uso de IA y enlace al prototipo. | **[X]** | [ ] | Secciones 2, 3, 4, 6 y el historial de commits dentro de este repositorio en GitHub. |

---

## 🗣️ Guión de Apoyo para la Presentación Oral (Puntos Clave)

1. **Intención:** *"Mi propuesta traduce la incertidumbre no como caos, sino como una estructura de probabilidades que el espectador deforma con su presencia."*
2. **Regla de simulación:** *"Utilizo el Ruido de Perlin para la 'Tendencia' y saltos de Lévy para la 'Excepción', asegurando que el sistema siempre descubra territorio nuevo incluso si nadie lo toca."*
3. **Evolución:** *"Comencé con un random walk tradicional que era indescifrable y fui superponiendo distribuciones de probabilidad para darle coherencia visual."*
