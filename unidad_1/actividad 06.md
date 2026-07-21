# Actividad 06

## Crea un nuevo sketch en p5.js donde los visualices el Ruido de Perlin.
## Explica por qué lo visualizaste de esa manera y qué resultados esperabas obtener.

para esto, voy a hacer el proyecto en houdini, primero puse un simple plano, luego un attribwrangle, para este caso ya houdini tiene un comando establecido para crear noise, y hay un comando aun
mas parecido xnoise (literalmente la documentacion de houdini dice que es mas cercana aun al ruido de perlin), aqui pondre el codigo y intentare explicar algunos parametros, ya que solo se veran
en la interface del progrmaa 

### respuesta
```c


float val = xnoise(@P * chf("scale") + set( 0, chf("shift") + @Time, 0));

//chf("shift")

@P.y= val * chf("height");

f@noiseval = val; 


```
Puede que hayas notado en los anteriores codigo que utilizo el comando chf o chv, donde estos crean una barra o un espacio en la interface donde tu mismo puedes colocar le numero que quieras
o controlarlo dentro de cierto rango predeterminado, para esto, cree 3 comandos, scale, shift, height. Scale hara que que tan cerca estaran las montañas de perlin con las otras y luego un shift
el cual dira que forma tendra el ruido de perlin, pero como en este caso esta siendo sumado con el tiempo, la verdad es que puedes ponerle cualquier numero, pero si quieres que este quieto en un
estado especifico solo quitale el @Time, por ultimo esta height, el cual es la altura de las montañas, estas pueden hacerse mas hondas y altas, o mas pegadas al suelo
