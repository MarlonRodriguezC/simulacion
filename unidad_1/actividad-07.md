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

- Tercer paso: Se crearon estos floats iniciales para definir el comportamiento del terreno, ya que la idea es tener una version donde un eje sea aleatorio y el otro no, y que uno use una distribucion uniforme mientras el otro no lo es. Tambien se dejaron listas las variables de velocidad para que el usuario pueda alternar libremente entre una velocidad neutra y una mucho mas rapida de lo habitual:
  
  ```c
  float shift_x_manual = chf("shift_X");
  float shift_z_manual = chf("shift_Z");

  float vel_x = chf("velocidad_X");
  float vel_z = chf("velocidad_Z");

  float u_rand_x = rand(100 + @ptnum);
  float shift_x_rand_uniforme = fit01(u_rand_x, -0.1, 0.1);

  float nu_rand_z = pow(rand(200 + @ptnum), 3.0); 
  float shift_z_rand_no_uniforme = fit01(nu_rand_z, -0.1, 0.1);

  int es_random = chi("modo_random"); 
 
  float final_shift_x;
  float final_shift_z;
  ```

  Despues se usaron condicionales para que el programa pueda identificar automaticamente que tipo de modo se esta ejecutando en tiempo real. Si el parametro no esta en el modo 1, el codigo asume que se esta trabajando en modo manual, pero si esta activado en el modo 1, pasa a usar las variables del modo aleatorio:
  ```c
  if (es_random == 1) 
  {
    final_shift_x = shift_x_rand_uniforme;
    final_shift_z = shift_z_rand_no_uniforme;
  } 
  else
  {
    final_shift_x = shift_x_manual;
    final_shift_z = shift_z_manual;
  }
  ```
  Por ultimo, se calcula el vector offset agrupando los desplazamientos de X y Z junto con la velocidad multiplicada por el tiempo (@Time). Este vector final es el que se le pasa a la funcion xnoise mezclado con la posicion @P para deformar la altura en @P.y

  ```c
  vector offset = set( 
    final_shift_x + (@Time * vel_x), 
    chf("shift") + (@Time / 2.0),    
    final_shift_z + (@Time * vel_z)
  );

  float val = xnoise(@P * chf("scale") + offset);

  @P.y = val * chf("height");

  f@noiseval = val;
  ```
  por ultimo conectamos todo a un merge para poder ver las simulaciones y para dar por sentado el proyecto el nodo merge se conectara a un null

  ![Captura de pantalla de la experiencia en ejecución](/assets/unidad-1/actividad-07/actividad-07-null.png)

  
  
  
  
--
## Decisiones tomadas y alternativas descartadas
  A la hora de desarrollar el proyecto se descartaron varias ideas:

- Multitudes y agentes extra: Se penso en meter una multitud completa usando el sistema de crowds de Houdini, pero se descarto para mantener el foco en la caminata y la adaptacion del agente principal.
- Terrenos mas grandes y variacion de color: Se podian agregar mas variaciones visuales, mapas de color complejos o ampliar el tamaño del plano, pero se decidio parar en este punto de la simulacion ya que la pieza cumple con el objetivo y si le seguia sumando cosas el proyecto no terminaria nunca.
- Transiciones entre escenas: En lugar de dividir la experiencia en escenarios separados, se decidio mantener un solo lienzo continuo donde las variaciones ocurrieran en tiempo real y hacerlo lo mas interactivo posible

--

## Dificultades y soluciones

- Entender los tipos de ruido y aleatoriedad al inicio: Lo mas dificil del proceso fue al comienzo cuando estaba creando el ruido de Perlin. Me tomo tiempo entender la diferencia entre los comandos porque notaba que habia varios tipos de noise (como xnoise) y tambien distintas formas de usar rand para controlar distribuciones uniformes o no uniformes. Una vez que entendi como mapear y escalar los valores en VEX, la estructura del terreno salio fluida.

  
- Manejo de la herramienta: Por el contrario, la parte de hacer que el personaje caminara sobre el terreno y la configuracion de los nodos de simulacion no fue tan compleja. Mas que programar de cero, consistio en saber elegir las opciones correctas en los nodos de Agent y ajustar los canales de colision para que la caminata se adaptara bien a las montañas

---

## 7. Autoevaluación

| Criterio | Cumplo | No cumplo | Evidencia en la bitácora |
| :--- | :---: | :---: | :--- |
| **Encargo completo:** interpreto los cinco momentos dentro de un mismo sistema visual. | **[X]** | [ ] | Sección 1: Traducción conceptual de los 5 momentos en un mismo lienzo 9:16. |
| **Simulación con intención:** utilizo al menos tres conceptos de la unidad para comunicar las ideas del encargo. | **[X]** | [ ] | Sección 1 y 2: Uso de *Caminata Aleatoria*, *Ruido de Perlin*, *Distribución Normal* y *Lévy Flight*. |
| **Interacción significativa:** la interacción modifica el comportamiento o las probabilidades del sistema, que también funciona sin intervención. | **[X]** | [ ] | Sección 1 (Momento 5) y Sección 3: La posición del cursor altera la escala del ruido y la varianza de la distribución. |
| **Prototipo funcional:** la experiencia puede ejecutarse y recorrerse completa sin errores que impidan comprenderla. | **[X]** | [ ] | Enlace funcional a p5.js y ejecución probada a pantalla completa en formato 9:16. |
| **Proceso documentado:** la bitácora evidencia avances, decisiones, dificultades, soluciones, uso de IA y enlace al prototipo. | **[X]** | [ ] | Secciones 2, 3, 4, 6 y el historial de commits dentro de este repositorio en GitHub. |
