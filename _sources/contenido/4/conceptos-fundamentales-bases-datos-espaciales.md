# Conceptos fundamentales de bases de datos espaciales

## Introducción
Una base de datos espacial agrega a una base de datos convencional componentes para manejo de datos espaciales, tales como tipos de datos espaciales, índices espaciales y funciones espaciales.

## Evolución del manejo de datos espaciales
El manejo de datos espaciales ha evolucionado desde sistemas propietarios hasta geometrías integradas en la estructura de las bases de datos, como se ilustra en la {numref}`figure-evolucion-manejo-datos-espaciales`. Esta integración permite tratar a los datos espaciales de una manera no muy diferente a otros tipos de datos (*"spatial is not special"*).

```{figure} img/evolucion-manejo-datos-espaciales.png
:name: figure-evolucion-manejo-datos-espaciales

Evolución del manejo de datos espaciales. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

En las primeras implementaciones de sistemas de información geográfica, todos los datos espaciales y no espaciales se almacenaban en archivos planos y se requería de un software especializado (generalmente propietario) para interpretarlos y manipularlos (ej. [ARC/INFO](https://en.wikipedia.org/wiki/ArcInfo)). Los sistemas espaciales de segunda generación almacenaban algunos datos en bases de datos relacionales (generalmente los atributos no espaciales, como textos y números), también con la ayuda de herramientas propietarias (ej. [ArcSDE](https://en.wikipedia.org/wiki/ArcSDE)), pero aún carecían de la flexibilidad que proporciona una integración directa. Actualmente, las bases de datos integran completamente los datos espaciales con los otros tipos de datos {cite:p}`postgis_psc__osgeo_introduction_nodate`.

Estos avances han sido posibles gracias al desarrollo de estándares como [Simple Features](https://www.ogc.org/standards/sfa) y de bibliotecas como [GDAL](https://gdal.org/), [GEOS](https://trac.osgeo.org/geos) y [PROJ](https://proj.org/) {cite:p}`pebesma_openeo_2016`.

## Tipos de datos espaciales
Una base de datos convencional maneja tipos de datos como números, textos y fechas. Una base de datos espacial añade tipos adicionales (ej. puntos, líneas, polígonos, raster) para representar objetos espaciales. Por ejemplo, el estándar [Simple Features](https://www.ogc.org/standards/sfa) define 17 tipos de geometrías de datos vectoriales, de las cuales siete son las más comúnmente utilizadas y se muestran en la {numref}`figure-tipos-datos-espaciales`.

```{figure} img/tipos-datos-espaciales.png
:name: figure-tipos-datos-espaciales

Tipos de geometrías de datos vectoriales. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

## Índices espaciales
Una base de datos común proporciona índices para permitir un acceso rápido y aleatorio a subconjuntos de datos. La indexación para tipos estándar (números, textos, fechas) generalmente se realiza con índices [B-tree](https://es.wikipedia.org/wiki/%C3%81rbol-B). Un índice B-tree divide los datos de acuerdo con el orden natural de clasificación para colocar los datos en un árbol jerárquico. El orden natural de clasificación de números, textos y fechas es fácil de determinar: cada valor es menor, mayor o igual a cualquier otro valor.

Por ejemplo, supóngase que se desea indexar la siguiente lista de números:

29, 5, 17, 21, 33, 37, 13, 41, 25, 9

Un índice B-tree para esta lista podría ser el siguiente:

```
       21
      /  \
     /    \
    9     33
   / \   /  \
  5  13 25  37
       \  \   \
       17 29  41
```

En este árbol:

- 21 es el nodo raíz.
- Los valores menores que 21 (5, 9, 13, 17) están a la izquierda.
- Los valores mayores que 21 (25, 29, 33, 37, 41) están a la derecha.

Si se desea buscar el número 17, se siguen los siguientes pasos:

1. Se comienza en el nodo raíz, 21.
2. 17 es menor que 21, así que se sigue por la izquierda.
3. Se llega al nodo 9.
4. 17 es mayor que 9, así que se sigue por la derecha.
5. Se llega al nodo 13.
6. 17 es mayor que 13, así que se sigue por la derecha.
7. Se llega al nodo 17. Se ha encontrado el número.

El índice B-tree permite búsquedas, inserciones y eliminaciones rápidas, ya que reduce la cantidad de comparaciones que deben hacerse. En lugar de tener que comparar el número 17 con cada número en la lista, solo fue necesario realizar unas pocas comparaciones para encontrarlo en el árbol.

Sin embargo, debido a que las geometrías pueden superponerse y están dispuestos en un espacio bidimensional (o más), un B-tree no puede ser utilizado para indexarlas eficientemente. Las verdaderas bases de datos espaciales proporcionan un "índice espacial" que, en cambio, responde a la pregunta "¿qué objetos están dentro de este cuadro delimitador (*bounding box*) en particular?".

Un cuadro delimitador es el rectángulo más pequeño, paralelo a los ejes de coordenadas, capaz de contener una geometría, como se ilustra en la {numref}`figure-cuadro-delimitador`.

```{figure} img/cuadro-delimitador.png
:name: figure-cuadro-delimitador

Cuadros delimitadores (*bounding boxes*). Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Los cuadros delimitadores se utilizan en lugar de polígonos más detallados (i.e. con más vértices) porque responder a la pregunta "¿está A dentro de B?" es muy intensivo computacionalmente para polígonos, pero muy rápido en el caso de rectángulos. Incluso los polígonos y líneas más complejos pueden ser representados por un simple cuadro delimitador.

Los índices deben funcionar rápidamente para ser útiles. Así que, en lugar de proporcionar resultados exactos, como lo hacen los B-trees, los índices espaciales proporcionan resultados aproximados. La pregunta "¿qué líneas están dentro de este polígono?" será interpretada por un índice espacial como "¿qué líneas tienen cuadros delimitadores que están contenidos dentro del cuadro delimitador de este polígono?"

Los índices espaciales reales implementados por diversas bases de datos varían ampliamente. Las implementaciones más comunes son el [R-Tree](https://es.wikipedia.org/wiki/%C3%81rbol-R) y [Quadtree](https://es.wikipedia.org/wiki/Quadtree) (ambos utilizados en PostGIS), pero también hay [índices basados en cuadrículas](https://en.wikipedia.org/wiki/Grid_(spatial_index)) e índices [GeoHash](https://en.wikipedia.org/wiki/Geohash) implementados en otras bases de datos espaciales.

El funcionamiento de un índice R-Tree se ejemplifica en la {numref}`figure-r-tree`.

```{figure} img/r-tree.png
:name: figure-r-tree

Índice R-Tree. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Este R-Tree organiza los objetos espaciales de manera que una búsqueda espacial es un recorrido rápido a través del árbol. Para encontrar qué objeto contiene el punto, pueden seguirse los siguientes pasos:

1. Primero se verifica si está en T o U (T).
2. Luego, se verifica si está en N, P o Q (P).
3. Después, se verifica si está en C, D o E (D).

Solo es necesario probar 8 cajas. Un escaneo completo de la tabla requeriría probar las 13 cajas. Mientras más grande es la tabla, más útil es el índice.

## Funciones espaciales
Una base de datos espacial proporciona un conjunto de funciones para analizar componentes geométricos, determinar relaciones espaciales y manipular geometrías.

La mayoría de las funciones espaciales puede clasificarse en una de las siguientes cinco categorías:

1. **Conversión**: Convierten entre geometrías y formatos de datos externos (ej. JSON, XML).
2. **Gestión**: Gestionan información sobre tablas espaciales y administración de la base de datos (ej. privilegios de usuarios).
3. **Recuperación**: Recuperan propiedades y mediciones de una geometría (ej. longitud, área, perímetro).
4. **Comparación**: Comparan dos geometrías con respecto a su relación espacial (ej. intersección, contención, traslape).
5. **Generación**: Generan nuevas geometrías a partir de otras (ej. *buffers*, centroides).

Una lista de funciones espaciales puede encontrarse en el estándar [Simple Feature Access – Part 2: SQL Option](https://www.ogc.org/standard/sfs/).

## Bibliografía
```{bibliography}
:filter: docname in docnames
```
