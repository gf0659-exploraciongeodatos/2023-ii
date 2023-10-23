# PostGIS - Introducción

## Introducción
[PostGIS](https://postgis.net/) es una [extensión](https://airbyte.com/data-engineering-resources/postgresql-extensions) de [PostgreSQL](https://www.postgresql.org/) que incorpora funcionalidad espacial a este motor de bases de datos, al agregarle soporte para tipos de datos espaciales, índices espaciales y funciones espaciales. PostGIS hereda todas las ventajas que ofrece PostgreSQL como SABD organizacional, tales como conformidad con los estándares SQL, manejo de concurrencia, seguridad, optimización de consultas y procedimientos almacenados, entre otras. Tanto PostgreSQL como PostGIS son proyectos de código abierto.

[Refractions Research](http://www.refractions.net/) lanzó la primera versión de PostGIS en 2001, la cual contaba con objetos, índices y unas cuantas funciones espaciales. El proyecto se benefició con el desarrollo de la especificación [SF-SQL](https://www.ogc.org/standard/sfs/) y también con el aporte de proyectos de software apoyados por [OSGeo](https://www.osgeo.org/), como la biblioteca ["Geometry Engine, Open Source" (GEOS)](http://trac.osgeo.org/geos), la cual proporcionó el código fuente necesario para implementar los algoritmos de SF-SQL (ej. `ST_Intersects()`, `ST_Buffer()`, `ST_Union()`).

## Instalación
Las instrucciones detalladas para la instalación de PostGIS, en diferentes sistemas operativos, pueden encontrarse en [Introduction to PostGIS - Installation](https://postgis.net/workshops/postgis-intro/installation.html).

## Creación de bases de datos
PostgreSQL cuenta con varias interfaces administrativas, desde las cuales pueden crearse bases de datos. La principal es [psql](http://www.postgresql.org/docs/current/static/app-psql.html), una herramienta de línea de comandos para ingresar consultas SQL. Otra interfaz muy popular es la herramienta gráfica [pgAdmin](http://www.pgadmin.org/). Todas las consultas realizadas en pgAdmin también se pueden hacer en la línea de comandos con psql. pgAdmin incluye un visor de geometrías que puede usarse para visualizar espacialmente las consultas en PostGIS.

En el caso de pgAdmin, una base de datos espacial puede crearse igual que cualquier otra base de datos, con la opción de menú **Databases - New Database** y ejecutando además, con la herramienta **Query Tool**, el comando:

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
Este método permite restaurar una base de datos a partir de su respaldo (*backup*) en un archivo (ej. `.backup`). En pgAdmin, está disponible en la opción **Restore...** del menú que se despliega al hacer clic derecho en el ícono de una base de datos.

### Con la herramienta ogr2ogr
[ogr2ogr](https://gdal.org/programs/ogr2ogr.html) es un programa que forma parte de la biblioteca [Geospatial Data Abstraction Library (GDAL)](https://gdal.org/), la cual se enfoca en la conversión entre formatos vectoriales y raster. `ogr2ogr` realiza conversiones entre formatos vectoriales (ej. SHP, GPKG, GML, KML) y se ejecuta desde la línea de comandos del sistema operativo. Para Microsoft Windows, se sugiere utilizar la línea de comandos de **OSGeo4W Shell**, la cual se instala junto con varias aplicaciones, incluyendo QGIS.

Para acceder una base de datos PostgreSQL-PostGIS, `ogr2ogr` requiere el nombre de la base de datos (`dbname`), la computadora en la que está alojada (`host`), un usuario con los derechos necesarios para cargar los datos (`user`) y su clave. Para no incluir la clave en el comando (lo que sería muy inseguro), se recomienda especificarla en una variable del sistema operativo denominada `PGPASSWORD`. En el caso de Microsoft Windows, por ejemplo, puede usarse un comando como el siguiente para definir esta variable.

```shell
# Especificación de la clave de PostgreSQL como variable del sistema operativo Windows
# mi_clave_de_postgresql debe sustituirse por la clave verdadera
set PGPASSWORD=mi_clave_de_postgresql
```

El siguiente comando carga una capa de provincias de Costa Rica alojada en un servicio WFS del Instituto Geográfico Nacional (IGN) en una tabla de una base de datos PostgreSQL-PostGIS.

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
Antes de resolver estos ejercicios, se recomienda consultar [Introduction to PostGIS - Loading spatial data](https://postgis.net/workshops/postgis-intro/loading_data.html).

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
7. Cree otra base de datos llamada `cr`.    
8. Cargue en `cr` las siguientes capas disponibles en el [Sistema Nacional de Información Territorial (SNIT)](https://www.snitcr.go.cr/):
    - Provincias.
    - Cantones.
    - Distritos.
    - Áreas de conservación.
    - Áreas silvestres protegidas.
    - Red vial 1:200 mil.
    - Hidrografía 1:5 mil.
    - Aeródromos 1: 200 mil.
8. De [https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/gbif/felidos.csv](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/gbif/felidos.csv) descargue el archivo `felidos.csv` y cárguelo como una tabla en `cr`.
9. Visualice los datos de `cr` en QGIS.