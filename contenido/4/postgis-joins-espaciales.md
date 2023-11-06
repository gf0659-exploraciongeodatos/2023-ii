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

9. Calcule nuevamente la densidad de la red vial en cantones, pero utilizando la capa de red vial del IGN en escala 1:5 mil. Compare el resultado con el obtenido en el punto anterior. 

10. Calcule el porcentaje de área de cada cantón en ASP por categoría de manejo (reserva biológica, parque nacional, humedal, etc.) y para todas las ASP.

## Notas

### Riqueza de especies de murciélagos en Costa Rica

Se comparan los resultados que se obtienen con QGIS y PostgreSQL/PostGIS-SQL.

#### QGIS
1. El archivo de [registros de presencia de murciélagos](https://doi.org/10.15468/dl.g5ce3g) se importó en QGIS con **Layer - Add Layer - Add Delimited Text Layer**. Se importaron 13470 registros.
2. En la tabla de atributos de la capa importada de registros de murciélagos, con la opción **Select features using an expression**, se seleccionaron los registros con el campo `species` diferente de nulo, mediante la expresión `"species" IS NOT NULL`. 12931 registros fueron seleccionados.
3. Con **Export - Save Selected Features As** los registros seleccionados se guardaron en el archivo `murcielagos.gpkg`, con el CRS "EPSG:5367 - CR05 / CRTM05".
4. La capa de ASP se cargó desde el WFS del Sinac en [https://geos1pne.sirefor.go.cr/wfs](https://geos1pne.sirefor.go.cr/wfs).
5. La riqueza de especies se calculó con **Vector - Analysis Tools - Count Points in Polygon** (`Class Field = species`). 

El resultado para las 10 ASP con mayor riqueza de especies es:

```
nombre_asp                  descripcio                NUMPOINTS
Golfo Dulce                 Area terrestre protegida  54
Arenal Monteverde           Area terrestre protegida  32
Palo Verde                  Area terrestre protegida  30
Corcovado                   Area terrestre protegida  27
Barra del Colorado          Area terrestre protegida  27
La Selva                    Area terrestre protegida  27
Santa Rosa                  Area terrestre protegida  18
Braulio Carrillo            Area terrestre protegida  17
Tapanti-Macizo de la Muerte Area terrestre protegida  15
Tortuguero                  Area terrestre protegida  12
```

#### PostgreSQL/PostGIS-SQL
1. El archivo de registros de presencia de murciélagos en Costa Rica se importó en PostgreSQL/PostGIS con el comando:

```shell
# Carga de los registros de presencia de murciélagos
ogr2ogr ^
  -nln murcielagos ^
  -oo SEPARATOR=TAB ^
  -oo X_POSSIBLE_NAMES=decimalLongitude -oo Y_POSSIBLE_NAMES=decimalLatitude ^
  -oo EMPTY_STRING_AS_NULL=YES ^
  -lco GEOMETRY_NAME=geom ^
  -s_srs EPSG:4326 ^
  -t_srs EPSG:5367 ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  murcielagos.csv
```

La opción `EMPTY_STRING_AS_NULL=YES` es para cargar los campos vacíos como nulos, como lo hace la funcionalidad **Add Delimited Text Layer** de QGIS.

2. La capa de ASP de Costa Rica se importó en PostgreSQL/PostGIS con el comando:

```shell
# Carga de la capa de ASP
ogr2ogr ^
  -nln asp ^
  -lco GEOMETRY_NAME=geom ^
  Pg:"dbname=cr host=localhost user=postgres port=5432" ^
  WFS:"https://geos1pne.sirefor.go.cr/wfs?" "PNE:areas_silvestres_protegidas"
```

3. La riqueza de especies se calculó con el comando SQL:

```sql
-- Cálculo de la riqueza de especies de murciélagos en ASP
SELECT 
  asp.nombre_asp, 
  asp.descripcio, 
  COUNT(DISTINCT m.species) AS riqueza_especies
FROM asp LEFT JOIN murcielagos AS m
  ON ST_Contains(asp.geom, m.geom)
WHERE species IS NOT NULL
GROUP BY asp.nombre_asp, asp.descripcio
ORDER BY riqueza_especies DESC;
```

El resultado para las 10 ASP con mayor riqueza de especies es:

```
         nombre_asp          |        descripcio        | riqueza_especies
-----------------------------+--------------------------+------------------
 Golfo Dulce                 | Area terrestre protegida |               54
 Arenal Monteverde           | Area terrestre protegida |               32
 Palo Verde                  | Area terrestre protegida |               30
 Corcovado                   | Area terrestre protegida |               27
 Barra del Colorado          | Area terrestre protegida |               27
 La Selva                    | Area terrestre protegida |               27
 Santa Rosa                  | Area terrestre protegida |               18
 Braulio Carrillo            | Area terrestre protegida |               17
 Tapanti-Macizo de la Muerte | Area terrestre protegida |               15
 Tortuguero                  | Area terrestre protegida |               12
```

Se añade `descripcio` la cláusula `GROUP BY` para diferenciar algunas de las ASP con el mismo nombre y así obtener un resultado similar al que se obtuvo con QGIS. Si se desea unificar el conteo de especies para todas las ASP con el mismo nombre, se puede omitir `descripcio` en la cláusula `GROUP BY`:

```sql
-- Cálculo de la riqueza de especies de murciélagos en ASP
SELECT 
  asp.nombre_asp, 
  COUNT(DISTINCT m.species) AS riqueza_especies
FROM asp LEFT JOIN murcielagos AS m
  ON ST_Contains(asp.geom, m.geom)
WHERE species IS NOT NULL
GROUP BY asp.nombre_asp
ORDER BY riqueza_especies DESC;
```

La consulta anterior genera el resultado:

```
         nombre_asp          | riqueza_especies
-----------------------------+------------------
 Golfo Dulce                 |               54
 Arenal Monteverde           |               32
 Palo Verde                  |               30
 Corcovado                   |               28
 Barra del Colorado          |               27
 La Selva                    |               27
 Santa Rosa                  |               18
 Braulio Carrillo            |               17
 Tapanti-Macizo de la Muerte |               15
 Tortuguero                  |               12
```

La diferencia se debe a que algunas ASP (ej. Corcovado) tienen dos polígonos (ej. un área terrestre y otra marítima), algunas de las cuales pueden diferenciarse con `descripcio`. Sin embargo, no se encontró un atributo o combinación de atributos que diferencie individualmente a cada ASP.

### Riqueza de especies de mamíferos en Mesoamérica

1. Carga del archivo de [registros de presencia de mamíferos](https://doi.org/10.15468/dl.ugu9n3) de Mesoamérica:

```shell
ogr2ogr ^
  -nln mamiferos ^
  -oo X_POSSIBLE_NAMES=decimalLongitude -oo Y_POSSIBLE_NAMES=decimalLatitude ^
  -oo EMPTY_STRING_AS_NULL=YES ^
  -lco GEOMETRY_NAME=geom ^
  -s_srs EPSG:4326 ^
  -t_srs EPSG:4326 ^
  Pg:"dbname=mesoamerica host=localhost user=postgres port=5432" ^
  mamiferos.csv
```

Por alguna razón, aún por determinar, el comando anterior solo carga 678 714 registros de los 1 104 457 contenidos en el archivo. La funcionalidad **Add Delimited Text Layer** de QGIS carga más de 1 millón de registros.

2. Carga del archivo de países de Mesoamérica a partir del [archivo de países de Natural Earth](https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip).

```shell
ogr2ogr ^
  -nln paises ^
  -nlt PROMOTE_TO_MULTI ^
  -lco GEOMETRY_NAME=geom ^
  -sql "SELECT * FROM ne_10m_admin_0_countries WHERE NAME IN ('Mexico', 'Belize', 'Guatemala', 'Honduras', 'El Salvador', 'Nicaragua', 'Costa Rica', 'Panama', 'Colombia')" ^
  Pg:"dbname=mesoamerica host=localhost user=postgres port=5432" ^
  ne_10m_admin_0_countries.shp
```

3. Cálculo de la riqueza de especies:

```sql
-- Cálculo de la riqueza de especies de mamíferos en países de Mesoamérica
SELECT 
  p.name, 
  COUNT(DISTINCT m.species) AS riqueza_especies
FROM paises AS p LEFT JOIN mamiferos AS m
  ON ST_Contains(p.geom, m.geom)
WHERE m.species IS NOT NULL
GROUP BY p.name
ORDER BY riqueza_especies DESC;
```

Resultado (puede variar al cargar más registros de presencia):

```
    name     | riqueza_especies
-------------+------------------
 Mexico      |              773
 Colombia    |              627
 Panama      |              281
 Costa Rica  |              280
 Guatemala   |              234
 Honduras    |              218
 Nicaragua   |              202
 El Salvador |              144
 Belize      |              141
```

### Densidad de la red vial en cantones de Costa Rica

#### Con capa 1:200 mil del IGN
```sql
-- Red vial 1:200k
SELECT 
  c.cantÓn AS canton, 
  ROUND(SUM(ST_Length(ST_Intersection(c.geom, v.geom))/1000)::numeric, 2) AS longitud_red_vial,
  ROUND((ST_Area(c.geom)/1000000)::numeric, 2) AS area,
  ROUND(ROUND(SUM(ST_Length(ST_Intersection(c.geom, v.geom))/1000)::numeric, 2) / ROUND((ST_Area(c.geom)/1000000)::numeric, 2), 2) AS densidad_red_vial
FROM cantones AS c JOIN red_vial_200k AS v
  ON ST_Intersects(c.geom, v.geom)
GROUP BY canton, c.geom
ORDER BY densidad_red_vial DESC;
```

```
canton             longitud_red_vial area         densidad_red_vial
San José           100.75            44.62        2.26
Goicoechea         68.43             31.70        2.16
Curridabat         33.31             16.06        2.07
Tibás              16.48             8.27         1.99
León Cortés Castro 238.95            121.89       1.96
San Pablo          15.16             8.34         1.82
Escazú             62.91             34.53        1.82
Santo Domingo      43.36             25.40        1.71
Santa Bárbara      86.89             52.10        1.67
```
