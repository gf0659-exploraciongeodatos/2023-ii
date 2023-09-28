# Tarea 01

## Fecha y hora límite de entrega
Jueves 5 de octubre de 2023, 01:59 p.m.

## Descripción general
En esta tarea, cada estudiante escribirá una serie de comandos en el lenguaje SQL para consultar una base de datos y reportar los resultados que obtenga.

**La tarea es estrictamente individual**

## Entregables
Un archivo con extensión `.sql` con las consultas SQL descritas en la sección Desarrollo y sus resultados. La entrega debe realizarse a través de la plataforma Mediación Virtual.

Para cada pregunta, incluya la(s) consulta(s) SQL que utilice y los resultados obtenidos. Por ejemplo:

**Pregunta 1**
```
Consulta(s):
SELECT ...

Resultados:
Estadio     Goles
-------     -----
Estadio 01     99
Estadio 02     99
...

```

**Pregunta 2**
```
Consulta(s):
SELECT ...

Resultados:
```

Al revisar la tarea, el profesor ejecutará las consultas y verificará que los resultados coincidan con los que se reportan.

## Desarrollo

### Preparativos
Debe cargar en una base de datos PostgreSQL los siguientes archivos de datos de [StatsBomb](https://statsbomb.com/) sobre la Copa Mundial de la FIFA Catar 2022:

- [Partidos](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/statsbomb/partidos_catar_2022.csv)
- [Eventos de la fase de grupos](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/statsbomb/eventos_fase_grupos_catar_2022.csv)

Las tablas deben llamarse:
- `partidos_catar_2022`
- `eventos_fase_grupos_catar_2022`

Para obtener información sobre los datos, puede revisar las notas de clase y la [documentación de StatsBomb](https://github.com/statsbomb/open-data/tree/master/doc).

### Consultas
La siguiente es la lista de consultas SQL que debe implementar. Entre paréntesis se muestra el porcentaje de la nota correspondiente a cada una.

1. (15%) Nombre de todos los estadios y cantidad de goles anotados en cada uno durante la fase de grupos, ordenados descendentemente por la cantidad de goles.

2. (5%) Valores diferentes de la columna `type` de la tabla `eventos_fase_grupos_catar_2022`.

3. (15%) Nombre del equipo y cantidad de faltas cometidas por los 10 equipos que cometieron más faltas durante la fase de grupos, ordenados descendentemente por la cantidad de faltas.

4. (15%) Nombre del jugador, nombre de su equipo y cantidad de faltas recibidas por los 10 jugadores que recibieron más faltas durante la fase de grupos, ordenados descendentemente por la cantidad de faltas.

5. (5%) Valores diferentes de la columna `dribble_outcome` de la tabla `eventos_fase_grupos_catar_2022`, para los eventos de tipo "Dribble".

6. (15%) Nombre del equipo y cantidad de regates (*dribbles*) completos de los 10 equipos que realizaron más regates completos durante la fase de grupos, ordenados descendentemente por la cantidad de regates.

7. (15%) Nombre del jugador, nombre de su equipo y cantidad de regates (*dribbles*) completos de los 10 jugadores que realizaron más regates completos durante la fase de grupos, ordenados descendentemente por la cantidad de regates.

8. (15%) Nombre de todos los estadios y cantidad de remates directos a marco (`shot_outcome` = 'Saved', 'Post' o 'Goal') realizados en cada uno, durante la fase de grupos, ordenados descendentemente por la cantidad de remates.