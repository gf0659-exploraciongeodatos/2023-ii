# Relaciones espaciales

## Relaciones topológicas
Las relaciones topológicas, también llamadas relaciones topológicas binarias, son expresiones lógicas (verdaderas o falsas) sobre las relaciones espaciales entre dos objetos. Por ejemplo, si `a` y `b` son dos objetos espaciales (ej. puntos, líneas, polígonos), se pueden considerar relaciones topológicas como las siguientes:

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

### `ST_Intersects()`, `ST_Disjoint()`, `ST_Crosses()`, `ST_Overlaps()` y `ST_Touches()`

#### `ST_Intersects()`
[ST_Intersects(geometry A, geometry B)](http://postgis.net/docs/ST_Intersects.html) retorna `TRUE` si `geometry A` y `geometry B` comparten espacio en sus bordes o en sus interiores.

#### `ST_Disjoint()`
[ST_Disjoint(geometry A, geometry B)](http://postgis.net/docs/ST_Disjoint.html) retorna `TRUE` si `geometry A` y `geometry B` no comparten espacio en sus bordes o en sus interiores. Es la función opuesta a `ST_Intersects()`. De hecho, es más eficiente usar la expresión `NOT (ST_Intersects(geometry A, geometry B))` que `ST_Disjoint(geometry A, geometry B)` debido a que las intersecciones pueden comprobarse mediante índices, mientras que las disjunciones no.

#### `ST_Crosses()`
Para comparaciones de multipunto-polígono, multipunto-línea, línea-línea, línea-polígono y línea-multipolígono, [ST_Crosses(geometry A, geometry B)](http://postgis.net/docs/ST_Crosses.html) retorna `TRUE` si la intersección resulta en una geometría cuyo número de dimensiones es menor que el número máximo de dimensiones de las dos geometrías originales y el conjunto de intersección está en el interior de ambas geometrías originales.

#### `ST_Overlaps()`
[ST_Overlaps(geometry A, geometry B)](http://postgis.net/docs/ST_Overlaps.html) compara dos geometrías de la misma cantidad de dimensiones y retorna `TRUE` si su intersección resulta en una geometría diferente de ambas pero de la misma cantidad de dimensiones.

#### `ST_Touches()`
[ST_Touches(geometry A, geometry B)](http://postgis.net/docs/ST_Touches.html) retorna `TRUE` si los límites de alguna de las geometrías se intersectan o si el interior de solo una de las geometrías intersecta el límite de la otra.

### `ST_Within()` y `ST_Contains()`
Tanto `ST_Within()` como `ST_Contains()` comprueban si una geometría está completamente dentro de la otra.

#### `ST_Within()`
[ST_Within(geometry A, geometry B)](http://postgis.net/docs/ST_Within.html) retorna `TRUE` si `geometry A` está completamente dentro de `geometry B`. 

#### `ST_Contains()`
[ST_Contains(geometry A, geometry B)](http://postgis.net/docs/ST_Contains.html) retorna `TRUE` si `geometry B` está completamente contenida en `geometry A`.

## Relaciones de distancia
Un problema muy común en sistemas de información geográfica es "encuentrar todo lo que esté a una distancia X de estos objetos". Las funciones `ST_Distance()` y `ST_DWithin()` pueden ayudar a resolver ese tipo de problemas.

### `ST_Distance()` y `ST_DWithin()`

#### `ST_Distance()`
La función [ST_Distance(geometry A, geometry B)](http://postgis.net/docs/ST_Distance.html) calcula la distancia más corta entre dos geometrías y la devuelve como un número de tipo `float`.

```sql
-- Cálculo de la distancia entre dos objetos
SELECT ST_Distance(
ST_GeometryFromText('POINT(0 5)'),
ST_GeometryFromText('LINESTRING(-2 2, 2 2)'));
```

```
3
```

#### `ST_DWithin()`
La función [ST_DWithin()](http://postgis.net/docs/ST_DWithin.html) permite probar si dos objetos están a una cierta distancia el uno del otro. Esto es útil para preguntas como "¿cuántos árboles están dentro de un *buffer* de 500 metros de la carretera?". Con `ST_DWithin()`, se puede comprobar la relación de distancia sin generar el *buffer*.

```sql
-- Calles a una distancia de 10 metros o menos de una estación del tren subterráneo
SELECT name
FROM nyc_streets
WHERE ST_DWithin(
        geom,
        ST_GeomFromText('POINT(583571 4506714)',26918),
        10
      );
```

```
     name
--------------
   Wall St
   Broad St
   Nassau St
```

## Ejercicios
1. Encuentre todos los registros de presencia de félidos en un radio de 10 km del punto (-84.0, 10.0) (WGS84).
2. Para el punto más cercano a (-84.0, 10.0), encuentre su:
    - Cantón
    - Distrito
    - Área de conservación
    - ASP
3. Encuentre las vías en un radio de 1 km del punto más cercano a (-84.0, 10.0).