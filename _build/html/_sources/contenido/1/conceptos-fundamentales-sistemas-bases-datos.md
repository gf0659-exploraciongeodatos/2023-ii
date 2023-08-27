# Conceptos fundamentales sobre sistemas de base de datos
Un sistema de base de datos es básicamente un sistema computarizado para mantener registros. Su propósito general es almacenar datos y permitir a los usuarios recuperar y modificar esos datos de acuerdo con sus solicitudes {cite:p}`date_introduction_2003`. A la colección de datos del sistema se le denomina base de datos.

## Ventajas
Anteriormente, se acostumbraba manejar los datos por medio de archivos (ej. CSV, DBF, SHP), lo que provocaba varios inconvenientes {cite:p}`silberschatz_database_2019`:

- **Redundancia e inconsistencia de datos**: los mismos datos podrían almacenarse en diferentes archivos, lo que puede dar lugar a inconsistencias (ej. el nombre de una misma persona escrito de varias formas).
- **Dificultades para acceder a los datos**: necesidad de desarrollar un nuevo programa para cada nueva tarea.
- **Aislamiento (*isolation*) de datos**: al existir múltiples archivos, también pueden existir múltiples formatos, lo que dificulta más el acceso.
- **Problemas de integridad**: las restricciones de integridad (ej. edad > 0) debían implementarse en los programas, al no ser posible hacerlo en los archivos.
- **Falta de "atomicidad" de las modificaciones**: algunas fallas podrían dejar los datos en un estado inconsistente (ej. las transferencias de fondos entre cuentas deben realizarse completamente o no realizarse del todo).
- **Dificultades para acceso concurrente**: el acceso por múltiples usuarios era imposible de implementar o daba lugar a inconsistencias (ej. varios usuarios que retiraban dinero de una cuenta con fondos insuficientes para todos).
- **Problemas de seguridad**: cada usuario debería tener acceso a los datos relacionados con sus tareas, pero no necesariamente a la todos.

Estas dificultades, entre otras, propiciaron el inicio del desarrollo de los sistemas de bases de datos, en las décadas de 1960 y 1970, los cuales ofrecieron soluciones a todos los problemas mencionados.

Los sistemas de bases de datos ofrecen diversos beneficios. Uno de los más importantes es el de la independencia (física) de los datos. Podemos definir la independencia de los datos como la "inmunidad" que tienen los programas de aplicación ante los cambios en la forma almacenar o acceder físicamente a los datos. Entre otras cosas, la independencia de los datos requiere que se haga una clara distinción entre el modelo de datos y su implementación {cite:p}`date_introduction_2003`.

## Componentes
La {numref}`figure-sistema-base-datos` muestra una imagen simplificada de un sistema de base de datos y sus cuatro componentes principales: **datos**, **hardware**, **software** y **usuarios**. Este curso trata principalmente sobre los componentes de datos y software.

```{figure} img/sistema-base-datos.png
:name: figure-sistema-base-datos

Imagen simplificada de un sistema de base de datos {cite:p}`date_introduction_2003`.
```

### Software
El software más importante de un sistema de base de datos es el **sistema administrador de bases de datos (SABD o DBMS por sus siglas en inglés)**, el cual maneja todos los accesos a la base de datos. Es una aplicación de propósito general que facilita los procesos de definición, construcción, manipulación y compartición de bases de datos entre varios usuarios y aplicaciones {cite:p}`elmasri_fundamentals_2015`. 

- **Definir** una base de datos implica especificar los tipos de datos, estructuras y restricciones de los datos que se almacenarán en la base de datos. La definición de la base de datos o la información descriptiva también es almacenada por el DBMS en forma de un catálogo de base de datos o diccionario; esto se llama metadatos. 
- **Construir** la base de datos es el proceso de almacenar los datos en algún medio de almacenamiento que está controlado por el SABD. 
- **Manipular** una base de datos incluye funciones como consultar la base de datos para recuperar datos específicos, actualizar la base de datos para reflejar cambios y generar informes a partir de los datos. 
- **Compartir** una base de datos permite que múltiples usuarios y programas accedan a la base de datos simultáneamente.

### Datos
Como se mencionó, a la colección de datos de un sistema de base de datos es a lo que se denomina como una base de datos (BD). Los datos de una BD se caracterizan por ser:

- **Integrados**: Una BD puede verse como una integración de varios conjuntos de datos que, de otra manera, serían independientes.
- **Compartidos**: Los datos pueden ser accedidos por diferentes usuarios al mismo tiempo, cada uno con diferentes derechos de acceso.

## Ejercicios
Debe crear una BD para mantener la información sobre cursos matriculados por los estudiantes de una universidad, en tres conjuntos de datos:

- Estudiante: carné, nombre, sexo, edad.
- Curso: sigla, nombre, unidad académica, cupo.
- Matricula: carné, sigla.

Esta BD debe permitir responder a preguntas como:

- ¿Cuántos estudiantes son hombres o mujeres?
- ¿Cuáles son los cursos impartidos por una unidad académica?
- ¿Quienes son los estudiantes matriculados en un curso determinado?

La BD debe manejar la consistencia e integridad de los datos. Por ejemplo:

- No debe permitir que haya más de un estudiante con el mismo carné o más de un curso con la misma sigla.
- No debe permitir la matrícula de cursos o estudiantes que no hayan sido registrados.
- Debe implementar restricciones de integridad para elementos de datos específicos (ej. edad >=0, cupo >= 0, sexo = (H, M)).

Ejecute los siguientes pasos:

1. Cree una BD [SpatiaLite](https://www.gaia-gis.it/fossil/libspatialite/) en el sistema de información geográfica [QGIS](https://qgis.org/) y llámela `universidad` (puede hacerlo con el Navegador de QGIS).
2. En una interfaz para el [lenguage de consulta estructurada SQL](https://es.wikipedia.org/wiki/SQL) (en el Navegador o en el Administrador de bases de datos de QGIS), cree las tablas con las siguientes sentencias [CREATE TABLE](https://www.w3schools.com/sql/sql_create_table.asp):

```sql
-- Creación de la tabla Estudiante
CREATE TABLE Estudiante (
    carne TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    sexo TEXT CHECK (sexo IN ('H', 'M')),
    edad INTEGER CHECK (edad >= 0)
);

-- Creación de la tabla Curso
CREATE TABLE Curso (
    sigla TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    unidad_academica TEXT,
    cupo INTEGER CHECK (cupo >= 0)
);

-- Creación de la tabla Matricula
CREATE TABLE Matricula (
    carne TEXT,
    sigla TEXT,
    PRIMARY KEY (carne, sigla),
    FOREIGN KEY (carne) REFERENCES Estudiante(carne),
    FOREIGN KEY (sigla) REFERENCES Curso(sigla)
);
```

3. Inserte datos en las tres tablas con las siguientes sentencias [INSERT INTO](https://www.w3schools.com/sql/sql_insert.asp):

```sql
-- Inserción de datos en la tabla Estudiante
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1001', 'Juan Pérez', 'H', 20);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1002', 'María González', 'M', 21);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1003', 'Carlos Ramírez', 'H', 22);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1004', 'Luisa Fernández', 'M', 20);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1005', 'Antonio Morales', 'H', 23);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1006', 'Lucía Torres', 'M', 21);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1007', 'Miguel Rodríguez', 'H', 24);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1008', 'Sofía Ramírez', 'M', 20);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1009', 'José Antonio López', 'H', 25);
INSERT INTO Estudiante (carne, nombre, sexo, edad) VALUES ('E1010', 'Ana María Martínez', 'M', 22);

-- Inserción de datos en la tabla Curso
INSERT INTO Curso (sigla, nombre, unidad_academica, cupo) VALUES ('MAT101', 'Matemáticas Básicas', 'Ciencias Exactas', 30);
INSERT INTO Curso (sigla, nombre, unidad_academica, cupo) VALUES ('LIT102', 'Literatura Española', 'Humanidades', 25);
INSERT INTO Curso (sigla, nombre, unidad_academica, cupo) VALUES ('BIO103', 'Biología General', 'Ciencias Naturales', 20);

-- Inserción de datos en la tabla Matricula
INSERT INTO Matricula (carne, sigla) VALUES ('E1001', 'MAT101');
INSERT INTO Matricula (carne, sigla) VALUES ('E1002', 'MAT101');
INSERT INTO Matricula (carne, sigla) VALUES ('E1003', 'LIT102');
INSERT INTO Matricula (carne, sigla) VALUES ('E1004', 'LIT102');
INSERT INTO Matricula (carne, sigla) VALUES ('E1005', 'BIO103');
INSERT INTO Matricula (carne, sigla) VALUES ('E1006', 'BIO103');
INSERT INTO Matricula (carne, sigla) VALUES ('E1007', 'MAT101');
INSERT INTO Matricula (carne, sigla) VALUES ('E1007', 'BIO103');
INSERT INTO Matricula (carne, sigla) VALUES ('E1008', 'LIT102');
```

4. Consulte la BD con las siguientes sentencias [SELECT](https://www.w3schools.com/sql/sql_select.asp) y sus cláusulas [WHERE](https://www.w3schools.com/sql/sql_where.asp) y [JOIN](https://www.w3schools.com/sql/sql_join.asp):

```sql
-- Cursos
SELECT * 
FROM Curso;

-- Estudiantes mujeres
SELECT * 
FROM Estudiante 
WHERE sexo = 'M';

-- Nombre y edad de las estudiantes mujeres
SELECT nombre, edad 
FROM Estudiante 
WHERE sexo = 'H';

-- Estudiantes mujeres mayores de 20 años
SELECT * 
FROM Estudiante 
WHERE sexo = 'M' AND edad > 20;

-- Cantidad de estudiantes hombres
SELECT COUNT(*) 
FROM Estudiante 
WHERE sexo = 'H';

-- Estudiantes matriculados en el curso LIT102
SELECT Estudiante.*
FROM Estudiante
JOIN Matricula ON Estudiante.carne = Matricula.carne
WHERE Matricula.sigla = 'LIT102';
```

5. Ejecute consultas SQL para responder a las siguientes preguntas:

    5.1. Cursos con cupo mayor o igual a 25.  
    5.2. Estudiantes mujeres matriculadas en el curso BIO103.  
    5.3. Estudiantes (hombres y mujeres) mayores de 21 años matriculados en el curso LIT102.
    
6. Ejecute las siguientes modificaciones a los datos:

    6.1. Ingrese tres nuevos estudiantes y un nuevo curso. Matricule a los estudiantes en ese curso.  
    6.2. Trate de ingresar un estudiante con edad negativa.  
    6.3. Trate de ingresar un curso con una sigla asignada a otro curso.  
    6.4. Trate de matricular un estudiante en un curso que no existe.  

## SABD más populares
Hay una gran variedad de SABD. En las siguientes tablas, se detallan algunos de los más populares.

<style>
    table {
        border-collapse: collapse;
        width: 100%;
    }
    
    table, th, td {
        border: 1px solid black;
    }
    
    th, td {
        padding: 8px 12px;
        text-align: left;
    }

    th {
        background-color: #f2f2f2;
    }
</style>

### SABD relacionales
<table>
    <thead>
        <tr>
            <th>SABD</th>
            <th>Desarrollador</th>
            <th>Licencia</th>
            <th>Sitio web</th>
            <th>Descripción</th>
            <th>Soporte para datos espaciales</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Oracle Database</td>
            <td>Oracle Corporation</td>
            <td>Comercial</td>
            <td><a href="https://www.oracle.com/database/">https://www.oracle.com/database/</a></td>
            <td>Es el SABD más popular.</td>
            <td>Sí</td>
        </tr>
        <tr>
            <td>MySQL</td>
            <td>Oracle Corporation</td>
            <td>Libre/comercial</td>
            <td><a href="http://www.mysql.com/">http://www.mysql.com/</a></td>
            <td>Es el SABD de código abierto más popular.</td>
            <td>Sí</td>
        </tr>
        <tr>
            <td>Microsoft SQL Server</td>
            <td>Microsoft</td>
            <td>Comercial</td>
            <td><a href="http://www.microsoft.com/sql/">http://www.microsoft.com/sql/</a></td>
            <td>Es el principal motor de bases de datos de Microsoft.</td>
            <td>Sí</td>
        </tr>      
        <tr>
            <td>PostgreSQL</td>
            <td>PostgreSQL Global Development Group</td>
            <td>Libre</td>
            <td><a href="https://www.postgresql.org/">https://www.postgresql.org/</a></td>
            <td>Muchos consideran que es el SABD libre con mejor soporte para datos espaciales.</td>
            <td>Sí</td>
        </tr>   
        <tr>
            <td>IBM Db2</td>
            <td>IBM</td>
            <td>Comercial</td>
            <td><a href="https://www.ibm.com/products/db2-database">https://www.ibm.com/products/db2-database</a></td>
            <td>Es una familia de productos de bases de datos de IBM.</td>
            <td>Sí</td>
        </tr>                  
        <tr>
            <td>SQLite</td>
            <td>Dwayne Richard Hipp</td>
            <td>Libre</td>
            <td><a href="https://sqlite.org/">https://sqlite.org/</a></td>
            <td>Es una biblioteca en C que implementa un DBMS relacional ligero. Es ampliamente utilizado en aplicaciones móviles y de escritorio debido a su pequeño tamaño y características de autocontención.</td>
            <td>Sí</td>
        </tr>    
        <tr>
            <td>MariaDB</td>
            <td>MariaDB Foundation</td>
            <td>Libre</td>
            <td><a href="https://mariadb.org/">https://mariadb.org/</a></td>
            <td>Surgió a raíz de la compra de Sun Microsystems (compañía que había comprado previamente MySQL)  por parte de Oracle. Es una bifurcación directa de MySQL que asegura la existencia de una versión de este producto con [licencia GPL](https://es.wikipedia.org/wiki/GNU_General_Public_License).</td>
            <td>Sí</td>
        </tr>                                    
    </tbody>
</table>

### SABD no relacionales (NoSQL)
<table>
    <thead>
        <tr>
            <th>SABD</th>
            <th>Desarrollador</th>
            <th>Licencia</th>
            <th>Sitio web</th>
            <th>Descripción</th>
            <th>Soporte para datos espaciales</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>MongoDB</td>
            <td>MongoDB Inc.</td>
            <td>Libre</td>
            <td><a href="http://www.mongodb.org/">http://www.mongodb.org/</a></td>
            <td>Está orientado a documentos: en lugar de guardar los datos en tablas, lo hace en estructuras de datos BSON (una especificación similar a JSON) con un esquema dinámico, haciendo que la integración de los datos en ciertas aplicaciones sea más fácil y rápida.</td>
            <td>Sí</td>
        </tr>
        <tr>
            <td>Redis</td>
            <td>Salvatore Sanfilippo</td>
            <td>Libre</td>
            <td><a href="http://redis.io/">http://redis.io/</a></td>
            <td>Funciona en memoria, por lo que es muy rápido.</td>
            <td>Sí</td>
        </tr>
        <tr>
            <td>Apache Cassandra</td>
            <td>Apache Software Foundation</td>
            <td>Libre</td>
            <td><a href="https://cassandra.apache.org/">https://cassandra.apache.org/</a></td>
            <td>Utiliza un modelo orientado a columnas. Puede manejar grandes volúmenes de datos de forma distribuida.</td>
            <td>No</td>
        </tr>          
    </tbody>
</table>
  
<p>

Puede encontrar más información sobre SABD y su popularidad en el sitio [DB-Engines Ranking](https://db-engines.com/en/ranking).

## Ejercicios
En los siguientes ejercicios, debe instalar el SABD [PostgreSQL](https://www.postgresql.org/), crear una BD, cargar datos de archivos CSV y ejecutar consultas en SQL.

### Instalación de PostgreSQL
1. Descargue e instale el SABD [PostgreSQL](https://www.postgresql.org/). Recuerde o anote la clave y el puerto (ej. 5432) que se solicitan.

### Carga de datos y consultas SQL (1)
1. Con PgAdmin, cree la BD `universidad`. 
2. En PgAdmin, ejecute los comandos SQL del bloque anterior.
3. Con el Navegador de QGIS, cree una conexión a la BD.
4. En QGIS, ejecute algunos comandos SQL para insertar cursos, estudiantes, matricularlos y consultarlos.

### Carga de datos y consultas SQL (2)
1. Descargue el archivo CSV con datos de ciudades disponible en [World Cities Database](https://simplemaps.com/data/world-cities).
2. En QGIS, con el Administrador de fuentes de datos - Texto delimitado, cargue el archivo CSV.
3. Con PgAdmin, cree una BD PostgreSQL llamada `ciudades`.
4. En QGIS, cree una conexión a `ciudades`.
5. En QGIS, con el Administrador de bases de datos, cargue en `ciudades` los datos de ciudades provenientes de los archivos CSV.
6. En PgAdmin, ejecute consultas SQL para obtener:
    - Lista de ciudades de Costa Rica.
    - Lista de ciudades con más de 10 millones de habitantes.
    - Lista de países en la base de datos (sugerencia: use la palabra clave [`DISTINCT`](https://www.w3schools.com/sql/sql_distinct.asp)).
    - Cantidad de ciudades de Costa Rica (sugerencia: use la función [`COUNT()`](https://www.w3schools.com/sql/sql_count_avg_sum.asp)).    
    - Población total de las ciudades de Costa Rica (sugerencia: use la función [`SUM()`](https://www.w3schools.com/sql/sql_count_avg_sum.asp)).
    - Población promedio de las ciudades de Costa Rica (sugerencia: use la función [`AVG()`](https://www.w3schools.com/sql/sql_count_avg_sum.asp)).
    - La ciudad con mayor población y la ciudad con menor población en la base de datos (sugerencia: use la cláusula [`ORDER BY`](https://www.w3schools.com/sql/sql_orderby.asp)).

### Carga de datos y consultas SQL (3)
1. Descargue los los archivos XLSX con datos de estadísticas policiales del Organismo de Investigación Judicial (OIJ) de los años 2018-2023 disponibles en [Datos abiertos del OIJ](https://sitiooij.poder-judicial.go.cr/index.php/ayuda/servicios-policiales/servicios-a-organizaciones/indice-de-transparencia-del-sector-publico-costarricense/datos-abiertos) y conviértalos al formato CSV (para esto, puede usar una aplicación de hoja de cálculo como Calc o Excel). También puede encontrar los archivos ya exportados al formato CSV en [https://github.com/gf0659-exploraciongeodatos/2023-ii/tree/main/datos/oij/estadisticas-policiales/csv](https://github.com/gf0659-exploraciongeodatos/2023-ii/tree/main/datos/oij/estadisticas-policiales/csv).
2. En QGIS, con el Administrador de fuentes de datos - Texto delimitado, cargue cada uno de los archivos CSV como una capa (no espacial). Especifique `Texto (cadena)` como el tipo de datos de todos los campos.
3. En cada capa, con la Calculadora de campos de QGIS, cree las siguientes columnas:
    - `Fecha_Date` (tipo `Date`) = `to_date("Fecha", format('MM/dd/yyyy'))` o `to_date("Fecha", format('yyyy-MM-dd'))`. Esta columna es una transformación de `Fecha` (tipo `Texto (cadena)`) al tipo `Date`. El argumento de `format()` depende del orden que presenten el día, el mes y el año en el campo `Fecha`, así como del separador (ej. `/`, `-`).
    - `Anio` = `year("Fecha_Date")` (tipo `Entero (32 bits)`). Esta columna es para separar el año contenido en `Fecha_Date`.
    - `Mes` = `month("Fecha_Date")` (tipo `Entero (32 bits)`). Esta columna es para separar el mes contenido en `Fecha_Date`.
4. Con PgAdmin, cree una BD PostgreSQL llamada `oij`.    
5. En QGIS, cree una conexión a `oij`.    
6. En QGIS, con el Administrador de bases de datos, importe en `oij` las capas con las estadísticas anuales. Cree una tabla para cada año.
7. En PgAdmin, con la sentencia [`CREATE TABLE`](https://www.w3schools.com/sql/sql_create_table.asp) y el operador [`UNION`](https://www.w3schools.com/sql/sql_union.asp), cree una tabla que una los datos de todas las tablas de estadísticas anuales:

```sql
-- Creación de tabla con unión de datos de tablas de estadísticas anuales
CREATE TABLE oij AS
SELECT * FROM oij23
UNION
SELECT * FROM oij22;
```
8. Con la cláusula [`GROUP BY`](https://www.w3schools.com/sql/sql_groupby.asp), agrupe y cuente los homicidios cometidos por mes y año:

```sql
-- Agrupación de cantidad de homicidios por mes y año
SELECT "Mes", "Anio", COUNT(*)
FROM oij
WHERE "SubDelito" = 'HOMICIDIO'
GROUP BY "Mes", "Anio"
ORDER BY "Mes", "Anio";
```

## Bibliografía
```{bibliography}
:filter: docname in docnames
```
