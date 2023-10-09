# Introducción a PostGIS

## Introducción
[PostGIS](https://postgis.net/) es una extensión de [PostgreSQL](https://www.postgresql.org/) que incorpora funcionalidad espacial a este SABD al agregar soporte para tipos de datos espaciales, índices espaciales y funciones espaciales. Al estar construido sobre PostgreSQL, PostGIS hereda automáticamente todas sus ventajas como SABD organizacional, así como estándares abiertos para su implementación. Tanto PostgreSQL como PostGIS son proyectos de software de código abierto.

[Refractions Research](http://www.refractions.net/) lanzó la primera versión de PostGIS en 2001, la cual contaba con objetos, índices y unas cuantas funciones. A través de los años, el proyecto se enriqueció con la implementación de la especificación [Simple Features for SQL (SFSQL)](https://postgis.net/workshops/postgis-intro/glossary.html#term-SFSQL) del [Open Geospatial Consortium (OGC)](https://www.ogc.org/) y  con el aporte de otros proyectos de desarrollo de software apoyados por [OSGeo](https://www.osgeo.org/), como la biblioteca ["Geometry Engine, Open Source" (GEOS)](http://trac.osgeo.org/geos), la cual proporciona el código fuente necesario para implementar los algoritmos de SFSQL (ej. `ST_Intersects()`, `ST_Buffer()`, `ST_Union()` y muchos otros).

## Instalación
Las instrucciones detalladas para la instalación de PostGIS, en diferentes sistemas operativos, pueden encontrarse en [Introduction to PostGIS - Installation](https://postgis.net/workshops/postgis-intro/installation.html).

## Creación de bases de datos
PostgreSQL cuenta con varias interfaces administrativas. La principal es [psql](http://www.postgresql.org/docs/current/static/app-psql.html), una herramienta de línea de comandos para ingresar consultas SQL. Otra interfaz popular de PostgreSQL es la herramienta gráfica gratuita y de código abierto [pgAdmin](http://www.pgadmin.org/). Todas las consultas realizadas en pgAdmin también se pueden hacer en la línea de comandos con psql. pgAdmin también incluye un visor de geometrías que puedes usar para visualizar espacialmente las consultas de PostGIS.

En el caso de pgAdmin, una base de datos espacial puede crearse igual que cualquier otra base de datos (Databases - New Database) y ejecutando además el comando:

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
Existen varias opciones para cargar datos espaciales en PostGIS.

- Desde un archivo de respaldo (*backup file*).
- Con la herramienta ogr2ogr.
- Con la herramienta shp2pgsql.
- Con otras herramientas (ej. QGIS).

## Ejercicios
Para cargar los datos requeridos para resolver estos ejercicios, puede consultar [Introduction to PostGIS - Loading spatial data](https://postgis.net/workshops/postgis-intro/loading_data.html).

1. Cree una base de datos PostgreSQL-PostGIS con nombre `nyc`.
2. Cargue en `nyc` el [archivo de respaldo](https://s3.amazonaws.com/s3.cleverelephant.ca/postgis-workshop-2020.zip).
3. En `nyc`, examine:
    - Las columnas de geometría de las tablas (ej. `geom`).
    - La tabla `spatial_ref_sys`.
    - Las vistas `geometry_columns` y `geography_columns`.
4. Lea la descripción de los datos en [Introduction to PostGIS - About our data](https://postgis.net/workshops/postgis-intro/about_data.html).
5. En QGIS, cree una conexión a la base de datos `nyc` y visualice sus tablas.
6. Ejecute las consultas SQL en:
    - [Introduction to PostGIS - Simple SQL](https://postgis.net/workshops/postgis-intro/simple_sql.html)
    - [Introduction to PostGIS - Simple SQL Exercises](https://postgis.net/workshops/postgis-intro/simple_sql_exercises.html)
7. Del [Sistema Nacional de Información Territorial (SNIT)](https://www.snitcr.go.cr/), descargue las siguientes capas y cárguelas en una nueva base de datos PostgreSQL-PostGIS:
    - Provincias.
    - Cantones.
    - Distritos.
    - Áreas de conservación.
    - Áreas silvestres protegidas.
8. Mediante consultas SQL, genere archivos (ej. SHP, GPKG) y también tablas para:
    - Cantones de la provincia de Cartago.
    - Distritos del cantón de Turrialba.
    - Cantidad de distritos de cada cantón de Heredia.