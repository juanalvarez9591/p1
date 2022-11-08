
# Ejecución de la tarea 2

En este documento se explican dos maneras de ejecutar y verificar la segunda tarea:

- **ejecución con interfaz gráfica:** esta modalidad le permitirá ejecutar el juego
  con todas las funcionalidades utilizando una interfaz gráfica construida por el
  equipo docete que integra los subprogramas escritos por el estudiante.

- **ejecución de test y prueba interactiva:** con esta modalidad podrá
  probar interactivamente cada subprograma pedido con distintas entradas.
  También se permite la ejecución automática de todos los casos de prueba.

# Archivos suministrados

El ambiente está formado por los siguientes archivos:

* Archivos del programa con interfaz:

    - `definiciones.pas` - Definiciones de constantes, tipos y procedimientos auxiliares.
    - `principal.pas` - Programa principal con interfaz gráfica que integra a los subprogramas escritos por el estudiante.
    - `principal.tcl` - Interfaz gráfica en lenguaje tcl-tk
    - `infoIF.txt` - documento de texto que explica algunos detalles técnicos sobre el funcionamiento de la interfaz.
    -  Archivos de datos con la extensión `.dat` que contienen algunos casos de prueba.
    
*  Archivos para ejecución del test

    -  `test_principal.pas` - programa que realiza test y ejecución interactiva de los subprogramas escritos por el estudiante
    -  `entradas` - carpeta con los casos de prueba para el test.
    -  `salidas`  - carpeta donde están las salidas correctas para cada caso del test.
    -  `mios`  y `diffs` - otras carpetas vinculadas al test.
    -   `test.sh`  - script de *bash* que permite compilar, ejecutar y comparar los casos de prueba automáticamente.

Estos archivos están comprimidos en el archivo `ejecucion_tarea2.tar.gz` que se
puede descargar en la sección de laboratorio del curso.

El contenido del archivo comprimido se debe extraer en una carpeta
cualquiera y en la misma se debe copiar el archivo `tarea2.pas` del estudiante con los subprogramas solicitados en esta tarea.

El archivo se puede descomprimir con el siguiente comando: `tar xzf ejecucion_tarea2.tar.gz`.
También funciona accionar con doble click sobre el archivo.


---------------------------------------------------

# Ejecución de programa con interfaz gráfica

## Cómo ejecutar el programa con interfaz

En este documento explicamos cómo ejecutar el programa principal
de la segunda tarea del laboratorio 2022.
El programa principal está escrito por el equipo docente.
En el archivo `infoIF.txt` se pueden encontrar más detalles sobre el funcionamiento de este programa.


## Compilación

 Se compila el programa `principal.pas`.
 Esto se hace una sola vez mientras no se hagan cambios en `tarea2.pas`.

```
    fpc -Co -Cr -Miso -gl principal.pas
```

y nos aseguramos que no hay errores de compilación y que se ha generado el ejecutable llamado `principal`.

Se debe compilar en **línea de comandos**.

## Ejecución

El programa con su interfaz gráfica se puede ejecutar con el comando:

```
     wish principal.tcl
```

Una vez ejecutado el comando anterior se abrirá una ventana de ejecución que le permitirá
ejecutar el juego con los subprogramas escritos por el estudiante en el archivo `tarea2.pas`

La interfaz es suficientemente intuitiva como para que pueda jugar  sin mayores indicaciones.

## Instalación necesaria para ejecutar el programa

 Para ejecutar el programa debe tener instalados los paquetes *tcl* y *tk*.

### Linux/Mac

Lo más probable es que su distribución Linux/Mac ya cuente con lo
necesario. Para constatarlo, ejecute desde la línea de comando el
programa wish:

```
  wish
```

Si está disponible en su máquina, verá abrirse una pequeña ventana,
mientras que en la consola se iniciará un diálogo. Para terminar la
ejecución, escriba exit en la consola, o cierre la ventana que se
abrió como hace habitualmente.

Si no está disponible, puede seguir los pasos que se muestran en
Instalación Free Pascal en Linux

[http://eva.fing.edu.uy/mod/page/view.php?id=58944](http://eva.fing.edu.uy/mod/page/view.php?id=58944), en la sección
Instalación por manejador de paquetes, pero en esta ocasión instalando
los paquetes tcl y tk.

Se ha detectado que la interfaz puede tener algunos problemas para ser ejecutado en MAC. Consultar el
archivo `infoIF.txt` que sugiere cómo resolver algunos de estos problemas.

### Windows

Para constatar si tiene instalado wish, ejecute desde la línea de comando el programa:

```
  wish
```

Si está disponible en su máquina, verá abrirse una pequeña ventana,
mientras que en la consola se iniciará un diálogo. Para terminar la
ejecución, escriba exit en la consola, o cierre la ventana que se
abrió como hace habitualmente.

Si no está disponible, puede bajar los archivos de instalación *msi*
correspondientes a su Windows desde la página de MagicSplat en
Sourceforge:

- [http://sourceforge.net/projects/magicsplat/files/magicsplat-tcl/](http://sourceforge.net/projects/magicsplat/files/magicsplat-tcl/)

Una
vez descargado, ejecute el archivo de instalación, que lo guiará con
los diálogos habituales.



---------------------------------------------------------------------------------------------------

# Ejecución de test y prueba interactiva

En esta sección se explica como ejecutar el test con los casos de prueba generados por los docentes.
También se explica como ejecutar interactivamente el programa `test_principal.pas`.

## Cómo ejecutar los casos de prueba de la Segunda Tarea

**Nota:**  Este test debe ser ejecutado en linux.



## Compilación y Ejecución del programa de test

Se debe compilar el programa `test_principal.pas`.
Esto se hace una sola vez mientras no se hagan cambios en `tarea2.pas`.

    fpc -Co -Cr -Miso -gl test_principal.pas

y nos aseguramos que no hay errores de compilación y que se ha generado el ejecutable llamado `test_principal`.

Se debe compilar en **línea de comandos**.

## Ejecutar  de manera interactiva

El programa se puede ejecutar de manera interactiva con el comando:

    ./test_principal

En esta modalidad el programa queda esperando que el usuario ingrese un comando.
Hay un comando para cada subprograma de la tarea.

Los comandos están formados por una letra que lo identifica y una lista de parámetros que se ingresan desde la entrada estándar.

Las letras de  los comando son:

- `i`  - Ingresa desde la entrada una zona de pelotas.
- `m ` - Muestra la zona de pelotas actual.
- `p`  - Ejecución de `darUnPaso`.
- `h`  - Ejecución de `estanChocando`.
- `f`  - Ejecución de `esFrontera`.
- `F`  - Ejeución de `obtenerFrontera`.
- `d`  - Ejecución de `disparar`
- `x`  - Ejecución de `eliminarPelotas`.
- `v`  - Ejecución de `esZonaVacia`.
- `q`  - Termina la ejecución.

A continuación explicamos cómo se ejecutan cada uno de los comandos.

### Ingreso zona de pelotas

El comando `i` se utiliza para  ingresar una zona de pelotas:

```
i
MMMMMMbb
bbbb....
........
rrrr..bb
MMM.....
........
...brbbr
MMMMbbbb
```

Luego de ingresar la opción `i` se ingresa una matriz de las dimensiones
de la zona de pelotas (tal como está definida en `definiciones.pas`).

Se utilizan los siguientes caracteres para representar las celdas:

- `M` - Una celda ocupada por una pelota *verde*.
- `b` - Una celda ocupada por una peolta *azul*.
- `r` - Una celda ocupada por una pelota *roja*.
- `.` - Una celda no ocupada.

Las posiciones de las pelotas **no se ingresan**. El propio procedimiento
de ingreso se ocupa de asignarle a cada pelota una posición apropiada
de acuerdo con la dimensión del escenario y la zona de pelotas.

El programa siempre trabaja con una zona de pelotas corriente.
Al inicio se carga una zona completa con todas las pelotas
de color rojo. Una vez que se ejecuta el comando `i` queda
la zona con los datos ingresados por ese comando.
Cada  ejecución de `i` cambia la zona corriente por la zona ingresada.

### Mostrar zona de pelotas

El comando `m` despliega en la salida la matriz de caracteres
que corresponde a la zona corriente. Se utilizan los mismos
caracteres que en el comando anterior.

Por ejemplo, si se ejecuta el comando `m`  al principio, el programa
muestra la siguiente zona en la salida:

```
==========
rrrrrrrr
rrrrrrrr
rrrrrrrr
rrrrrrrr
rrrrrrrr
rrrrrrrr
rrrrrrrr
rrrrrrrr
==========
```

### Dar un paso

La ejecución de el comando `p` sirve para invocar `darUnPaso`.


```
p
20 20
r
10 -10
```

En el ejemplo se ingresa un *balín* con posición (20,20)
con color rojo (`r`) y velocidad (10,10). El programa
muestra en la salida la nueva posición y velocidad luego de dar un paso:

```
posicion : (30,30)
velocidad : (20,20)
```

### Están chocando

La ejecución de el comando `h` sirve para invocar `estanChocando`.

```
h
100 199
r
100 205
r
```

En este ejemplo se ingresan dos pelotas rojas con posiciones (100,199)
y (100,205).  El programa despliega en la salida un booleano que
indica si ambas pelotas están chocando o no.

### Es frontera

La ejecución del comando `f` sirve para invocar `esFrontera`.

```
f
3 4
```

En este ejemplo, se quiere determinar si la posición (3,4) corresponde
a una celda frontera. El programa despliega un booleano que indica si
es frontera o no.

La condición de frontera se determina en relación a la *zona corriente*
(la zona ingresada por el último comando `i` o la zona inicial si no se ingresó
ninguna).


### Obtener Frontera

La ejecución del comando `F` sirve para invocar `obtenerFrontera`.

Al igual que en el comando anterior, aquí se realiza la operación
con respecto a la zona corriente.

El programa desplegará en la salida todas las posiciones de celdas
que son frontera con un formato como el siguiente:

```
====== comienzo secuencia =======
 ( 1, 1)
 ( 1, 2)
 ( 1, 3)
 ( 1, 4)
 ( 1, 5)
 ( 1, 6)
 ( 4, 8)
 ( 5, 1)
 ( 5, 8)
 ( 6, 1)
 ( 6, 8)
============fin==================
```

### Disparar

La ejecución del comando `d` sirve para invocar `disparar`.

Al igual que en el comando anterior, aquí se realiza la operación
con respecto a la zona corriente.

```
d
10 10
M
-3 11
```

En el ejemplo  se ejecuta el disparo con un balín verde
que está en la posición (10,10) y tiene velocidad (-3,11).
El programa desplegará en la salida un booleano indicando
si hay choque como el que se pide en la letra (esto es con una pelota de la frontera del mismo color que el balín).
Si este booleano es `TRUE` se despliega además la posición
de la pelota chocada.

Tener en cuenta   la ejecución de `disparar`  invoca
también el subprograma `obtenerFrontera`.

### Eliminar pelotas

La ejecución del comando `x` sirve para invocar `eliminarPelotas`.

```
x
1 3
6 7
8 8
-1
```

En el ejemplo anterior, se ingresa la secuencia de posiciones (1,3), (6,7), (8,8) (-1 es centinela).
Se invoca el procedimiento `eliminarPelotas` tomando como parámetros la zona corriente y la secuencia de posiciones
ingresada.

Este comando afecta la zona corriente y no produce ninguna salida. Para ver el resultado se puede invocar el comando `m`.

### Es zona vacía

La ejecución del comando `v` sirve para invocar `esZonaVacia`.
El programa despliega un booleno que indica si la zona corriente es o no vacía.




## Casos de Prueba

Los casos de prueba están en la carpeta `entradas`. Es posible ejecutar cada uno por separado o
ejecutar todos los casos.

### Probando un Caso de Prueba


Si queremos probar un caso de prueba particular, por ejemplo  `01.txt`, procedemos así:

Ejecutamos nuestro programa de la siguiente forma:

     ./test_principal  < entradas/01.txt  > mios/01.txt

El comando anterior ejecuta el programa principal de manera tal que la
entrada es leída desde el archivo `entradas/01.txt` y la salida es
guardada en el archivo `mios/01.txt`.

Luego se verifica que la salida obtenida coincida con la salida esperada ejecutando el comando:

     diff -w  mios/01.txt  salidas/01.txt

Si no hay diferencias entre los archivos `mios/01.txt` y `salidas/01.txt` el comando no emite ninguna salida.
Eso significa que el test es correcto para el caso 01.

En cambio, si el comando `diff` emite alguna salida, el test es incorrecto. Para conocer la diferencia
recomendamos mirar (*a ojo*) el contenido de los archivos `mios/01.txt` y `salidas/01.txt`.
El primero es el resultado desplegado por el programa del estudiante y el segundo el resultado correcto.

### Verificando todos los casos

Adjuntamos además un script de *bash* que permite ejecutar
automáticamente todos los casos y nos indica para cada test si es
correcto o no. El test se ejecuta de la siguiente manera en la
terminal:

    $ bash test.sh

Este comando: compila el programa principal, ejecuta cada uno de los
casos de prueba de la carpeta `entradas`, y compara cada resultado
obtenido con la salida esperada que está en la carpeta `salidas`.  
Las salidas quedan en la
carpeta `mios`.  
Además en la
pantalla se indica el resultado al ejecutar cada caso y al final se
informa la cantidad de casos correctos e incorrectos.
