# PostGIS - Geometrías

## Introducción
Como se ha mencionado en capítulos previos, una base de datos espacial implementa tipos de datos espaciales. PostGIS implementa el tipo de datos `GEOMETRY` para geometrías como puntos, líneas, polígonos y colecciones, además de un conjunto de funciones para accederlas.

## El tipo de datos `GEOMETRY`
PostGIS implementa el modelo de datos del estándar Simple Features mediante la definición del tipo de datos [GEOMETRY](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#PostGIS_Geometry) (y también del tipo de datos [GEOGRAPHY](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#PostGIS_Geography), que se estudiará más adelante), junto con un conjunto de operaciones que manipulan y transforman las geometrías para realizar tareas de análisis espacial.

`GEOMETRY` es un tipo de datos *abstracto*. Esto significa que una columna de tipo `GEOMETRY` toma sus valores de subtipos concretos como `Point` (punto), `LineString` (línea), `LinearRing` (anillo lineal), `Polygon` (polígono), `MultiPoint` (multipunto), `MultiLineString` (multilínea), `MultiPolygon` (multipolígono) y `GeometryCollection` (colección de geometrías). Todas estas geometrías se dibujan en un plano cartesiano de dos dimensiones. El tamaño y la ubicación de las geometrías se especifican por sus coordenadas (vértices). Cada coordenada tiene un valor de ordenada X e Y que determina su ubicación en el plano. Las geometrías se construyen a partir de puntos o segmentos de línea, con los puntos especificados por una sola coordenada, y los segmentos de línea por dos coordenadas.

Cada geometría tiene asociado un [sistema de referencia espacial (SRS)](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#spatial_ref_sys) que indica el sistema de coordenadas en el que está contenida. El SRS de cada geometría se identifica por su SRID (ej. 4326, 5367). El SRS determina las unidades de los ejes X e Y. Así, por ejemplo, el SRS [CR05 / CRTM05 (EPSG:5367)](https://epsg.io/5367) usa metros como unidad de medida, por lo que los cálculos de longitud, área y otros se expresan en metros. En SRS planos, las coordenadas X e Y típicamente representan la coordenada este y la coordenada norte, mientras que en sistemas geodésicos representan la longitud y la latitud. Un SRID con valor 0 representa un plano cartesiano infinito sin unidades asignadas a sus ejes.

La dimensión de la geometría es una propiedad de los tipos de datos geométricos. Los puntos tienen dimensión 0, las líneas tienen dimensión 1, y los polígonos tienen dimensión 2. Las colecciones tienen la dimensión del elemento de dimensión máxima.

Una geometría puede estar vacía, lo que significa que no tiene vértices (en el caso de geometrías atoḿicas como puntos, líneas y polígonos) o elementos (en el caso de colecciones).

Una propiedad importante de una geometría es su extensión espacial (*spatial extent*) o cuadro delimitador (*bounding box*). Este es el rectángulo más pequeño, paralelo a los ejes de coordenadas, capaz de contener una geometría. Es una manera eficiente de representar la extensión de una geometría en el espacio de coordenadas y de verificar si dos geometrías interactúan.

El modelo de datos de Simple Features define [reglas de validez](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#OGC_Validity) para cada tipo de geometría. Estas reglas aseguran que las geometrías representen situaciones realistas. Por ejemplo, es posible especificar un polígono con un agujero ubicado fuera del cuadro delimitador, pero esto no tiene sentido geométricamente y por lo tanto es inválido. PostGIS también permite almacenar y manipular valores de geometría inválidos. Esto permite detectarlos y corregirlos si es necesario, por medio de funciones como [ST_IsValid()](https://postgis.net/docs/manual-3.4/ST_IsValid.html), [ST_IsValidDetail()](https://postgis.net/docs/manual-3.4/ST_IsValidDetail.html) y [ST_MakeValid()](https://postgis.net/docs/manual-3.4/ST_MakeValid.html).

**Ejercicios**  
1. Con los siguientes comandos, cree una tabla PostgreSQL-PostGIS llamada `geometries` con una columna de tipo `GEOMETRY`, en la que se insertan geometrías de diferentes tipos. Ejecute los comandos en alguna de las bases de datos espaciales creadas como parte de los ejercicios.

```sql
-- Creación de la tabla geometries
CREATE TABLE geometries (name VARCHAR, geom GEOMETRY);

-- Inserción de registros con diferentes tipos de geometrías
INSERT INTO geometries VALUES
  ('Point', 'POINT(0 0)'),
  ('Linestring', 'LINESTRING(0 0, 1 1, 2 1, 2 2)'),
  ('Polygon', 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
  ('PolygonWithHole', 'POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))'),
  ('Collection', 'GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');

-- Consulta de la tabla geometries
SELECT name, ST_AsText(geom) FROM geometries;
```

La tabla `geometries` contiene cinco geometrías: un punto, una línea, un polígono, un polígono con un agujero y una colección de geometrías. Estas geometrías están especificadas de acuerdo con la sintaxis [Well Known Text (WKT)](https://es.wikipedia.org/wiki/Well_Known_Text), la cual se describirá con mayor detalle en las secciones siguientes.

## Tablas y vistas de metadatos
De acuerdo con la especificación SF-SQL, PostGIS proporciona, en cada base de datos, varias tablas y vistas con metadatos sobre las columnas de geometrías.

### spatial_ref_sys
`spatial_ref_sys` es una tabla que define los SRS que pueden emplearse en cada base de datos PostGIS. Se describirá con más detalle en los capítulos siguientes.

### geometry_columns
`geometry_columns` es una vista que contiene un registro con información para cada columna de tipo `GEOMETRY` que ha sido definida en la base de datos. Contiene las siguientes columnas:

- `f_table_catalog`, `f_table_schema` y `f_table_name`: proporcionan el nombre completamente calificado de la tabla de objetos espaciales que contiene una geometría. Debido a que PostgreSQL no utiliza catálogos, `f_table_catalog` podría estar vacía.
- `f_geometry_column`: es el nombre de la columna que contiene la geometría. Para tablas con múltiples columnas de geometría, hay un registro para cada una.
- `coord_dimension` y `srid`: definen la dimensión de las coordenadas de la geometría (2, 3 o 4) y el SRID (identificador del sistema de referencia espacial) registrado en la tabla `spatial_ref_sys` respectivamente.
- `type`: especifica el tipo de geometría (`Point`, `LineString`, `Polygon`, `MultiPoint`, etc.).

Las relaciones entre `geometry_columns`, `spatial_ref_sys` y las tablas con objetos espaciales (*feature tables*) se ilustra en la {numref}`figure-tablas-vistas-metadatos`.

```{figure} img/tablas-vistas-metadatos.png
:name: figure-tablas-vistas-metadatos

Tablas y vistas de metadatos de PostGIS. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

## Tipos de geometrías
Como se ha mencionado, el estándar Simple Features define diferentes tipos de geometrías, incluyendo puntos, líneas, polígonos y colecciones. Cada tipo cuenta con varias funciones asociadas.

Existen también algunas funciones que permiten obtener información general sobre geometrías de cualquier tipo:

- [ST_GeometryType(geometry)](http://postgis.net/docs/ST_GeometryType.html) retorna el tipo de la geometría.
- [ST_NDims(geometry)](http://postgis.net/docs/ST_NDims.html) retorna la dimensión de las coordenadas de una geometría (i.e. el número de valores necesarios para definir un punto dentro de esa geometría). Los valores posibles que esta función puede devolver son 2, 3 o 4. En este curso, se trabaja con geometrías de coordenadas bidimensionales: de puntos especificados mediante pares ordenados (x, y).
- [ST_SRID(geometry)](http://postgis.net/docs/ST_SRID.html) retorna el identificador del SRS (SRID) de la geometría.

El siguiente comando SQL utiliza las funciones anteriores para obtener información general sobre las geometrías de la tabla `geometries`.

```sql
-- Información general sobre objetos de la tabla geometries
SELECT name, ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom)
FROM geometries;
```

```
      name       |    st_geometrytype    | st_ndims | st_srid
-----------------+-----------------------+----------+---------
 Point           | ST_Point              |        2 |       0
 Polygon         | ST_Polygon            |        2 |       0
 PolygonWithHole | ST_Polygon            |        2 |       0
 Collection      | ST_GeometryCollection |        2 |       0
 Linestring      | ST_LineString         |        2 |       0
```

**Ejercicios**  
1. Con las mismas funciones del ejemplo anterior, obtenga información general sobre las geometrías de las tablas de `nyc` y `cr`.

Seguidamente, se detallan los diferentes tipos de geometrías y sus funciones asociadas.

### Puntos
Un punto (tipo [Point](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#Point)) es una geometría de dimensión 0 que representa una única posición en el espacio de coordenadas, como se muestra en la {numref}`figure-puntos`.

```{figure} img/puntos.png
:name: figure-puntos

Geometrías de puntos. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Un punto se representa con una sola coordenada. Se utilizan para representar objetos cuando los detalles exactos, como la forma y el tamaño, no son importantes en la escala que se utiliza. Por ejemplo, las ciudades en un mapa del mundo pueden representarse como puntos, mientras que en un mapa a nivel provincial podrían mostrarse como polígonos.

#### Representación
El siguiente comando muestra la representación de una geometría de punto en formato WKT. Note el uso de la función [ST_AsText()](https://postgis.net/docs/ST_AsText.html) para retornar la representación de la geometría en WKT.

```sql
-- Representación de una geometría de punto en formato WKT
SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Point';
```

```
POINT(0 0)
```

Los siguientes comandos muestran la representación de la misma geometría de punto en otros formatos.

```sql
-- Representación de una geometría de punto en el formato Geography Markup Language (GML)
SELECT ST_AsGML(geom)
FROM geometries
WHERE name = 'Point';
```

```
<gml:Point><gml:coordinates>0,0</gml:coordinates></gml:Point>
```

```sql
-- Representación de una geometría de punto en el formato Keyhole Markup Language (KML)
-- (parece requerir que la geometría tenga asignado un SRS)
SELECT ST_AsKML(geom)
FROM felidos
LIMIT 1;
```

```
<Point><coordinates>-83.53046900000354,10.595039999999209</coordinates></Point>
```

```sql
-- Representación de una geometría de punto en formato GeoJSON
SELECT ST_AsGeoJSON(geom)
FROM geometries
WHERE name = 'Point';
```

```
{"type":"Point","coordinates":[0,0]}
```

#### Funciones
Algunas funciones para trabajar con puntos son:

- [ST_X(geometry)](http://postgis.net/docs/ST_X.html): retorna el valor de x.
- [ST_Y(geometry)](http://postgis.net/docs/ST_Y.html): retorna el valor de y.

El siguiente comando SQL utiliza las funciones `ST_X()` y `ST_Y()` para obtener los valores X e Y de los registros de presencia de pumas (*Puma concolor*) en Costa Rica. Se usa también `ST_SRID()` para obtener el SRS de las geometrías.

```sql
-- Valores X e Y de las coordenadas de registros de presencia de pumas
SELECT species, ST_X(geom), ST_Y(geom), ST_SRID(geom)
FROM felidos
WHERE species = 'Puma concolor'
LIMIT 3;
```

```
    species    |       st_x        |        st_y        | st_srid
---------------+-------------------+--------------------+---------
 Puma concolor | 546366.8954828221 | 1047355.3360720141 |    5367
 Puma concolor | 558564.0013380446 | 1043114.7064673168 |    5367
 Puma concolor |   547229.44391573 |    944398.30493255 |    5367
```

### Líneas
Una línea o "cadena de" (tipo [LineString](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#LineString)) es una geometría de dimensión 1 formada por segmentos continuos, como se muestra en la {numref}`figure-lineas`.

```{figure} img/lineas.png
:name: figure-lineas

Geometrías de líneas. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Una línea válida, según Simple Features, tiene cero, dos o más puntos, pero PostGIS también permite líneas de un solo punto. Las líneas pueden cruzarse entre sí (auto-intersectarse). Una línea es cerrada si los puntos inicial y final son los mismos. Una línea es simple si no se auto-intersecta. Objetos como carreteras y ríos suelen representarse como líneas.

#### Representación
El siguiente comando muestra la representación de una geometría de línea en formato WKT.

```sql
-- Representación de una geometría de línea en formato WKT
SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Linestring';
```

```
LINESTRING(0 0,1 1,2 1,2 2)
```

#### Funciones
Algunas funciones para trabajar con líneas son:

- [ST_Length(geometry)](http://postgis.net/docs/ST_Length.html): retorna la longitud de la línea.
- [ST_StartPoint(geometry)](http://postgis.net/docs/ST_StartPoint.html): retorna el punto inicial de la línea, como un objeto tipo `POINT`.
- [ST_EndPoint(geometry)](http://postgis.net/docs/ST_EndPoint.html): retorna el punto final de la línea, como un objeto tipo `POINT`.
- [ST_NPoints(geometry)](http://postgis.net/docs/ST_NPoints.html): retorna el número de puntos que componen la línea.

El siguiente comando SQL utiliza las funciones anteriores para mostrar información sobre las líneas que componen la ruta 27 de la red vial de Costa Rica.

```sql
-- Información sobre las líneas de la ruta 27 de Costa Rica
SELECT 
  num_ruta,
  nombre,
  ROUND(ST_Length(geom)::numeric / 1000, 2) AS longitud_km, 
  ST_NPoints(geom) AS numero_puntos
FROM red_vial
WHERE num_ruta = '27';
```

```
 num_ruta |               nombre               | longitud_km | numero_puntos
----------+------------------------------------+-------------+---------------
 27       | AUTOPISTA JOS╔ MAR═A CASTRO MADRIZ |       61.97 |           458
 27       | AUTOPISTA PROSPERO FERN┴NDEZ       |       14.59 |            93
```

### Polígonos
Una polígono (tipo [Polygon](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#Polygon)) es una región plana de dimensión 2 delimitada por un contorno exterior (la envoltura o *shell*) y cero o más contornos interiores (agujeros o *holes*). Cada contorno es un anillo lineal ([LinearRing](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#LinearRing)), como se muestra en la {numref}`figure-poligonos`.

```{figure} img/poligonos.png
:name: figure-poligonos

Geometrías de polígonos. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Los polígonos se utilizan para representar objetos cuyo tamaño y forma son importantes. Los límites de una ciudad, parques, planos de edificios o cuerpos de agua son comúnmente representados como polígonos cuando la escala es suficientemente detallada para ver su área. Las carreteras y ríos a veces pueden ser representados como polígonos.

#### Representación
La siguiente consulta SQL retorna las geometrías asociadas a polígonos en la tabla `geometries` en formato WKT.

```sql
-- Geometrías de polígonos en formato WKT
SELECT name, ST_AsText(geom)
FROM geometries
WHERE name LIKE 'Polygon%';
```

```
 Polygon         | POLYGON((0 0,1 0,1 1,0 1,0 0))
 PolygonWithHole | POLYGON((0 0,10 0,10 10,0 10,0 0),(1 1,1 2,2 2,2 1,1 1))
```

#### Funciones
Algunas funciones para trabajar con polígonos son:

- [ST_Area(geometry)](http://postgis.net/docs/ST_Area.html): retorna el área de un polígono.
- [ST_NRings(geometry)](http://postgis.net/docs/ST_NRings.html): retorna el número de anillos de un polígono.
- [ST_ExteriorRing(geometry)](http://postgis.net/docs/ST_ExteriorRing.html): retorna el anillo exterior de un polígono como un objeto `LINESTRING`.
- [ST_InteriorRingN(geometry,n)](http://postgis.net/docs/ST_InteriorRingN.html): retorna un anillo interior de un polígono, especificado por `n`, como un objeto `LINESTRING`.
- [ST_Perimeter(geometry)](http://postgis.net/docs/ST_Perimeter.html): retorna la longitud de todos los anillos.

```sql
-- Área y perímetro de las provincias de Costa Rica
SELECT 
  provincia, 
  ROUND(ST_Area(geom)::numeric / 1000000, 2) AS area_km2, 
  ROUND(ST_Perimeter(geom)::numeric / 1000, 2) AS perimetro_km
FROM provincias;
```

```
 provincia  | area_km2 | perimetro_km
------------+----------+--------------
 Alajuela   |  9772.06 |       632.23
 Cartago    |  3093.23 |       338.76
 Guanacaste | 10196.32 |       998.34
 Heredia    |  2663.29 |       311.63
 Lim≤n      |  9176.89 |       782.94
 Puntarenas | 11298.51 |      2164.89
 San JosΘ   |  4969.73 |       661.98
 ```

### Colecciones
Hay cuatro tipos de colecciones, los cuales agrupan geometrías en conjuntos.

- Multipunto (tipo [MultiPoint](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#MultiPoint)): colección de puntos.
- Multilínea (tipo [MultiLineString](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#MultiLineString)): colección de líneas.
- Multipolígono (tipo [MultiPolygon](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#MultiPolygon)): colección de polígonos.
- Colección de geometrías (tipo [GeometryCollection](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#GeometryCollection)): colección heterogénea de cualquier tipo de geometrías (incluyendo otras colecciones).

#### Representación
La siguiente consulta SQL retorna las geometrías asociadas a una colección, en formato WKT.

```sql
-- Colección de geometrías en formato WKT
SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Collection';
```

```
GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))
```

#### Funciones
Algunas funciones para trabajar con colecciones son:

- [ST_NumGeometries(geometry)](http://postgis.net/docs/ST_NumGeometries.html): retorna el número de partes de una colección.
- [ST_GeometryN(geometry,n)](http://postgis.net/docs/ST_GeometryN.html): retorna una parte de una colección.
- [ST_Area(geometry)](http://postgis.net/docs/ST_Area.html): retorna el área total de todas las partes que son polígonos.
- [ST_Length(geometry)](http://postgis.net/docs/ST_Length.html): retorna la longitud total de todas las partes que son líneas.

## Representación de geometrías
Las geometrías pueden representarse en diferentes formatos, como el WKT que se ha usado en varios de los ejemplos de este capítulo. PostGIS da soporte a varios de estos formatos y proporciona funciones para importar y exportar geometrías desde y hacia estos.

### Formatos y funciones de conversión

#### Well Known Text (WKT)
[Well Known Text (WKT)](https://es.wikipedia.org/wiki/Well_Known_Text) es una sintaxis basada en texto, legible para humanos (*human-readable*), diseñada para la representación de geometrías vectoriales. Tiene la ventaja de ser muy sencilla, por lo que su uso es muy generalizado. Básicamente, consta de una lista de los vértices que componen las geometrías, separados por comas. Su especificación está incluída en el estándar Simple Features.

Ejemplos de geometrías representadas mediante WKT:

```
POINT (30 10) 
LINESTRING (30 10, 10 30, 40 40) 
POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10)) 

MULTIPOINT (10 40, 40 30, 20 20, 30 10) 
MULTILINESTRING ((10 10, 20 20, 10 40), (40 40, 30 30, 40 20, 30 10))
MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))
GEOMETRYCOLLECTION (POINT (40 10), LINESTRING (10 10, 20 20, 10 40), POLYGON ((40 40, 20 45, 45 30, 40 40)))
```

Extended Well Known Text (EWKT) es una sintaxis extendida de WKT que incluye el SRID de la geometría. Por ejemplo:

```
SRID=4326;POINT(-44.3 60.1)
```

PostGIS proporciona las siguientes funciones para importar y exportar geometrías en WKT y EWKT:

- [ST_GeomFromText(wkt, srid)](https://postgis.net/docs/ST_GeomFromText.html): retorna `GEOMETRY`.
- [ST_AsText(geometry)](https://postgis.net/docs/ST_AsText.html): retorna WKT.
- [ST_AsEWKT(geometry)](https://postgis.net/docs/ST_AsEWKT.html): retorna EWKT.

### Conversión de texto a geometrías
Las hileras WKT que se han utilizado en este capítulo para representar geometrías son de tipo `text` y se han convertido al tipo `GEOMETRY` mediante funciones como `ST_GeomFromText()`.

PostgreSQL incluye el operador `::` (*casting*) para convertir entre tipos de datos, el cual utiliza la sintaxis `tipo_actual::tipo_nuevo`. Por ejemplo, el siguiente comando SQL convierte un valor de tipo `double` al tipo de datos `text`.

```sql
-- Conversión de double a text
SELECT 0.9::text;
```

```
0.9
```

El siguiente comando convierte una hilera WKT en una geometría.

```sql
-- Conversión de WKT a GEOMETRY
SELECT 'POINT(0 0)'::GEOMETRY;
```

```
010100000000000000000000000000000000000000
```

El comando anterior no especifica un SRID (identificador de SRS), por lo que la geometría resultante tiene un SRS desconocido. Para especificar el SRID, puede utilizarse la notación "extendida" de WKT.

```sql
-- Conversión de WKT a GEOMETRY, con especificación de SRID
SELECT 'SRID=4326;POINT(0 0)'::geometry;
```

```
0101000020E610000000000000000000000000000000000000
```

El uso de esta notación de *casting* es muy usual cuando se trabaja con geometrías en PostGIS.

## Ejercicios  
1. Entre los aeródromos de Costa Rica, encuentre:
    - El que está ubicado más al norte.
    - El que está ubicado más al sur.
    - El que está ubicado más al este.
    - El que está ubicado más al oeste.
2. Calcule la longitud total de la red vial de Costa Rica.
3. Calcule la suma de la longitud de la red_vial de Costa Rica, agrupada por la columna `categoria`.
4. Calcule el área de cada una de las provincias de Costa Rica mediante `ST_Area()` y compárela con el valor de la columna `Área`.
5. Calcula la suma de las áreas de las provincias de Costa Rica y compárela con la suma de la columna `Área`.