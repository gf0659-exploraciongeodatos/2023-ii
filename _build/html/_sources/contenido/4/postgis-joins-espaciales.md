# PostGIS - Uniones (*joins*) espaciales

## Introducción
Las uniones (*joins*) espaciales permiten combinar información de diferentes tablas utilizando las relaciones espaciales como la llave del *join*. Gran parte de lo que se considera como "análisis GIS" o "análisis espacial "puede expresarse como *joins* espaciales.


## *Joins*
En el capítulo anterior, se exploraron las relaciones espaciales utilizando un proceso de dos pasos: extrayendo primero la geometría de un objeto y luego utilizándola para responder preguntas como: "¿en cuál polígono se encuentra?" o "¿cuáles objetos están a una distancia menor a x?".

Con un *join* espacial, se puede realizar el proceso en un solo paso. Por ejemplo, la siguiente consulta encuentra el barrio (*neighborhood*) y el distrito (*borough*) de Nueva York en el que se encuentra un estación del tren subterráneo.

```sql
-- Barrio y distrito de NY en los que se encuentra la estación "Broad St"
SELECT
  subways.name AS subway_name,
  neighborhoods.name AS neighborhood_name,
  neighborhoods.boroname AS borough
FROM nyc_neighborhoods AS neighborhoods
  JOIN nyc_subway_stations AS subways 
  ON ST_Contains(neighborhoods.geom, subways.geom)
WHERE subways.name = 'Broad St';
```

```
 subway_name | neighborhood_name  |  borough
-------------+--------------------+-----------
 Broad St    | Financial District | Manhattan
```

## *Joins* y sumarizaciones
La combinación de un `JOIN` con un `GROUP BY` proporciona el tipo de análisis que usualmente se realiza en un sistema GIS.

Considere la pregunta: "¿Cuál es la población y composición racial de los barrios de Manhattan?". Esta pregunta combina información sobre la población del censo con los límites de los barrios, con una restricción a solo un distrito de Manhattan.

```sql
-- Población y composición racial de los barrios de Manhattan
SELECT
  neighborhoods.name AS neighborhood_name,
  SUM(census.popn_total) AS population,
  100.0 * SUM(census.popn_white) / SUM(census.popn_total) AS white_pct,
  100.0 * SUM(census.popn_black) / SUM(census.popn_total) AS black_pct
FROM nyc_neighborhoods AS neighborhoods
  JOIN nyc_census_blocks AS census
  ON ST_Intersects(neighborhoods.geom, census.geom)
WHERE neighborhoods.boroname = 'Manhattan'
GROUP BY neighborhoods.name
ORDER BY white_pct DESC;
```

```
 neighborhood_name  | population | white_pct | black_pct
---------------------+------------+-----------+-----------
 Carnegie Hill       |      18763 |      90.1 |       1.4
 North Sutton Area   |      22460 |      87.6 |       1.6
 West Village        |      26718 |      87.6 |       2.2
 Upper East Side     |     203741 |      85.0 |       2.7
 Soho                |      15436 |      84.6 |       2.2
 Greenwich Village   |      57224 |      82.0 |       2.4
 Central Park        |      46600 |      79.5 |       8.0
 Tribeca             |      20908 |      79.1 |       3.5
 Gramercy            |     104876 |      75.5 |       4.7
 Murray Hill         |      29655 |      75.0 |       2.5
 Chelsea             |      61340 |      74.8 |       6.4
 Upper West Side     |     214761 |      74.6 |       9.2
 Midtown             |      76840 |      72.6 |       5.2
 Battery Park        |      17153 |      71.8 |       3.4
 Financial District  |      34807 |      69.9 |       3.8
 Clinton             |      32201 |      65.3 |       7.9
 East Village        |      82266 |      63.3 |       8.8
 Garment District    |      10539 |      55.2 |       7.1
 Morningside Heights |      42844 |      52.7 |      19.4
 Little Italy        |      12568 |      49.0 |       1.8
 Yorkville           |      58450 |      35.6 |      29.7
 Inwood              |      50047 |      35.2 |      16.8
 Washington Heights  |     169013 |      34.9 |      16.8
 Lower East Side     |      96156 |      33.5 |       9.1
 East Harlem         |      60576 |      26.4 |      40.4
 Hamilton Heights    |      67432 |      23.9 |      35.8
 Chinatown           |      16209 |      15.2 |       3.8
 Harlem              |     134955 |      15.1 |      67.1
```

La consulta anterior puede detallarse de la siguiente manera:

1. La cláusula `JOIN` crea una tabla virtual que incluye columnas tanto de las tablas de barrios como de censos.
2. La cláusula `WHERE` filtra nuestra tabla virtual a solo las filas en Manhattan.
3. Las filas restantes se agrupan por el nombre del barrio y se procesan con la función de agregación `SUM()` para sumar los valores de población.
4. Después de un poco de aritmética y formato (por ejemplo, `GROUP BY`, `ORDER BY`) en los números finales, la consulta despliega los porcentajes.

## Ejercicios
1. Para el aeródromo Amubri, encuentre su:
    - Cantón
    - Distrito
    - Área de conservación
    - ASP
2. Encuentre las vías en un radio de 1 km del aeródromo Amubri. Visualícelas en QGIS.
3. Encuentre las vías que atraviesan la ruta 32. Visualícelas en QGIS.
4. Calcule la cantidad de [registros de presencia de murciélagos](https://doi.org/10.15468/dl.g5ce3g) registrados en cada ASP de Costa Rica.
5. Calcule la cantidad de especies (`species`) de murciélagos registradas en cada ASP de Costa Rica.
6. Obtenga la lista de especies de murciélagos registradas en el ASP llamada "Golfo Dulce".
7. Calcula la riqueza de especies de mamíferos para los países ubicados entre Colombia (inclusive) y México (inclusive) con:
    - [Registros de presencia de mamíferos](https://doi.org/10.15468/dl.ugu9n3)
    - Capa "Admin 0 - Countries" de [Natural Earth - 1:10m Cultural Vectors](https://www.naturalearthdata.com/downloads/10m-cultural-vectors/)
8. Calcule la densidad de la red vial en los cantones de Costa Rica con:
    - Capa de red vial del IGN (1:200 mil)
    - Capa de cantones del IGN

La densidad de la red vial para un polígono se define como:  
**km de longitud de red vial / km2 de área**  
Por ejemplo, si un cantón tiene 500 km de longitud de red vial y un área de 1000 km2, la densidad de su red vial es 0.5.

## Notas sobre opciones de carga de datos

### ASP

#### ogr2ogr PROMOTE_TO_MULTI

```shell
ogr2ogr ^
  -makevalid ^
  -nln asp_ogr_multi ^
  -nlt PROMOTE_TO_MULTI ^
  -lco GEOMETRY_NAME=geom ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  WFS:"https://geos1pne.sirefor.go.cr/wfs?" "PNE:areas_silvestres_protegidas"
```

```sql
-- Cantidad de registros
SELECT COUNT(*) FROM asp_ogr_multi;
-- 173
```

#### ogr2ogr (sin PROMOTE_TO_MULTI)

```shell
ogr2ogr ^
  -makevalid ^
  -nln asp_ogr_single ^
  -lco GEOMETRY_NAME=geom ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  WFS:"https://geos1pne.sirefor.go.cr/wfs?" "PNE:areas_silvestres_protegidas"
```

```sql
-- Cantidad de registros
SELECT COUNT(*) FROM asp_ogr_single;
-- 173
```

### Murciélagos

#### ogr2ogr EMPTY_STRING_AS_NULL=YES

```shell
ogr2ogr ^
  -nln murcielagos_ogr_nullyes ^
  -oo X_POSSIBLE_NAMES=decimalLongitude -oo Y_POSSIBLE_NAMES=decimalLatitude ^
  -oo EMPTY_STRING_AS_NULL=YES ^
  -lco GEOMETRY_NAME=geom ^
  -s_srs EPSG:4326 ^
  -t_srs EPSG:5367 ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  murcielagos.csv
```

```sql
-- Cantidad de registros
SELECT COUNT(*) FROM murcielagos_ogr_nullyes;
-- 13470

-- Cantidad de registros con species IS NULL
SELECT COUNT(*) FROM murcielagos_ogr_nullyes WHERE species IS NULL;
-- 539

-- Cantidad de registros con species = ''
SELECT COUNT(*) FROM murcielagos_ogr_nullyes WHERE species = '';
-- 0
```

#### ogr2ogr EMPTY_STRING_AS_NULL=NO

```shell
ogr2ogr ^
  -nln murcielagos_ogr_nullno ^
  -oo X_POSSIBLE_NAMES=decimalLongitude -oo Y_POSSIBLE_NAMES=decimalLatitude ^
  -oo EMPTY_STRING_AS_NULL=NO ^
  -lco GEOMETRY_NAME=geom ^
  -s_srs EPSG:4326 ^
  -t_srs EPSG:5367 ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  murcielagos.csv
```

```sql
-- Cantidad de registros
SELECT COUNT(*) FROM murcielagos_ogr_nullno;
-- 13470

-- Cantidad de registros con species IS NULL
SELECT COUNT(*) FROM murcielagos_ogr_nullno WHERE species IS NULL;
-- 0

-- Cantidad de registros con species = ''
SELECT COUNT(*) FROM murcielagos_ogr_nullno WHERE species = '';
-- 539
```

#### QGIS Data Source Manager - Delimited Text, DB Manager - Import Layer File

```sql
-- Cantidad de registros
SELECT COUNT(*) FROM murcielagos_qgis;
-- 13470

-- Cantidad de registros con species IS NULL
SELECT COUNT(*) FROM murcielagos_qgis WHERE species IS NULL;
-- 539

-- Cantidad de registros con species = ''
SELECT COUNT(*) FROM murcielagos_qgis WHERE species = '';
-- 0
```

### Conteo de especies de murciélagos en ASP

#### QGIS Vector - Analysis Tools - Count Points in Polygon

##### asp_ogr_multi, murcielagos_ogr_nullyes

```
Golfo Dulce                 55
Arenal Monteverde           33
Palo Verde                  31
Barra del Colorado          28
Corcovado                   28
La Selva                    27
Santa Rosa                  19
Braulio Carrillo            18
Tapanti-Macizo de la Muerte 16
Tortuguero                  13
```

##### asp_ogr_multi, murcielagos_ogr_nullyes (con los no nulos seleccionados)

Expresión: `"paoText" is not NULL`

```
Golfo Dulce                 54
Arenal Monteverde           32
Palo Verde                  30
Barra del Colorado          27
Corcovado                   27
La Selva                    27
Santa Rosa                  18
Braulio Carrillo            17
Tapanti-Macizo de la Muerte 15
Tortuguero                  12
```

#### SQL

##### murcielagos_ogr_nullyes

```sql
-- Cantidad de especies en ASP
SELECT asp.nombre_asp, COUNT(DISTINCT m.species) AS cantidad_especies
FROM asp_ogr_multi AS asp JOIN murcielagos_ogr_nullyes m
  ON ST_Contains(asp.geom, m.geom)
WHERE species IS NOT NULL AND species != ''
GROUP BY asp.nombre_asp
ORDER BY cantidad_especies DESC;
```

```
Golfo Dulce                 54
Arenal Monteverde           32
Palo Verde                  30
Corcovado                   28
La Selva                    27
Barra del Colorado          27
Santa Rosa                  18
Braulio Carrillo            17
Tapanti-Macizo de la Muerte 15
Tortuguero                  12
```

##### murcielagos_ogr_nullno

```sql
-- Cantidad de especies en ASP
SELECT asp.nombre_asp, COUNT(DISTINCT m.species) AS cantidad_especies
FROM asp_ogr_multi AS asp JOIN murcielagos_ogr_nullno m
  ON ST_Contains(asp.geom, m.geom)
WHERE species IS NOT NULL AND species != ''
GROUP BY asp.nombre_asp
ORDER BY cantidad_especies DESC;
```

```
Golfo Dulce                 54
Arenal Monteverde           32
Palo Verde                  30
Corcovado                   28
La Selva                    27
Barra del Colorado          27
Santa Rosa                  18
Braulio Carrillo            17
Tapanti-Macizo de la Muerte 15
Tortuguero                  12
```

Si se omite la cláusula `WHERE species IS NOT NULL AND species != ''` en las dos consultas SQL anteriores, generan resultados diferentes.