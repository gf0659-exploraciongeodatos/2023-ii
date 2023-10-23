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
1. Encuentre todos los registros de presencia de félidos en un radio de 10 km del punto (-84.0, 10.0) (WGS84).
2. Para el aeródromo Amubri, encuentre su:
    - Cantón
    - Distrito
    - Área de conservación
    - ASP
3. Encuentre las vías en un radio de 1 km del aeródromo Amubri. Visualícelas en QGIS.
4. Encuentre las vías que atraviesan la ruta 32. Visualícelas en QGIS.
5. Calcule la cantidad de registros de presencia de félidos en cada provincia de Costa Rica.
6. Calcule la cantidad de especies (`species`) de félidos en cada provincia de Costa Rica.