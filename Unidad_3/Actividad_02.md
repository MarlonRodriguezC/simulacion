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

## 3. Procedimiento e Implementación del Instrumento

### Paso 1: Configuración de la Fuerza y las Partículas
Se estableció un sistema de partículas en tres dimensiones aceleradas por un vector de fuerzas dinámico:

$$\vec{F}_{total} = \vec{F}_{viento} + \vec{F}_{atracción} + \vec{F}_{fricción}$$

Cada partícula actualiza su posición basándose en integraciones de movimiento e inercia.

### Paso 2: Controles e Interacción en Tiempo Real
Se mapearon eventos de teclado e interfaz para manipular las fuerzas del entorno sobre el lienzo:

```javascript
// Integración de eventos de teclado para control de fuerzas e instrumentos
function keyPressed() {
  // Ajuste de velocidad global con Q y E
  if (key === 'q' || key === 'Q') {
    fuerzaVelocidad -= 0.05;
  } else if (key === 'e' || key === 'E') {
    fuerzaVelocidad += 0.05;
  }
  
  // Pausa o anulación del viento / fuerza constante
  if (key === 'x' || key === 'X') {
    vientoActivo = !vientoActivo;
  }
  
  // Generación de patrón/forma personalizada (ej. Corazón)
  if (key === 'l' || key === 'L') {
    generarAtractorCorazon();
  }
}
