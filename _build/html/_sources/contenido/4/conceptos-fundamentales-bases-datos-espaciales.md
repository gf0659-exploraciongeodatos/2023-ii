# Conceptos fundamentales de bases de datos espaciales

## Introducción
Una base de datos espacial (también llamada base de datos geográfica) agrega a una base de datos de propósito general componentes para el manejo de datos espaciales, tales como tipos de datos espaciales, índices espaciales y funciones espaciales.

La integración de datos espaciales en los motores de bases de datos ha sido posible gracias al desarrollo de bibliotecas de software y estándares abiertos.

## Evolución del manejo de datos espaciales
El manejo de datos espaciales ha evolucionado desde soluciones propietarias hasta geometrías integradas en la estructura de las bases de datos, como se ilustra en la {numref}`figure-evolucion-manejo-datos-espaciales`. Esta integración permite tratar a los datos espaciales de una manera no muy diferente a otros tipos de datos (*"spatial is not special"*).

```{figure} img/evolucion-manejo-datos-espaciales.png
:name: figure-evolucion-manejo-datos-espaciales

Evolución del manejo de datos espaciales. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

En las primeras implementaciones de sistemas de información geográfica (SIG), todos los datos espaciales y no espaciales se almacenaban en archivos planos y se requería de un software especializado (generalmente propietario) para interpretarlos y manipularlos (ej. [ARC/INFO](https://en.wikipedia.org/wiki/ArcInfo)). Los sistemas espaciales de segunda generación almacenaban algunos datos (generalmente los atributos no espaciales, como textos y números) en bases de datos relacionales, también con la ayuda de herramientas propietarias (ej. [ArcSDE](https://en.wikipedia.org/wiki/ArcSDE)), pero aún carecían de la flexibilidad que proporciona una integración directa. Actualmente, las bases de datos integran completamente los datos espaciales con los otros tipos de datos {cite:p}`postgis_psc__osgeo_introduction_nodate`. De esta manera, los principales motores de bases de datos (ej. Oracle, PostgreSQL, MySQL) incluyen extensiones para manejar datos espaciales.

## Estándares y herramientas
Los avances mencionados han sido posibles gracias al desarrollo de diversos estándares y herramientas, como los que describen en las secciones siguientes.

### Simple Feature Access
[Simple Feature Access](https://www.ogc.org/standards/sfa), llamado también "*Simple Features*", es un conjunto de estándares que especifican un modelo común de almacenamiento y acceso de objetos espaciales, principalmente de geometrías de dos dimensiones (ej. puntos, líneas, polígonos, multipuntos, multilineas, multipolígonos) utilizadas por bases de datos espaciales y SIG. Está formalizado tanto por el [Open Geospatial Consortium (OGC)](https://www.ogc.org/) como por la [Organización Internacional para la Estandarización (ISO)](https://www.iso.org/).

La norma ISO 19125 consta de dos partes: 

- [Simple Feature Access – Part 1: Common Architecture (SFA-CA)](https://www.ogc.org/standard/sfa/) define un modelo para objetos bidimensionales, con interpolación lineal entre vértices, definido en una jerarquía de clases. Esta parte también define la representación de geometrías en formatos binarios y de texto. 
- [Simple Feature Access – Part 2: SQL Option (SFA-SQL)](https://www.ogc.org/standard/sfs/) define una interfaz de programación de aplicaciones (API) para el lenguaje SQL.

### GDAL
[Geospatial Data Abstraction Library (GDAL)](https://gdal.org/) (también conocida como GDAL/OGR) es una biblioteca de software para la lectura, escritura y traducción de formatos de datos espaciales, tanto vectoriales como raster. Es un proyecto de la [Open Source Geospatial Foundation (OSGeo)](http://www.osgeo.org/).

### GEOS
La biblioteca [Geometry Engine - Open Source (GEOS)](https://libgeos.org/) implementa el modelo de geometrías y las funciones espaciales especificadas en Simple Features. Es un proyecto de OSGeo.

### PROJ
La biblioteca [PROJ](https://proj.org/) realiza transformaciones entre [sistemas de referencia espaciales (SRS)](https://en.wikipedia.org/wiki/Spatial_reference_system). También es un proyecto de OSGeo.

## Tipos de datos espaciales
Una base de datos convencional maneja tipos de datos como números, textos y fechas. Una base de datos espacial añade tipos para representar objetos espaciales (ej. puntos, líneas, polígonos, raster). El estándar SFA-CA define 17 tipos de geometrías de datos vectoriales, de las cuales siete son las más comúnmente utilizadas y se muestran en la {numref}`figure-tipos-datos-espaciales`.

```{figure} img/tipos-datos-espaciales.png
:name: figure-tipos-datos-espaciales

Tipos de geometrías de datos vectoriales. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

## Índices espaciales
Una base de datos proporciona [índices](https://es.wikipedia.org/wiki/%C3%8Dndice_(base_de_datos)) para permitir un acceso rápido y aleatorio a subconjuntos de datos. 

La indexación para tipos de datos convencionales (números, textos, fechas) generalmente se realiza con índices [B-tree](https://es.wikipedia.org/wiki/%C3%81rbol-B). Un índice B-tree divide los datos de acuerdo con su orden natural, para colocarlos en un árbol jerárquico. El orden natural de números, textos y fechas es fácil de determinar: cada valor es menor, mayor o igual a cualquier otro valor.

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

Si se desea buscar, por ejemplo, el número 17, se siguen los siguientes pasos:

1. Se comienza en el nodo raíz, 21.
2. 17 es menor que 21, así que se sigue por la izquierda.
3. Se llega al nodo 9.
4. 17 es mayor que 9, así que se sigue por la derecha.
5. Se llega al nodo 13.
6. 17 es mayor que 13, así que se sigue por la derecha.
7. Se llega al nodo 17. Se ha encontrado el número.

El índice B-tree permite búsquedas, inserciones y eliminaciones rápidas, ya que reduce la cantidad de comparaciones que deben hacerse. En lugar de tener que comparar el número 17 con cada número en la lista, solo fue necesario realizar unas pocas comparaciones para encontrarlo en el árbol.

Sin embargo, debido a que las geometrías pueden superponerse y están dispuestos en un espacio bidimensional (o de más dimensiones), un B-tree no puede ser utilizado para indexarlas eficientemente. Las verdaderas bases de datos espaciales proporcionan un índice espacial que responde a la pregunta "¿qué objetos están dentro de este cuadro delimitador (*bounding box*) en particular?".

Un cuadro delimitador es el rectángulo más pequeño, paralelo a los ejes de coordenadas, capaz de contener una geometría, como se ilustra en la {numref}`figure-cuadro-delimitador`.

```{figure} img/cuadro-delimitador.png
:name: figure-cuadro-delimitador

Cuadros delimitadores (*bounding boxes*). Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Los cuadros delimitadores se utilizan en lugar de polígonos más detallados (i.e. con más vértices) porque responder a la pregunta "¿está A dentro de B?" es muy intensivo computacionalmente para polígonos con muchos vértices, pero muy rápido en el caso de rectángulos. Incluso los polígonos y líneas más complejos pueden ser representados por un simple cuadro delimitador.

Los índices deben funcionar rápidamente para ser útiles. Así que, en lugar de proporcionar resultados exactos, como lo hacen los B-trees, los índices espaciales proporcionan resultados aproximados. La pregunta "¿qué líneas están dentro de este polígono?" será interpretada por un índice espacial como "¿qué líneas tienen cuadros delimitadores que están contenidos dentro del cuadro delimitador de este polígono?"

Los tipos de índices espaciales varían ampliamente entre las bases de datos. Las implementaciones más comunes son el [R-tree](https://es.wikipedia.org/wiki/%C3%81rbol-R) y el [Quadtree](https://es.wikipedia.org/wiki/Quadtree), pero también hay [índices basados en cuadrículas](https://en.wikipedia.org/wiki/Grid_(spatial_index)) e índices [GeoHash](https://en.wikipedia.org/wiki/Geohash) implementados en otras bases de datos espaciales.

El funcionamiento de un índice R-tree se ejemplifica en la {numref}`figure-r-tree`.

```{figure} img/r-tree.png
:name: figure-r-tree

Índice R-tree. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Este R-tree organiza los objetos espaciales de manera que una búsqueda espacial es un recorrido rápido a través del árbol. Para encontrar cuál objeto contiene el punto, pueden seguirse los siguientes pasos:

1. Primero se verifica si está en T o U (está en T).
2. Luego, se verifica si está en N, P o Q (está en P).
3. Después, se verifica si está en C, D o E (está en D).

Solo es necesario probar 8 cajas. Un escaneo completo de la tabla requeriría probar las 13 cajas. Mientras más grande es la tabla, más útil es el índice.

## Funciones espaciales
Una base de datos espacial proporciona un conjunto de funciones para analizar componentes geométricos, determinar relaciones espaciales y manipular geometrías.

La mayoría de las funciones espaciales puede clasificarse en una de las siguientes cinco categorías:

1. **Conversión**: Realizan conversiones entre formatos de representación de geometrías (ej. JSON, XML).
2. **Gestión**: Gestionan información sobre tablas espaciales y administración de la base de datos (ej. asignación de privilegios a usuarios).
3. **Recuperación**: Recuperan propiedades y mediciones de una geometría (ej. longitud, área, perímetro).
4. **Comparación**: Comparan dos geometrías con respecto a una relación espacial (ej. intersección, contención, traslape).
5. **Generación**: Generan nuevas geometrías a partir de otras (ej. *buffers*, centroides).

Una lista de funciones espaciales puede encontrarse en el estándar [SFA-SQL](https://www.ogc.org/standard/sfs/).

## Bibliografía
```{bibliography}
:filter: docname in docnames
```