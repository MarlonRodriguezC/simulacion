#  Actividad 05

## Crea un nuevo sketch en p5.js donde modifiques uno de los ejemplos anteriores y adiciones de Lévy flight.



### respuesta

Para esto cree 4 proyectos, el primero fue una simulacion del caminador que ya conozemos, el segundo fue siguiendo el ejercicio donde el punto prefiere ir a la derecha, para estos dos ejemplos 
se usara la misma arquitectura en nodos, solo cambiara los  scripts y ya luego veremos los 2 proyectos restantes.

Primero usaremos un plano, luego un scatter para  el cual vuelve la superficie en diferentes puntos distribuidos sobre la malla y luego usaremos un solver, el cual podra reconozer el objeto en el
frame pasado y seguir con su camino, dentro de este conectaremos un attribwrangle, le conectaremos en el la primer entrada el input 1 y en la entrada 1 el nodo prev_frame


### PRIMER CODIGO
```js
int pasado = npoints(1); 

if (pasado > 0) {

    @P = point(1, "P", pasado - 1);
    
}


float paso_final = 0.5;


vector azar = rand(@Frame * 83.14);

float dir_x = fit01(azar.x, -1.0, 1.0);
float dir_z = fit01(azar.y, -1.0, 1.0); 
vector direccion = normalize(set(dir_x, 0, dir_z));


@P += direccion * paso_final;
```
Ya con el primer codigo, lo primero que dice es de que los puntos van a  tener encuenta lo que ocurrio en el frame pasado para seguir su marcha, tiene dos floats que definen la direccion
tanto en el eje x como z (si queremos usar el eje y, se usa de la misma forma), ahora durante esta direccion se tomara un numero al azar entre -1 y 1 , estas pasan a estar dentro de un vector 
el cual nos da un resultado de a donde ir

NOTA: se utiliza normalize para que el resultado no salga por encima de 1, ya que en este codigo si el punto decide ir de forma diagonal, esta traspasara el limite)

despues de esto el paso con el cual se mueve el punto en cada frame se multiplicara con la direccion y  se aplicara en cada punto


### SEGUNDO CODIGO
```js
int pasado = npoints(1); 

if (pasado > 0) {

    @P = point(1, "P", pasado - 1);
    
}


float paso_final = 0.5;


vector azar = rand(@Frame * 83.14);


float dir_x = fit01(azar.x, 0, 1.0);
float dir_z = fit01(azar.y, -1.0, 1.0); 
vector direccion = set(dir_x, 0, dir_z);


@P += direccion * paso_final;

```
Este codigo es muy similar al anterior, solo que este cumple con el anterior reto de que solo vaya a la derecha, simplmeente cambie el float de dir_x, pasando de ir de -1 a 1 si no de 0 a 1 

### TERCER CODIGO - version casera del vuelo de levy
```js
int pasado = npoints(1); 

if (pasado > 0) {

    @P = point(1, "P", pasado - 1);
    
}


float paso_final = 0.5;

vector azar = rand(@Frame * 83.14);

float dir_x = fit01(azar.x, -1.0, 1.0);
float dir_z = fit01(azar.y, -1.0, 1.0); 

if (azar.z > 0.96) {
    paso_final = 3.0; // Cambiamos el paso corto por un salto enorme
}

vector direccion = set(dir_x, 0, dir_z);


@P += direccion * paso_final;

```
Esta version sigue la misma estructura de nodos que los anteriores, solo que ahora si el numero de azar que se hace dentro del rand, es mayor de 0.96 este tomara un paso largo, asi como el vuelo 
de levy
NOTA: no se puede poner 0.99 ya que es imposible que el codigo llegue a 1 usando este script

### CUARTO CODIGO - version profesional del vuelo de levy
```js
int pasado = npoints(1); 
if (pasado > 0) {
    @P = point(1, "P", pasado - 1);
}

float r = rand(@Frame * 83.14);
r = clamp(r, 0.0, 0.999); 

float l_min = 0.08;       
float alpha = 1.5;        

float paso_final = l_min * pow(1.0 - r, -1.0 / alpha);


vector azar = rand(@Frame * 29.45);
float dir_x = fit01(azar.x, -1.0, 1.0);
float dir_z = fit01(azar.y, -1.0, 1.0);
vector direccion = set(dir_x, 0, dir_z);

@P += direccion * paso_final;

```
Esta version tiene algunas diferencias mas notables, aunque la direccion es la misma, el tema del paso final cambia totalmente, aqui por medio de la IA le pedi que me diese una formula exacta
para lograr el vuelo de levy, principalmente el paso minimo se multiplica con un pow, un pow "es un numero elevado a la X", en este caso se crea un numero r entre 0.0 y 0.9 y luego lo restaremos
a un 1.0 y este numero sera llevado a a la -1.0 dividido 1.5, el cual nos dara un resultado distinto cada vez y tomara grandes pasos cada tanto


## Explica por qué usaste esta técnica y qué resultados esperabas obtener.

Use esta tecnica ya que fue una forma facil de simplificar las cosas primero y luego simplemente tallarlo mas, y si salio como esperaba, aunque obviamente si queria usar una formula mas precisa 
al vuelo de levy hubiese tenido que suar formuals mas elaboradas como la msotrada en el cuarto codigo, pero todo salio como esperaba, un punto moviendose en el plano y cada tanto dando un 
salto al azar





