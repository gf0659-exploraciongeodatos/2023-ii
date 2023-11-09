# PostGIS - Sistemas de referencia espacial

## Introducción
PostGIS incluye varias funciones para el manejo de [sistemas de referencia espacial (SRS)](https://en.wikipedia.org/wiki/Spatial_reference_system), también llamados sistemas de referencia de coordenadas (CRS). El SRS de cada geometría se identifica por su SRID (ej. 4326, 5367) y determina las unidades de los ejes X e Y.

## La tabla `spatial_ref_sys`
La tabla [spatial_ref_sys](https://postgis.net/docs/using_postgis_dbmanagement.html#spatial_ref_sys_table) contiene las definiciones de los SRS disponibles en una base de datos. Al crear la extensión postgis en una base de datos, `spatial_ref_sys` se carga automáticamente con más de 8000 definiciones de los SRS más comunes. La tabla puede modificarse para agregar SRS personalizados. Sus columnas son:

- `srid`: número entero que funciona como identificador único del SRS en la base de datos.
- `auth_name`: nombre del autor del SRID. Por ejemplo, [EPSG](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset).
- `auth_srid`: ID del SRS definido por la autoridad citada en `auth_name`. En el caso de EPSG, este es el código EPSG.
- `srtext`: representación en WKT del SRS. Por ejemplo:

```
PROJCS["NAD83 / UTM Zone 10N",
  GEOGCS["NAD83",
	DATUM["North_American_Datum_1983",
	  SPHEROID["GRS 1980",6378137,298.257222101]
	],
	PRIMEM["Greenwich",0],
	UNIT["degree",0.0174532925199433]
  ],
  PROJECTION["Transverse_Mercator"],
  PARAMETER["latitude_of_origin",0],
  PARAMETER["central_meridian",-123],
  PARAMETER["scale_factor",0.9996],
  PARAMETER["false_easting",500000],
  PARAMETER["false_northing",0],
  UNIT["metre",1]
]
```

- `proj4text`: representación del SRS en el formato de la biblioteca [PROJ](https://proj.org/), la cual es utilizada por PostGIS para transformaciones entre sistemas de coordenadas. Por ejemplo:

```
+proj=utm +zone=10 +ellps=clrk66 +datum=NAD27 +units=m
```

Al recuperar definiciones de SRS para su uso en transformaciones, PostGIS utiliza la siguiente estrategia:

- Si `auth_name` y `auth_srid` están presentes (no nulos) se utiliza el SRS de PROJ que corresponde a esas entradas, si existe uno.
- Si `srtext` está presente, se usa para crear el SRS, si es posible.
- Si `proj4text` está presente, se usar para crear el SRS, si es posible.

## Funciones

### `ST_SRID()`
La función [ST_SRID(geometry)](https://postgis.net/docs/ST_SRID.html) retorna el SRID de una geometría.

```sql
-- Consulta del SRID de una geometría
SELECT ST_SRID(geom) FROM provincias LIMIT 1;
```

```
 st_srid
---------
    5367
```

### `ST_Transform()`
[ST_Transform(geometry, srid)](https://postgis.net/docs/ST_Transform.html) recibe como argumentos una geometría y un SRS y retorna la geometría con las coordenadas transformadas al SRS especificado.

```sql
-- Transformación de un punto en el SRS WGS84 (4326) al SRS CRTM05 (5367)
SELECT ST_AsText(
  ST_Transform(
    ST_GeomFromText('POINT(-84.0 10.0)', 4326),
    5367
  )
);
```

```
                  st_astext
---------------------------------------------
 POINT(499999.9671646528 1105744.1866461728)
```

Este tipo de transformaciones también pueden realizarse desde la línea de comandos del sistema operativo, con el programa [cs2cs](https://proj.org/en/9.3/apps/cs2cs.html).

```shell
echo -84.0 10.0 | cs2cs +proj=longlat +datum=WGS84 +to +init=epsg:5367
```

```
499999.97       1105744.19
```

### `ST_SetSRID()`
[ST_SetSRID(geometry, srid)](http://postgis.net/docs/ST_SetSRID.html) le asigna un SRID a una geometría. 

```sql
-- Consulta del SRID de las geometrías de la tabla geometries
SELECT ST_AsText(geom), ST_SRID(geom) FROM geometries;
```

```
                           st_astext                           | st_srid
---------------------------------------------------------------+---------
 POINT(0 0)                                                    |       0
 LINESTRING(0 0,1 1,2 1,2 2)                                   |       0
 POLYGON((0 0,1 0,1 1,0 1,0 0))                                |       0
 POLYGON((0 0,10 0,10 10,0 10,0 0),(1 1,1 2,2 2,2 1,1 1))      |       0
 GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0,1 0,1 1,0 1,0 0))) |       0
```

```sql
-- Asignación del SRID 26918 a las geometrías de la tabla geometries
-- y transformación al SRID 4326
SELECT ST_AsText(
  ST_Transform(
    ST_SetSRID(geom, 26918),
    4326)
  )
FROM geometries;
```

```
 POINT(-79.48874388438705 0)
 LINESTRING(-79.48874388438705 0,-79.48873492539037 0.000009019375921,-79.48872596639353 0.000009019376033,-79.48872596639369 0.000018038752065)
 POLYGON((-79.48874388438705 0,-79.4887349253903 0,-79.48873492539037 0.000009019375921,-79.4887438843871 0.00000901937581,-79.48874388438705 0))
 POLYGON((-79.48874388438705 0,-79.48865429441472 0,-79.48865429442024 0.000090193769243,-79.48874388439259 0.000090193758097,-79.48874388438705 0),(-79.48873492539037 0.000009019375921,-79.48873492539053 0.000018038751842,-79.48872596639369 0.000018038752065,-79.48872596639353 0.000009019376033,-79.48873492539037 0.000009019375921))
 GEOMETRYCOLLECTION(POINT(-79.48872596639346 0),POLYGON((-79.48874388438705 0,-79.4887349253903 0,-79.48873492539037 0.000009019375921,-79.4887438843871 0.00000901937581,-79.48874388438705 0)))
```

## Ejercicios
1. Compare la longitud de la red vial de cada cantón, medida en CR05 / CRTM05 y CR-SIRGAS / CRTM05 .

