# Actividad 04

## Crea un nuevo sketch en p5.js que represente una distribución normal, pero visualizándola de manera diferente a la del ejemplo.

### respuesta

para esto, voy a hacer el proyecto en houdini, primero puse un simple plano, luego un scatter, el cual vuelve la superficie en diferentes puntos distribuidos sobre la maya, despues puse un
attributewrangle, el cual funciona como un nodo script  y utilizo el siguiente codigo 

### respuesta
```c
float seed1 = rand(@ptnum + chf("aleatoridad")+@Time);

float seed2 = rand(@ptnum + chf("aleatoridad2"));

float r_dispersion = chf("dispersion_X"); 
vector centro = chv("centro_pos");        

@P.x = sample_normal(centro.x, r_dispersion, seed1);

@P.y = centro.y;

@P.z = sample_normal(centro.z, r_dispersion, seed2);


```
Este codigo crea dos semillas, las cuales se repartiran en el eje X o Z, un vector de posicion (que literalmente solo dice en que posicion poner el plano, simplemente lo puse por 
decoracion) y un un vector de centro, y una dispersion, esta puede hacer que lso puntos se expandan mas o se junten mas, ya depende en que posicion de camara estes si quieres verlo mas o menos
