# PostGIS - Coordenadas geográficas

## Introducción
A diferencia de las coordenadas en SRS como UTM o CRTM05, las coordenadas "geográficas" (latitud-longitud) no son [coordenadas cartesianas](https://es.wikipedia.org/wiki/Coordenadas_cartesianas). No representan una distancia lineal desde un origen hasta un destino, como se traza en un plano. Más bien, son coordenadas esféricas que describen coordenadas angulares en un globo. En las coordenadas esféricas, un punto se especifica por el ángulo de rotación desde un meridiano de referencia (longitud) y el ángulo desde el ecuador (latitud), como se ilustra en la {numref}`figure-tablas-vistas-metadatos`.

```{figure} img/coordenadas-cartesianas-esfericas.jpg
:name: figure-coordenadas-cartesianas-esfericas

Coordenadas cartesianas y coordenadas esféricas. Fuente: [Introduction to PostGIS](https://postgis.net/workshops/postgis-intro/).
```

Las mediciones de distancia, longitud y área, entre otras, no tienen sentido si las coordenadas geográficas se tratan como coordenadas cartesianas, ya que las coordenadas geográficas miden ángulos y sus unidades son grados. La distancia entre puntos se hace más grande a medida que se acercan a áreas problemáticas como los polos o la línea internacional de cambio de fecha.

Por ejemplo, las siguientes son las coordenadas geográficas de Los Ángeles y París:

- Los Ángeles: `POINT(-118.4079 33.9434)`
- París: `POINT(2.3490 48.8533)`

La siguiente sentencia SQL calcula la distancia entre ambas ciudades con la función `ST_Distance()` y el tipo de datos [GEOMETRY](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#PostGIS_Geometry). Note que el [SRID 4326](https://epsg.io/4326) corresponde a un sistema de coordenadas geográficas.

```sql
-- Cálculo de la distancia entre Los Ángeles y París
-- con el tipo de datos GEOMETRY
SELECT ST_Distance(
  'SRID=4326;POINT(-118.4079 33.9434)'::geometry, -- Los Angeles (LAX)
  'SRID=4326;POINT(2.5559 49.0083)'::geometry     -- Paris (CDG)
);
```

```
    st_distance
--------------------
 121.89828597010705
```

Este resultado está expresado en grados, por lo que no es de utilidad.

Para realizar un cálculo apropiado, se deben tratar las coordenadas como verdaderas coordenadas esféricas. Para esto, PostGIS implementa el tipo de datos [GEOGRAPHY](https://postgis.net/docs/manual-3.4/using_postgis_dbmanagement.html#PostGIS_Geography).

El cálculo de la distancia se repite en la siguiente sentencia SQL, la cual usa el tipo de datos `GEOGRAPHY`.

```sql
-- Cálculo de la distancia entre Los Ángeles y París
-- con el tipo de datos GEOGRAPHY
SELECT ST_Distance(
  'SRID=4326;POINT(-118.4079 33.9434)'::geography, -- Los Angeles (LAX)
  'SRID=4326;POINT(2.5559 49.0083)'::geography     -- Paris (CDG)
);
```

```
   st_distance
------------------
 9124665.27317673
```

El resultado está expresado en metros y equivale a 9124.6 km.

## Ejercicios
1. En [Wikipedia](https://es.wikipedia.org/), obtenga las coordenadas geográficas de las siguientes localidades de Costa Rica:

- Ciudad de San José
- Ciudad de Limón
- Ciudad de Liberia
- Ciudad de Puntarenas

2. Con coordenadas geográficas, calcule las siguientes distancias:

- San José - Limón
- Limón - Puntarenas
- Puntarenas - Liberia
- Liberia - Limón

3. Calcule las mismas distancias, utilizando coordenadas CR05 / CRTM05.

4. Compare los resultados entre los dos tipos de cálculo.
