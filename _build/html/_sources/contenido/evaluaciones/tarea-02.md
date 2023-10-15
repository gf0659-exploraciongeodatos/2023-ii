# Tarea 02

## Fecha y hora límite de entrega
Lunes 23 de octubre de 2023, 13:59.

## Descripción general
En esta tarea, se debe diseñar una base de datos relacional sobre películas, de acuerdo con el modelo entidad - relación (ER), y escribir los comandos SQL para crear las tablas, insertar registros de prueba y consultarlos.

La base de datos debe manejar la siguiente información:

- Actores que actúan en una película.
- Películas en las que actúa un actor.
- Películas que dirige un director.
- Películas que produce un estudio. Un estudio es una compañía que se dedica a la producción y rodaje de películas (ej. "20th Century Fox", "Warner Bros.", "Columbia Pictures").
- Reseñas (i.e. evaluaciones) de una película.

Tome en cuenta las siguientes restricciones:

- Para cada película, se deben almacenar, al menos, los atributos: nombre, fecha de estreno, director, estudio.
- Para cada actor y director, se deben almacenar, al menos, los atributos: nombre, apellidos, nacionalidad.
- Para cada estudio, se deben almacenar, al menos, los atributos: nombre, país, ciudad.
- Para cada reseña, se deben almacenar, al menos, los atributos: calificación (entre 1 y 10), comentario.
- Cada película tiene solamente un director. Un director puede dirigir muchas películas.
- Cada película puede tener varios actores. Un actor puede actuar en varias películas.
- El director de una película también puede ser actor en la misma película.
- Cada película es producida por un solo estudio. Un estudio puede producir varias películas.
- Una película puede tener varias reseñas. Una reseña evalúa una sola película.

Además de los atributos mencionados, debe considerar llaves primarias y llaves foráneas al momento de implementar las entidades como tablas de la base de datos, así como tablas adicionales para relaciones de muchos a muchos y cualquier otra que considere necesaria.


**Esta tarea puede realizarse en parejas o individualmente. En el primer caso, solo uno de los integrantes del equipo debe entregar la tarea en Mediación Virtual e indicar el nombre del otro integrante.**

## Entregables
El valor porcentual de cada entregable se muestra entre paréntesis.

1. Un archivo `.drawio` con dos diagramas (como los confeccionados en clase):

    - a. (20%) Un diagrama ER básico que muestre las entidades, sus relaciones y su cardinalidad (con la notación de "patas de gallo").  
    - b. (20%) Un diagrama ER más detallado que, además de lo incluído en el diagrama del punto 1.a., muestre los atributos de las entidades, sus llaves primarias y sus llaves foráneas.

2. Un archivo `.sql` con:

    - a. (20%) Los comandos SQL para crear las tablas que implementan en PostgreSQL el diseño del punto 1.  
    - b. (20%) Los comandos SQL para insertar, al menos:
        - 10 películas.
        - 2 actores para cada película.
        - 3 estudios y 2 películas para cada estudio.
        - 2 reseñas para cada película.
    - c. (20%) Los comandos SQL, y sus resultados, para consultar:
        - Los nombres de los actores de una película, especificada por su nombre (ej. nombres de los actores de "Lo que el viento se llevó").
        - Los nombres de las películas estrenadas en un rango de fechas (ej. películas estrenadas entre el 2022-01-01) y el 2023-01-01.
        - Los nombres de las películas en las que ha actúa un actor, especificado por su nombre (ej. nombres de las películas en las que actúa "Clint Eastwood").
        - Lista de nombres de películas y promedio de calificación de sus reseñas, ordenadas descendentemente por el promedio de calificación (e.j. "Oppenheimer" - 9.2, "Indiana Jones 5" - 7.5, "" - "No Hard Feelings" - 5.5, ...).

        Incluya los resultados obtenidos en cada consulta SQL.