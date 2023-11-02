# PostGIS - Índices espaciales

## Introducción
Los índices hacen posible el uso de grandes conjuntos de datos en una base de datos espacial. Sin índices, cualquier consulta requeriría de un recorrido secuencial de cada uno de los registros de la base de datos. Los índices aceleran las búsquedas al organizar los datos en un árbol de búsqueda que se puede recorrer rápidamente para encontrar un registro en particular.

## Comandos SQL para manejo de índices

### CREATE INDEX
En SQL, un índice se crea con el comando [CREATE INDEX](https://www.w3schools.com/sql/sql_create_index.asp).

#### Sintaxis básica
```sql
CREATE INDEX nombre_índice
ON tabla
USING GIST(columna_geometría);
```

#### Ejemplos
```sql
-- Creación de un índice espacial para la tabla provincias
CREATE INDEX provincias_geom_idx
ON provincias
USING GIST(geom);
```

### DROP INDEX
Un índice se borra con el comando [DROP INDEX](https://www.w3schools.com/sql/sql_drop_index.asp).

#### Sintaxis básica
```sql
DROP INDEX nombre_índice;
```

#### Ejemplos
```sql
-- Borrado de un índice espacial
DROP INDEX provincias_geom_idx;
```

### ANALYZE
El comando [ANALYZE](https://www.postgresql.org/docs/current/sql-analyze.html) recolecta estadísticas sobre una base de datos, las cuales son utilizadas por el planificador de consultas de PostgreSQL para elegir los métodos más eficientes de acceso a los datos.

Cuando se ejecuta el comando `ANALYZE`, PostgreSQL examina las columnas de las tablas y calcula estadísticas como el número de filas, la distribución de los valores dentro de cada columna y la frecuencia de los valores, entre otras. Estas estadísticas son almacenadas en el catálogo de sistema de PostgreSQL y son esenciales para que el [optimizador de consultas](https://www.postgresql.org/docs/current/planner-optimizer.html) tome decisiones informadas.

Por ejemplo, si el optimizador sabe que una columna tiene una distribución uniforme de valores, podría decidir utilizar un índice para filtrar los datos. Por otro lado, si una columna tiene muchos valores duplicados, el optimizador podría decidir que es más eficiente realizar un recorrido secuencial.

`ANALYZE` se ejecuta de forma periódica y automática, pero también puede ser ejecutado manualmente si se ha realizado una gran cantidad de cambios en la base de datos y se desea que el optimizador de consultas cuente con estadísticas actualizadas.

#### Sintaxis básica
```sql
-- Análisis de toda la base de datos
ANALYZE;

-- Análisis de una tabla
ANALYZE tabla;

-- Análisis de columnas específicas de una tabla
ANALYZE tabla (columna1, columna2, ...);
```

#### Ejemplos
```sql
-- Análisis de la tabla de red vial
ANALYZE red_vial;
```

### VACUUM
El comando [VACUUM](https://www.postgresql.org/docs/current/sql-vacuum.html) se utiliza para recuperar el espacio no utilizado por las filas eliminadas o actualizadas y para optimizar el rendimiento de la base de datos. 

PostgreSQL utiliza un mecanismo conocido como MVCC (Control de Concurrencia MultiVersión), lo que significa que cuando una fila es actualizada o eliminada, la versión antigua de la fila no se elimina inmediatamente del disco. Esto permite que las transacciones que empezaron antes de que la fila fuera modificada puedan seguir viendo la versión antigua. Con el tiempo, esto puede llevar a una acumulación de filas "muertas" que ya no son accesibles por ninguna transacción actual, desperdiciando espacio y potencialmente ralentizando las operaciones de la base de datos. `VACUUM` "aspira" las filas obsoletas para recuperar espacio en disco y hacerlo disponible para su reutilización. 

`VACUUM` y `ANALYZE` pueden ejecutarse por separado, según sea necesario. Sin embargo, `VACUUM` no actualizará las estadísticas de la base de datos; del mismo modo, `ANALYZE` no recuperará las filas no utilizadas de una tabla. Ambos comandos se pueden ejecutar en toda la base de datos, en una sola tabla o en una sola columna.

#### Sintaxis básica
```sql
-- VACUUM normal: libera el espacio ocupado por las filas muertas 
-- para que pueda ser reutilizado, pero no retorna el espacio al sistema operativo. -- Se puede ejecutar incluso mientras la base de datos está en uso.
VACUUM;

-- VACUUM completo: no solo recupera el espacio en la base de datos, 
-- sino que también devuelve el espacio no utilizado al sistema operativo. 
-- Este comando bloquea la tabla mientras se está ejecutando, por lo que puede no
-- ser adecuado durante períodos de alta actividad.
VACUUM FULL;

-- VACUUM y ANALYZE juntos
VACUUM ANALYZE;
VACUUM ANALYZE tabla;
```

#### Ejemplos
```sql
-- Análisis y aspirado de la tabla provincias
VACUUM ANALYZE provincias;
```

PostgreSQL cuenta con un proceso automatizado llamado [autovacuum](https://www.postgresql.org/docs/current/runtime-config-autovacuum.html), que ejecuta `VACUUM` y `ANALYZE` periódicamente en un intento de mantener la base de datos funcionando de manera eficiente sin intervención manual.

## Ejercicios
1. Ejecute nuevamente las consultas para calcular riqueza de especies y densidad de la red vial y mida el tiempo de ejecución (puede verse en la parte inferior de la ventana de PgAdmin).
2. Cree índices espaciales para las tablas.
3. Ejecute el comando `VACUUM ANALYZE` en las tablas involucradas en las consultas.
4. Ejecute una vez más las consultas y compare los tiempos de ejecución.