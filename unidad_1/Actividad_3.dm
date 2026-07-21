#  Actividad 3

## En tus propias palabras cuál es la diferencia entre una distribución uniforme y una no uniforme de números aleatorios.

### respuesta

uniforme es cuando no hay ningun tipo de preferencia en un numero o resultado, por ejemplo el codigo de barras el cual esta uniformemente repartido en la imagne, pero no uniforme es cuando
se usa una preferencia en especifico para que los numeros aleatorios apunten a un resultado por preferenica 


## Modifica el código de la caminata aleatoria para que utilice una distribución no uniforme, favoreciendo el movimiento hacia la derecha.

### respuesta
```js
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

let walker;

function setup() {
  createCanvas(640, 240);
  walker = new Walker();
  background(255);
}

function draw() {
  walker.step();
  walker.show();
}

class Walker {
  constructor() {
    this.x = width / 2;
    this.y = height / 2;
  }

  show() {
    stroke(0);
    point(this.x, this.y);
  }

  step() {
    const choice = floor(random(4));
    if (choice == 0) {
      this.x++;
    } else if (choice == 1) {
      this.x++;
    } else if (choice == 2) {
      this.y++;
    } else {
      this.y--;
    }
  }
}
