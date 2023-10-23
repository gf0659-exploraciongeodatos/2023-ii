# Geometrías

## Introducción
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

## Tablas y vistas de metadatos
De acuerdo con la especificación SFSQL, PostGIS proporciona, en cada base de datos, varias tablas y vistas con metadatos sobre las columnas de geometrías:

- `spatial_ref_sys` es una tabla que define los [sistemas de referencia espaciales (SRS)](https://en.wikipedia.org/wiki/Spatial_reference_system) (también llamados sistemas de referencia de coordenadas o CRS) que pueden emplearse en cada base de datos PostGIS.
- `geometry_columns` es una vista que contiene un registro por cada columna de tipo `GEOMETRY` que ha sido definida en la base de datos.

## Tipos de geometrías
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

### Puntos
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

### Líneas
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

### Polígonos
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

### Colecciones
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