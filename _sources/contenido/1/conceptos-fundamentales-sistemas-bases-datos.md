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
Como se mencionó, a la colección de datos de un sistema de base de datos es a lo que se denomina como una base de datos. Los datos de una base de datos se caracterizan por ser:

- Integrados: Una base de datos puede verse como una integración de varios archivos (i.e. conjuntos de datos) que, de otra manera, serían independientes.
- Compartidos: Los datos pueden ser accedidos por diferentes usuarios al mismo tiempo, cada uno con diferentes derechos de acceso.

## Ejercicios
Cree una base de datos para mantener la información sobre cursos matriculados por los estudiantes de una universidad. La base de datos debe tener tres conjuntos de datos:

- Estudiante: carné, nombre, sexo, edad.
- Curso: sigla, nombre, unidad académica, cupo.
- Matricula: carné, sigla.

Esta base de datos debe permitir responder a preguntas como:

- ¿Cuántos estudiantes son hombres o mujeres?
- ¿Cuáles son los cursos impartidos por una unidad académica?
- ¿Quienes son los estudiantes matriculados en un curso determinado?

La base de datos debe manejar la consistencia e integridad de los datos. Por ejemplo:

- No debe permitir que haya más de un estudiante con el mismo carné o más de un curso con la misma sigla.
- No debe permitir la matrícula de cursos o estudiantes que no hayan sido registrados.
- Debe implementar restricciones de integridad para elementos de datos específicos (ej. edad >=0, cupo >= 0, sexo = (H, M)).

Ejecute los siguientes pasos:

1. Cree una base de datos [SpatiaLite](https://www.gaia-gis.it/fossil/libspatialite/) en el sistema de información geográfica [QGIS](https://qgis.org/) y llámela "universidad" (puede hacerlo con el Navegador de QGIS).
2. En una interfaz para el [lenguage de consulta estructurada SQL](https://es.wikipedia.org/wiki/SQL) (en el Navegador o en el Administrador de Bases de Datos de QGIS), cree las tablas con las siguientes sentencias:

```sql
-- Crear la tabla Estudiante
CREATE TABLE Estudiante (
    carne TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    sexo TEXT CHECK (sexo IN ('H', 'M')),
    edad INTEGER CHECK (edad >= 0)
);

-- Crear la tabla Curso
CREATE TABLE Curso (
    sigla TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    unidad_academica TEXT,
    cupo INTEGER CHECK (cupo >= 0)
);

-- Crear la tabla Matricula
CREATE TABLE Matricula (
    carne TEXT,
    sigla TEXT,
    PRIMARY KEY (carne, sigla),
    FOREIGN KEY (carne) REFERENCES Estudiante(carne),
    FOREIGN KEY (sigla) REFERENCES Curso(sigla)
);
```

3. Inserte datos en las tres tablas:

```sql
-- Insertar datos en la tabla Estudiante
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

-- Insertar datos en la tabla Curso
INSERT INTO Curso (sigla, nombre, unidad_academica, cupo) VALUES ('MAT101', 'Matemáticas Básicas', 'Ciencias Exactas', 30);
INSERT INTO Curso (sigla, nombre, unidad_academica, cupo) VALUES ('LIT102', 'Literatura Española', 'Humanidades', 25);
INSERT INTO Curso (sigla, nombre, unidad_academica, cupo) VALUES ('BIO103', 'Biología General', 'Ciencias Naturales', 20);

-- Insertar datos en la tabla Matricula
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

4. Ejecute las siguientes consultas a la base de datos:

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

## Bibliografía
```{bibliography}
:filter: docname in docnames
```
