# PostGIS - Raster

## Introducción
El modelo raster, de datos espaciales, representa información en forma de matrices compuestas por celdas (también llamadas pixeles) en donde cada una contiene un valor sobre una ubicación. Un conjunto de datos raster (ej. una imagen satelital) puede estar compuesto por varias bandas, cada una de las cuales tiene una matriz.

El modelo raster es comúnmente utilizado en teledetección y análisis de imágenes para modelar fenómenos continuos como altitud, vegetación, temperatura o densidad de población, entre otros.

PostgreSQL maneja datos raster mediante una extensión llamada [postgis_raster](https://postgis.net/docs/RT_reference.html).

## Instalación de postgis_raster
Para trabajar con datos raster en una base de datos PostgreSQL, se deben instalar tanto la extensión postgis como la extensión postgis_raster.

Las siguientes setencias crean ambas extensiones en una base de datos (vea el ejercicio 1).

```sql
-- Instalación de las extensiones postgis y postgis_raster
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;
```

## Carga de datos
El programa [raster2pgsql](https://postgis.net/docs/using_raster_dataman.html#RT_Raster_Loader) es un utilitario de línea de comandos del sistema operativo, el cual usualmente se instala junto con PostGIS. Permite cargar fuentes de datos raster soportadas por la biblioteca [GDAL](https://gdal.org/) en tablas de PostgreSQL/PostGIS. En el caso de Windows, StackBuilder instala raster2pgsql en el directorio ` C:\Program Files\PostgreSQL\15\bin` (15 debe sustituirse por la versión de PostgreSQL que se esté utilizando).

Por ejemplo, el siguiente comando carga el archivo [wc2.1_2.5m_tmax_2021-10.tif](https://geodata.ucdavis.edu/climate/worldclim/2_1/hist/cts4.06/2.5m/wc2.1_cruts4.06_2.5m_tmax_2020-2021.zip) (temperatura máxima de octubre 2021 en resolución de 2.5 minutos o 150 segundos) en la tabla `tmax_202110_150s` de una base de datos llamada `worldclim` (vea el ejercicio 2).

```
raster2pgsql -e -l 2,3 -I -C -M -Y -t auto wc2.1_2.5m_tmax_2021-10.tif tmax_202110_150s | psql -d worldclim -U postgres
```

Las diferentes opciones del comando se explican en [raster2pgsql options](https://postgis.net/docs/using_raster_dataman.html#idm25305).

## Vistas de metadatos
PostGIS proporciona, en cada base de datos, varias vistas con metadatos sobre las columnas de datos raster.

### raster_columns
[raster_columns](https://postgis.net/docs/using_raster_dataman.html#RT_Raster_Columns) contiene un catálogo de todas las columnas raster de una base de datos.

```sql
-- Consulta del catálogo de columnas raster de una base de datos
SELECT 
  r_table_name, 
  r_raster_column, 
  srid, 
  scale_x, 
  scale_y, 
  num_bands,
  pixel_types,
  nodata_values,
  spatial_index
FROM raster_columns;
```

```
     r_table_name     | r_raster_column | srid |   scale_x    |    scale_y    | num_bands | pixel_types | nodata_values | spatial_index
----------------------+-----------------+------+--------------+---------------+-----------+-------------+---------------+---------------
 elev                 | rast            | 4326 | 0.0083333333 | -0.0083333333 |         1 | {16BSI}     | {-32768}      | t
 o_2_elev             | rast            | 4326 | 0.0166666667 | -0.0166666667 |         1 | {16BSI}     | {-32768}      | t
 o_3_elev             | rast            | 4326 |        0.025 |        -0.025 |         1 | {16BSI}     | {-32768}      | t
 tmax_202110_150s     | rast            | 4326 | 0.0416666667 | -0.0416666667 |         1 | {32BF}      | {NaN}         | t
 o_2_tmax_202110_150s | rast            | 4326 | 0.0833333333 | -0.0833333333 |         1 | {32BF}      | {NaN}         | t
 o_3_tmax_202110_150s | rast            | 4326 |        0.125 |        -0.125 |         1 | {32BF}      | {NaN}         | t
 tmax_202010_150s     | rast            | 4326 | 0.0416666667 | -0.0416666667 |         1 | {32BF}      | {NaN}         | t
 o_2_tmax_202010_150s | rast            | 4326 | 0.0833333333 | -0.0833333333 |         1 | {32BF}      | {NaN}         | t
 o_3_tmax_202010_150s | rast            | 4326 |        0.125 |        -0.125 |         1 | {32BF}      | {NaN}         | t
```

### raster_overviews
[raster_overviews](https://postgis.net/docs/using_raster_dataman.html#RT_Raster_Overviews) contiene el catálogo de las columnas raster de las tablas que funcionan como vistas generales (*overviews*) de tablas más detalladas. Estas tablas son las que se generan con la opción `-l` de raster2pgsql.

```sql
-- Consulta del catálogo de columnas raster de las vistas generales
SELECT * FROM raster_overviews;
```

```
 o_table_catalog | o_table_schema |     o_table_name     | o_raster_column | r_table_catalog | r_table_schema |   r_table_name   | r_raster_column | overview_factor
-----------------+----------------+----------------------+-----------------+-----------------+----------------+------------------+-----------------+-----------------
 worldclim       | public         | o_2_elev             | rast            | worldclim       | public         | elev             | rast            |               2
 worldclim       | public         | o_3_elev             | rast            | worldclim       | public         | elev             | rast            |               3
 worldclim       | public         | o_2_tmax_202110_150s | rast            | worldclim       | public         | tmax_202110_150s | rast            |               2
 worldclim       | public         | o_3_tmax_202110_150s | rast            | worldclim       | public         | tmax_202110_150s | rast            |               3
 worldclim       | public         | o_2_tmax_202010_150s | rast            | worldclim       | public         | tmax_202010_150s | rast            |               2
 worldclim       | public         | o_3_tmax_202010_150s | rast            | worldclim       | public         | tmax_202010_150s | rast            |               3
```

## Funciones
La extensión postgis_raster contiene más de 100 [funciones para manejo de datos raster](https://postgis.net/docs/RT_reference.html). En esta sección, se ejemplifican algunas de estas.

### `ST_Union()`
La función [ST_Union()](https://postgis.net/docs/RT_ST_Union.html) combina un conjunto de rasters en una estructura. Esta función puede aplicarse a la columna raster de una misma tabla, la cual puede estar dividida en varias filas.

### `ST_Height()`, `ST_Width()`, `ST_SRID()`, `ST_NumBands()`
Retornan información general sobre un raster.

```sql
-- Información general sobre un raster
SELECT
  ST_Height(ST_Union(rast)), -- altura
  ST_Width(ST_Union(rast)), -- ancho
  ST_SRID(ST_Union(rast)), -- SRID
  ST_NumBands(ST_Union(rast)) -- Cantidad de bandas
FROM tmax_202110_150s;
```

```
 st_height | st_width | st_srid | st_numbands
-----------+----------+---------+-------------
      3744 |     8640 |    4326 |           1
```

### `ST_SummaryStatsAgg()`
La función [ST_SummaryStatsAgg()](https://postgis.net/docs/RT_ST_SummaryStatsAgg.html) retorna estadísticas generales de una tabla raster.

```sql
-- Estadísticas
SELECT (ST_SummaryStatsAgg(rast, 1, true, 1)).*
FROM tmax_202110_150s;
```

```
  count  |    sum    |        mean        |       stddev       | min | max
---------+-----------+--------------------+--------------------+-----+-----
 8986760 | 140919725 | 15.680815444053252 | 15.560723823335957 | -26 |  42
```

### `ST_Value()`
La función [ST_Value()](https://postgis.net/docs/RT_ST_Value.html) retorna el valor de un raster en un punto que recibe como entrada (hay otras formas de especificar la ubicación).

La siguiente consulta SQL retorna la temperatura máxima en octubre 2021 de la ubicación de cada registro de mamíferos en [https://doi.org/10.15468/dl.vmdyxe](https://doi.org/10.15468/dl.vmdyxe).

```sql
-- Temperatura máxima de cada registro de mamíferos
SELECT ST_AsText(g.geom), g.species, ST_Value(r.rast, g.geom) AS temperatura_maxima
FROM tmax_202110_150s AS r INNER JOIN (SELECT species, geom FROM mamiferos) AS g
  ON r.rast && g.geom
ORDER BY g.species;
```

```
           st_astext           |           species            | temperatura_maxima
-------------------------------+------------------------------+--------------------
 POINT(-82.686267 9.636864)    | Alouatta palliata            |                 30
 POINT(-82.837805 9.735694)    | Alouatta palliata            |                 30
 POINT(-82.902285 9.711651)    | Alouatta palliata            |                 30
 POINT(-82.688844 9.637409)    | Alouatta palliata            |                 30
 POINT(-82.701155 9.638481)    | Alouatta palliata            |                 30
 POINT(-83.506923 10.448877)   | Alouatta palliata            |                 30
 POINT(-83.298207 8.389043)    | Alouatta palliata            |                 30
 POINT(-83.29553 8.389693)     | Alouatta palliata            |                 30
 POINT(-83.546198 10.477045)   | Alouatta palliata            |                 30
 POINT(-83.349556 10.298109)   | Alouatta palliata            |                 30
 POINT(-83.307467 8.386528)    | Alouatta palliata            |                 30
```

## Ejercicios
1. Cree una base de datos PostgreSQL/PostGIS llamada `worldclim` y agréguele las extensiones postgis y postgis_raster.
2. De la base de datos climática [WorldClim](https://www.worldclim.org/), descargue los [datos mensuales](https://www.worldclim.org/data/monthlywth.html) de temperatura máxima para los períodos 1990-1999, 2000-2009, 2010-2019 y 2020-2021 y cárguelos en la base de datos `worldclim`.
3. Calcule la elevación promedio de las ubicaciones de cada especie de [mamíferos de Costa Rica](https://doi.org/10.15468/dl.vmdyxe). Utilice la capa de elevación de 2.5 min en [https://www.worldclim.org/data/worldclim21.html](https://www.worldclim.org/data/worldclim21.html).
4. Repita el ejercicio anterior con la capa de elevación en resolución de 30 s.
