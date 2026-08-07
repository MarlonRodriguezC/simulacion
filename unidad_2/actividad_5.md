# Bitácora Actividad 05: Reto de Diseño – Una Contradicción en Movimiento

**Proyecto:** Abandonar el planeta tierra
**Herramienta:** Houdini

---

## 1. Intención y Contradicción

Quiero explorar la tensión entre la necesidad   de los recursos  naturales  y el sentimiento de exploracion

### Manifestación en el sistema
Las particulas crearan una especie de planeta tierra en el cual viviran hasta cierto punto, despues de cierto tiempo el sistema de particulas cambiara sus valores haciendo que unas particulas exploten y la mision de las que quedan en el planeta tierra sera intentar abandonar todo ese espacio donde estan las particulas repartidas, crearan una especie de gusano/nave con ellas mismas pero al abandonar la zona se quedaran sin recursos ni motivo por el cual seguir moviendose, quedando vagas en el espacio

---
### Nodos necesarios para el proyecto
![Captura de pantalla de la experiencia en ejecución](assets/unidad-2/Nodos-1-a5-u2.png)

---

### Matriz de Relaciones 4x4 
Valores positivos representan atracción y valores negativos repulsión. Las filas indican la partícula que reacciona y las columnas el vecino que ejerce la fuerza).

| Desde \ Hacia | Tipo 0 (Amarillo) | Tipo 1 (Verde) | Tipo 2 (Azul) | Tipo 3 (Rojo) |
| :--- | :---: | :---: | :---: | :---: |
| **Tipo 0 (Amarillo)** | `4.0` | `2.0` | `0.0` | `0.0` |
| **Tipo 1 (Verde)** | `6.0` | `1.0` | `0.0` | `-3.0` |
| **Tipo 2 (Azul)** | `1.0` | `0.0` | `2.0` | `-6.0` |
| **Tipo 3 (Rojo)** | `1.0` | `0.0` | `-6.0` | `2.0` |

### Parámetros Globales
* **Distancia de Interacción ($R_{max}$):** `chf('Maximum_Distance')` $\approx 0.711$
* **Radio de Repulsión Mínima ($R_{min}$):** `chf('Minimum_Distance')` $\approx 0.16$
* **Fricción :** ` $\approx 0.08$
* **Fuerza Escalar:** `chf('Force_Scale')`  $\approx 1$
* **Tiempo de Cambio:** `chf('Switch_Tiempo')` $\ 1 \text{s}$
* **Distribución Inicial:** Concentrada en una esfera densa (representando el Planeta Tierra).

---

## 2. Código del Sistema (VEX)

Implementación del comportamiento en un **POP Wrangle** evaluando la matriz de interacción $4\times4$, la inversión por tiempo y el rango de fuerza suavizado por curva:

```c
matrix parms = ch4('Parameters');
float mindist = chf('Minimum_Distance');
float maxdist = chf('Maximum_Distance');
float force_scl = chf('Force_Scale');

float switch_time = chf('Switch_Tiempo'); 

// Disparador de cambio de matriz 
if (@Time >= switch_time) {
    parms *= -1.0; 
}

int npts[] = nearpoints(0, v@P, maxdist, 100);
removevalue(npts, @ptnum);

vector aceleracion = {0,0,0};

```
Primero haremos los controladores de la simulaicon y asi tambien de una vez un condicional que haga que toda la matrix cambie despues de cierto tiempo, y crearemos una lista la cual nos ayudara a calcular los 100 puntos mas cercanos tomando en cuenta la posicion de cada pounto y tambien la maxima distancia, la idea es que no pase la maxima distancia dictada, y pondremos un vector de aceleracion en ceros,  Ya con eso listo, armamos el ciclo foreach para recorrer punto por punto a todos los vecinos que encontramos en la lista `npts`:
```c

foreach(int npt; npts){
    int ntype = point(0, "type", npt);
    vector npos = point(0, "P", npt);
    
    vector direccion = npos - v@P;
    float dist = length(direccion);
    
    // Repulsion de seguridad a  la corta distancia
    if(dist < mindist){
        direccion = normalize(direccion) * fit(dist, 0.0, mindist, -10.0, 0.0) * force_scl;
    }
```
Dentro del ciclo, lo primero es traer con el nodo `point` el tipo de partícula que es el vecino (`ntype`) y su posición en el espacio (`npos`). Con eso calculamos el vector de dirección restando las posiciones (`npos - v@P`) y sacamos la distancia real entre los dos con la función length

Luego metemos el condicional para manejar las fuerzas según qué tan cerca estén:

Si la distancia es menor a la distancia mínima (`mindist`), significa que se están acercando o acumulando demasiado  entonces esto hace que que ignoremos la matriz y forzamos una repulsion directa usando un `fit` que va de -10.0 a 0.0, multiplicado por el vector de dirección normalizado y la escala de fuerza para que no se traslapen las partículas
```c

else{
        float ramppos = fit(dist, mindist, maxdist, 0.0, 1.0);
        direccion = normalize(direccion) * chramp('Shape', ramppos) * getcomp(parms, i@type, ntype) * force_scl;
    }
    
    aceleracion += direccion;
}

v@force += aceleracion;
```


Si estan a una distancia normal (osea entre mindist y maxdist), usamos el else. Mapeamos esa distancia de 0 a 1 en `ramppos` para pasársela a la curva de la rampa `chramp('Shape')`, y la multiplicamos por la matriz usando `getcomp(parms, i@type, ntype)`. Así es como el programa sabe si mi tipo de particula se atrae o se repele con la del vecino segun el valor de la tabla 

Toda esa direccion calculada se la vamos sumando a la variable de aceleracion en cada vuelta del ciclo. Al salir del `foreach`, simplemente le sumamos la aceleracion acumulada a la fuerza global con `v@force += aceleracion` para que el POP Solver mueva las partículas en la simulacion


---
### Cambios y dificultades del proyecto
Este proyecto fue algo retador para mi, ya que aunque existen 

### Parámetros Globales
* **Distancia de Interacción ($R_{max}$):** `[Valor]`
* **Radio de Repulsión Mínima ($R_{min}$):** `[Valor]`
* **Fricción / Amortiguación:** `[Valor]`
* **Velocidad Máxima:** `[Valor]`
* **Distribución Inicial:** `[Ej: Aleatoria en el lienzo / Concentrada en el centro]`

---

## 3. Justificación de Decisiones de Diseño

* Seleccioné **[Parámetro / Cantidad / Tipo]** porque quiero hacer perceptible **[Intención visual/física]**. Espero que produzca **[Resultado directo en pantalla]**.
* Seleccioné la relación asimétrica **[Tipo A vs Tipo B]** porque quiero hacer perceptible **[la desigualdad o tensión]**. Espero que produzca **[un flujo constante sin llegar nunca al equilibrio]**.
* Seleccioné un nivel de fricción de **[Valor]** porque quiero hacer perceptible **[la inercia / la fluidez]**. Espero que produzca **[agrupaciones orgánicas en lugar de explosiones erráticas]**.

---

## 4. Registro de Pruebas y Descartes

### Ajustes y Experimentos
1. **Prueba 1 (Inestabilidad):** Inicialmente probé con una velocidad máxima muy alta (`[Valor]`).  
   * *Resultado:* Las partículas salían disparadas y rompían las estructuras.  
   * *Ajuste:* Se redujo la velocidad máxima a `[Nuevo Valor]` e incrementé la fricción.
2. **Prueba 2 (Equilibrio estático):** Con una matriz simétrica, el sistema se congelaba en patrones estáticos rápidamente.  
   * *Ajuste:* Introduje la asimetría entre **[Tipo B]** y **[Tipo C]** para romper la cristalización.

### Descartes
* **Descarte 1:** Se descartó el uso de formas complejas o sprites para las partículas; se mantuvieron como **[puntos / círculos simples]** para que la identidad de la pieza dependa 100% de la dinámica de movimiento y no del aspecto gráfico.
* **Descarte 2:** Se descartó agregar una fuerza de gravedad global porque opacaba las fuerzas interindividuales de la matriz.

---

## 5. Manifestaciones del Sistema (Variaciones)

![Manifestación 1 - Semilla A](/assets/unidad-2/actividad-05/semilla-01.png)  
*Semilla `[#]`:* Estructura en fase inicial, mostrando **[comportamiento observable]**.

![Manifestación 2 - Semilla B](/assets/unidad-2/actividad-05/semilla-02.png)  
*Semilla `[#]`:* Comportamiento emergente tras `[N]` frames, observándose **[patrón, cluster o bucle]**.

---

## 6. Sustentación de lo Diseñado vs. lo Emergente

* **Lo Diseñado (Reglas fijas):** Las distancias de corte, la matriz de atracción/repulsión asimétrica y la fricción del entorno.
* **Lo Emergente (Resultado no programado explícitamente):** La formación de **[ej: espirales, persecuciones en cadena, membranóforos o vacíos circulares]** que surgen espontáneamente de la suma de interacciones locales.

---

## 7. Autoevaluación Sustentada

| Criterio | Peso | Valoración (%) | Aporte | Evidencia / Sustento |
| :--- | :---: | :---: | :---: | :--- |
| **Intención clara y perceptible** | 20% | `[0-100]%` | `[Aporte]` | Se evidencia en la tensión entre [Tipo A] y [Tipo B] visible en la rutina de movimiento. |
| **Justificación de parámetros y matriz** | 25% | `[0-100]%` | `[Aporte]` | Cada valor de la matriz tiene un propósito documentado en la sección 3 de esta bitácora. |
| **Comprensión técnica del sistema** | 20% | `[0-100]%` | `[Aporte]` | Implementación y control de posición, velocidad, aceleración y distancias en el código VEX/Script. |
| **Variaciones con identidad reconocible** | 15% | `[0-100]%` | `[Aporte]` | Distintas semillas generan patrones únicos pero con la misma firma de movimiento. |
| **Experimentación y descartes** | 10% | `[0-100]%` | `[Aporte]` | Documentados los intentos fallidos de cristalización y exceso de velocidad en la sección 4. |
| **Distinción entre lo diseñado y emergente** | 10% | `[0-100]%` | `[Aporte]` | Claridad entre las ecuaciones base y las estructuras colaterales que se forman a largo plazo. |
| **TOTAL** | **100%** | | **`[Suma]%`** | **Nota Propuesta:** `[Puntaje Total / 20]` / 5.0 |

---
