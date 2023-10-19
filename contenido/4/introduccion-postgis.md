# Introducción a PostGIS

## Introducción
[PostGIS](https://postgis.net/) es una extensión de [PostgreSQL](https://www.postgresql.org/) que incorpora funcionalidad espacial a este SABD al agregar soporte para tipos de datos espaciales, índices espaciales y funciones espaciales. Al estar construido sobre PostgreSQL, PostGIS hereda automáticamente todas sus ventajas como SABD organizacional, así como estándares abiertos para su implementación. Tanto PostgreSQL como PostGIS son proyectos de software de código abierto.

[Refractions Research](http://www.refractions.net/) lanzó la primera versión de PostGIS en 2001, la cual contaba con objetos, índices y unas cuantas funciones. A través de los años, el proyecto se enriqueció con la implementación de la especificación [Simple Features for SQL (SFSQL)](https://postgis.net/workshops/postgis-intro/glossary.html#term-SFSQL) del [Open Geospatial Consortium (OGC)](https://www.ogc.org/), la cual define cómo soportar consultas espaciales en bases de datos relacionales, y con el aporte de otros proyectos de desarrollo de software apoyados por [OSGeo](https://www.osgeo.org/), como la biblioteca ["Geometry Engine, Open Source" (GEOS)](http://trac.osgeo.org/geos), la cual proporciona el código fuente necesario para implementar los algoritmos de SFSQL (ej. `ST_Intersects()`, `ST_Buffer()`, `ST_Union()`) y muchos otros.

## Instalación
Las instrucciones detalladas para la instalación de PostGIS, en diferentes sistemas operativos, pueden encontrarse en [Introduction to PostGIS - Installation](https://postgis.net/workshops/postgis-intro/installation.html).

## Creación de bases de datos
PostgreSQL cuenta con varias interfaces administrativas. La principal es [psql](http://www.postgresql.org/docs/current/static/app-psql.html), una herramienta de línea de comandos para ingresar consultas SQL. Otra interfaz popular de PostgreSQL es la herramienta gráfica gratuita y de código abierto [pgAdmin](http://www.pgadmin.org/). Todas las consultas realizadas en pgAdmin también se pueden hacer en la línea de comandos con psql. pgAdmin también incluye un visor de geometrías que puedes usar para visualizar espacialmente las consultas de PostGIS.

En el caso de pgAdmin, una base de datos espacial puede crearse igual que cualquier otra base de datos, con la opción de menú **Databases - New Database** y ejecutando además el comando:

```sql
-- Creación de la extensión PostGIS
CREATE EXTENSION postgis;
```

Este comando crea la extensión espacial PostGIS para una base de datos.

Para confirmar que PostGIS está correctamente instalada, puede ejecutarse una de sus funciones. Por ejemplo:

```sql
-- Consulta de la versión de PostGIS instalada
SELECT postgis_full_version();
```

## Carga de datos
Existen varias opciones para cargar datos espaciales en PostgreSQL-PostGIS. En las secciones siguientes se describen algunas.

### Desde un archivo de respaldo
Este método permite restaurar una base de datos a partir de su respaldo en un archivo (ej. `.backup`). En pgAdmin, está disponible en la opción **Restore...** del menú que se despliega al hacer clic derecho en el ícono de una base de datos.

### Con la herramienta ogr2ogr
[ogr2ogr](https://gdal.org/programs/ogr2ogr.html) es un programa que forma parte de la biblioteca [Geospatial Data Abstraction Library (GDAL)](https://gdal.org/), la cual se enfoca en la conversión entre formatos vectoriales y raster. `ogr2ogr` realiza conversiones entre formatos vectoriales (ej. SHP, GPKG, GML, KML) y se ejecuta desde la línea de comandos del sistema operativo.

Para acceder una base de datos PostgreSQL-PostGIS, `ogr2ogr` requiere el nombre de la base de datos (`dbname`), la computadora en la que está alojada (`host`), un usuario con los derechos necesarios para cargar los datos (`user`) y su clave. Para no especificar la clave en el comando (lo que sería muy inseguro), se recomienda especificarla en una variable del sistema operativo.

```shell
# Especificación de la clave de PostgreSQL como variable del sistema operativo
# mi_clave_de_postgresql debe sustituirse por la clave verdadera
set PGPASSWORD=mi_clave_de_postgresql
```

Por ejemplo, el siguiente comando carga una capa de provincias de Costa Rica alojada en un servicio WFS del Instituto Geográfico Nacional (IGN) en una tabla de una base de datos PostgreSQL-PostGIS.

```shell
# Carga de una capa alojada en un servicio WFS en una base de datos PostgreSQL-PostGIS
ogr2ogr ^
  -makevalid ^
  -nln provincias ^
  -nlt PROMOTE_TO_MULTI ^
  -lco GEOMETRY_NAME=geom ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  WFS:"https://geos.snitcr.go.cr/be/IGN_5_CO/wfs" "IGN_5_CO:limiteprovincial_5k"
```

El siguiente comando carga un archivo CSV, con registros de presencia de félidos de Costa Rica obtenidos a través de una [consulta al portal de la Infraestructura Mundial de Información en Biodiversidad (GBIF)](https://doi.org/10.15468/dl.cz6t5n), en una tabla de una base de datos PostgreSQL-PostGIS. El archivo CSV también puede descargarse de [https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/gbif/felidos.csv](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/gbif/felidos.csv). El resultado es una capa con geometrías de puntos, cuyas coordenadas provienen de las columnas `decimalLongitude` y `decimalLatitude`. Note el uso de las opciones `-s_srs EPSG:4326` y `-t_srs EPSG:5367` para especificar los sistemas de coordenadas de origen y destino, respectivamente.

```shell
# Carga de una capa contenida en un archivo CSV en una base de datos PostgreSQL-PostGIS
ogr2ogr ^
  -nln felidos ^
  -oo X_POSSIBLE_NAMES=decimalLongitude -oo Y_POSSIBLE_NAMES=decimalLatitude ^
  -lco GEOMETRY_NAME=geom ^
  -s_srs EPSG:4326 ^
  -t_srs EPSG:5367 ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  felidos.csv
```

### Con la herramienta shp2pgsql
La herramienta [shp2pgsql](https://postgis.net/docs/using_postgis_dbmanagement.html#shp2pgsql_usage) permite cargar *shapefiles* como tablas en bases de datos PostgreSQL-PostGIS. Puede utilizarse desde la línea de comandos del sistema operativo o desde una interfaz gráfica.

### Con QGIS
El sistema de información geográfica de escritorio [QGIS](https://www.qgis.org/) incluye varias herramientas para cargar datos en bases de datos PostgreSQL-PostGIS, como la disponible en la opción de menú **Database - DB Manager - Import Layer/File...**., la cual permite cargar capas físicas o virtuales disponibles en el navegador de QGIS.

## Ejercicios
Para cargar los datos requeridos para resolver estos ejercicios, puede consultar [Introduction to PostGIS - Loading spatial data](https://postgis.net/workshops/postgis-intro/loading_data.html).

1. Cree una base de datos PostgreSQL-PostGIS con nombre `nyc`.
2. Cargue en `nyc` el [archivo de respaldo de la base de datos](https://s3.amazonaws.com/s3.cleverelephant.ca/postgis-workshop-2020.zip).
3. En la base de datos `nyc`, examine:
    - Las columnas de geometría de las tablas (ej. `geom`).
    - La tabla `spatial_ref_sys`.
    - Las vistas `geometry_columns` y `geography_columns`.
4. Lea la descripción de los datos de `nyc` en [Introduction to PostGIS - About our data](https://postgis.net/workshops/postgis-intro/about_data.html).
5. En QGIS, cree una conexión a `nyc` y visualice sus tablas.
6. Ejecute las consultas SQL en:
    - [Introduction to PostGIS - Simple SQL](https://postgis.net/workshops/postgis-intro/simple_sql.html)
    - [Introduction to PostGIS - Simple SQL Exercises](https://postgis.net/workshops/postgis-intro/simple_sql_exercises.html)
7. Cargue las siguientes capas del [Sistema Nacional de Información Territorial (SNIT)](https://www.snitcr.go.cr/) como tablas de una nueva base de datos PostgreSQL-PostGIS llamada `cr`:
    - Provincias.
    - Cantones.
    - Distritos.
    - Áreas de conservación.
    - Áreas silvestres protegidas.
    - Red vial 1:200 mil.
    - Hidrografía 1:5 mil.
    - Aeródromos 1: 200 mil.
8. De [https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/gbif/felidos.csv](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/gbif/felidos.csv) descargue el archivo `felidos.csv` y cárguelo como una tabla en la base de datos `cr`.

## Geometrías
Como se mencionó en el capítulo anterior, una base de datos espacial proporciona tipos de datos geométricos para manejar datos espaciales. Con los siguientes comandos, se crea una tabla PostgreSQL-PostGIS, que incluye una columna de tipo `GEOMETRY`, y se insertan geometrías de diferentes clases. Ejecute los comandos en alguna de las bases de datos creadas como parte de los ejercicios.

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

La tabla `geometries` contiene cinco geometrías: un punto, una línea, un polígono, un polígono con un hoyo y una colección.

### Tablas y vistas de metadatos
De acuerdo con la especificación SFSQL, PostGIS proporciona, en cada base de datos, varias tablas y vistas con metadatos sobre las columnas de geometrías:

- `spatial_ref_sys` es una tabla que define los [sistemas de referencia espaciales (SRS)](https://en.wikipedia.org/wiki/Spatial_reference_system) (también llamados sistemas de referencia de coordenadas o CRS) que pueden emplearse en cada base de datos PostGIS.
- `geometry_columns` es una vista que contiene un registro por cada columna de tipo `GEOMETRY` que ha sido definida en la base de datos.

### Tipos de geometrías
La especificación SFSQL define la representación de objetos espaciales de dos dimensiones. Otras especificaciones y aportes de diferentes SABD permiten representar geometrías de más dimensiones.

Existen varias funciones que permiten obtener información general sobre objetos espaciales:

- [ST_GeometryType(geometry)](http://postgis.net/docs/ST_GeometryType.html) retorna el tipo de la geometría.
- [ST_NDims(geometry)](http://postgis.net/docs/ST_NDims.html) retorna la cantidad de dimensiones de la geometría.
- [ST_SRID(geometry)](http://postgis.net/docs/ST_SRID.html) retorna el identificador del SRS de la geometría.

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

**Ejercicio:**  
Con las mismas funciones del ejemplo anterior, obtenga información general sobre las geometrías de las tablas de `nyc` y `cr`.

#### Puntos
Un punto espacial representa una ubicación indivisible. Se representa con una sola coordenada (incluyendo ya sea 2, 3 o 4 dimensiones). Los puntos se utilizan para representar objetos cuando los detalles exactos, como la forma y el tamaño, no son importantes en la escala que se utiliza. Por ejemplo, las ciudades en un mapa del mundo pueden describirse como puntos, mientras que un mapa de una provincia podría representar las ciudades como polígonos.

```sql
-- Representación de una geometría de punto en el formato Well-Known Text (WKT)
SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Point';
```

```
POINT(0 0)
```

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
-- Representación de una geometría de punto en el formato GeoJSON
SELECT ST_AsGeoJSON(geom)
FROM geometries
WHERE name = 'Point';
```

```
{"type":"Point","coordinates":[0,0]}
```

Algunas funciones para trabajar con puntos son:

- [ST_X(geometry)](http://postgis.net/docs/ST_X.html): retorna el valor de x.
- [ST_Y(geometry)](http://postgis.net/docs/ST_Y.html): retorna el valor de y.

```sql
-- Valores x e y de las coordenadas de los registros de presencia de pumas
SELECT species, ST_X(geom), ST_Y(geom), ST_SRID(geom)
FROM felidos
WHERE species = 'Puma concolor';
```

#### Líneas
Una línea (*linestring*) es un trayecto entre ubicaciones. Toma la forma de una serie ordenada de dos o más puntos. Objetos como carreteras y ríos suelen representarse como líneas. Se dice que una línea es **cerrada** si comienza y termina en el mismo punto. Se dice que es **simple** si no se cruza ni se toca a sí misma (excepto en sus extremos, si está cerrada). Una misma línea puede ser cerrada y simple.

Algunas funciones para trabajar con líneas son:

- [ST_Length(geometry)](http://postgis.net/docs/ST_Length.html): retorna la longitud de la línea.
- [ST_StartPoint(geometry)](http://postgis.net/docs/ST_StartPoint.html): retorna el punto inicial de la línea, como un objeto tipo `POINT`.
- [ST_EndPoint(geometry)](http://postgis.net/docs/ST_EndPoint.html): retorna el punto final de la línea, como un objeto tipo `POINT`.
- [ST_NPoints(geometry)](http://postgis.net/docs/ST_NPoints.html): retorna el número de puntos que componen la línea.

```sql
-- Información sobre una línea
SELECT 
  ST_Length(geom), 
  ST_AsText(ST_StartPoint(geom)), 
  ST_AsText(ST_EndPoint(geom)), 
  ST_NPoints(geom)
FROM geometries
WHERE name = 'Linestring';
```

#### Polígonos
Un polígono es una representación de un área. El límite exterior del polígono está representado por un **anillo**. Este anillo es una línea que es tanto cerrada como simple, según se definió anteriormente. Los huecos dentro del polígono también están representados por anillos.

Los polígonos se utilizan para representar objetos cuyo tamaño y forma son importantes. Los límites de una ciudad, parques, planos de edificios o cuerpos de agua son comúnmente representados como polígonos cuando la escala es suficientemente detallada para ver su área. Las carreteras y ríos a veces pueden ser representados como polígonos.

La siguiente consulta SQL retorna las geometrías asociadas a polígonos en la tabla `geometries`.

```sql
-- Geometrías de polígonos
SELECT ST_AsText(geom)
FROM geometries
WHERE name LIKE 'Polygon%';
```

Algunas funciones para trabajar con polígonos son:

- [ST_Area(geometry)](http://postgis.net/docs/ST_Area.html): retorna el área de un polígono.
- [ST_NRings(geometry)](http://postgis.net/docs/ST_NRings.html): retorna el número de anillos de un polígono.
- [ST_ExteriorRing(geometry)](http://postgis.net/docs/ST_ExteriorRing.html): retorna el anillo exterior de un polígono como un objeto `LINESTRING`.
- [ST_InteriorRingN(geometry,n)](http://postgis.net/docs/ST_InteriorRingN.html): retorna un anillo interior de un polígono, especificado por `n`, como un objeto `LINESTRING`.
- [ST_Perimeter(geometry)](http://postgis.net/docs/ST_Perimeter.html): retorna la longitud de todos los anillos.

```sql
-- Área y perímetro de la provincia de San José
SELECT 
  provincia, 
  ROUND(ST_Area(geom)::numeric, 2) / 10^6 AS area_km2, 
  ROUND(ST_Perimeter(geom)::numeric, 2) / 10^3 AS perimetro_km
FROM provincias
WHERE provincia = 'San José';
```

**Ejercicios:**  
- Calcule el área de todas las provincias mediante `ST_Area()` y compárela con el valor de la columna `Área`.
- Calcula la suma de las áreas de las provincias y compárela con la suma de la columna `Área`.

#### Colecciones
Hay cuatro tipos de colecciones, los cuales agrupan geometrías en conjuntos.

- `MultiPoint`: colección de puntos.
- `MultiLineString`: colección de líneas.
- `MultiPolygon`: colección de polígonos.
- `GeometryCollection`: colección heterogénea de cualquier tipo de geometrías (incluyendo otras colecciones).

La siguiente consulta SQL retorna las geometrías asociadas a una colección.

```sql
-- Geometrías de colecciones
SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Collection';
```

```
GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))
```

Algunas funciones para trabajar con colecciones son:

- [ST_NumGeometries(geometry)](http://postgis.net/docs/ST_NumGeometries.html): retorna el número de partes de una colección.
- [ST_GeometryN(geometry,n)](http://postgis.net/docs/ST_GeometryN.html): retorna una parte de una colección.
- [ST_Area(geometry)](http://postgis.net/docs/ST_Area.html): retorna el área total de todas las partes que son polígonos.
- [ST_Length(geometry)](http://postgis.net/docs/ST_Length.html): retorna la longitud total de todas las partes que son líneas.

## Relaciones espaciales
Las relaciones entre objetos espaciales, también llamadas relaciones topológicas o relaciones topológicas binarias, son expresiones lógicas (verdaderas o falsas) sobre las relaciones espaciales entre dos objetos. Por ejemplo, si `a` y `b` son dos objetos espaciales (ej. puntos, líneas, polígonos), se pueden considerar relaciones topológicas como las siguientes:

- `a` interseca a `b`
- `a` es adyacente a `b`
- `a` está dentro de `b`
- `b` está contenido en `a`

Las relaciones topológicas están estandarizadas en el modelo [Dimensionally Extended 9-Intersection Model (DE-9IM)](https://en.wikipedia.org/wiki/DE-9IM).

La especificación SFSQL define varias funciones para relaciones espaciales, las cuales se explican en las secciones subsiguientes.

### `ST_Equals()`
[ST_Equals(geometry A, geometry B) ](http://postgis.net/docs/ST_Equals.html) retorna `TRUE` si `geometry A` y `geometry B` son espacialmente iguales.

```sql
-- Selección de una geometría
SELECT name, geom
FROM nyc_subway_stations
WHERE name = 'Broad St';
```

```
   name   |                      geom
----------+---------------------------------------------------
 Broad St | 0101000020266900000EEBD4CF27CF2141BC17D69516315141
```

```sql
-- Evaluación de la igualdad de las geometrías
SELECT name
FROM nyc_subway_stations
WHERE ST_Equals(
  geom,
  '0101000020266900000EEBD4CF27CF2141BC17D69516315141');
```

```
Broad St
```

### `ST_Intersects()`
[ST_Intersects(geometry A, geometry B)](http://postgis.net/docs/ST_Intersects.html) retorna `TRUE` si `geometry A` y `geometry B` comparten espacio en sus bordes o en sus interiores.

### `ST_Disjoint()`

### `ST_Crosses()`

### `ST_Overlaps()`
