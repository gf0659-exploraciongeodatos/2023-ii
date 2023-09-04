# Introducción a SQL

## Introducción
SQL es el lenguaje de consulta de bases de datos más utilizado.

IBM desarrolló la versión original de SQL, originalmente llamada SEQUEL (*Structured English QUEry Language*), como parte del proyecto System R a principios de la década de 1970. Algunos años después, SEQUEL cambió su nombre a SQL (*Structured Query Language* o Lenguaje de Consulta Estructurada) y se consolidó como el lenguaje estándar de bases de datos relacionales.

SQL pasó a ser un estándar del Instituto Nacional Estadounidense de Estándares (ANSI) en 1986 y de la Organización Internacional de Normalización (ISO) en 1987. Esta primera versión es conocida como SQL-86 o SQL-1. En 1992 se publicó una revisión ampliada y revisada del estándar, llamada [SQL-92 o SQL-2](https://es.wikipedia.org/wiki/SQL-92). El soporte a SQL-92 por parte de las implementaciones comerciales es muy amplio. El estándar ha sido revisado varias veces más para incluir características adicionales. La revisión más reciente es [SQL:2023](https://en.wikipedia.org/wiki/SQL:2023) y fue adoptada en junio 2023. A pesar de su estandarización, la mayoría de las implementaciones de SQL no son completamente portables entre sistemas administradores de bases de datos.  

La funcionalidad del lenguaje SQL incluye {cite:p}`silberschatz_database_2019`:

- **Lenguaje de definición de datos (DDL, por sus siglas en inglés)**. Proporciona comandos para crear, modificar y borrar tablas.

- **Lenguaje de manipulación de datos (DML, por sus siglas en inglés)**. Permite consultar la información de una base de datos, así como insertar, modificar y borrar registros.

- **Integridad**. El SQL DDL incluye comandos para especificar restricciones de integridad (ej. llaves primarias, llaves foráneas, manejo de valores nulos).

- **Definición de vistas**. Una vista (*view*) es una consulta almacenada que puede tratarse como una tabla.

- **Control de transacciones**. Comandos para definicar el inicio y el final de transacciones.

- **SQL incrustado y SQL dinámico**. Define como las sentencias SQL pueden incrustarse en lenguajes de programación (ej. C, Java, R, Python).

- **Autorización**. Derechos de acceso a tablas y vistas.

En este capítulo, se presentan los principales comandos de SQL DDL y SQL DML, con algunos ejemplos relacionados con la base de datos `university`, introducida en el capítulo anterior. Para más detalles sobre SQL y su sintaxis, se recomienda consultar [Database System Concepts (Chapter 3)](https://www.db-book.com/slides-dir/PDF-dir/ch3.pdf) o [W3Schools - SQL Tutorial](https://www.w3schools.com/sql/). Se recomienda también ejcutar las sentencias SQL en una base de datos real.

## SQL DDL
SQL DDL permite especificar, para una tabla, aspectos como su esquema, tipos de datos de los atributos y restricciones de integridad. También índices, información de seguridad y estructura física de almacenamiento en el disco.

### Tipos de datos básicos
El estándar SQL admiite varios tipos de datos, incluyendo {cite:p}`silberschatz_database_2019`:

- **char**(*n*), **character**(*n*): cadena de caracteres de longitud fija *n* especificada por el usuario.
- **varchar**(*n*), **character varying**(*n*): cadena de caracteres de longitud fija *n* especificada por el usuario.
- **int**, **integer**: número entero de tamaño máximo dependiente de la arquitectura de la computadora.
- **smallint**: número entero pequeño de tamaño máximo dependiente de la arquitectura de la computadora.
- **numeric**(*p*,*d*): número de punto fijo[^1] con precisión especificada por el usuario. El número consta de *p* dígitos (más un signo) y *d* de los *p* dígitos están a la derecha del punto decimal. Por lo tanto, **numeric**(*3*, *1*) permite almacenar 44.5 exactamente, pero ni 444.5 ni 0.32 pueden ser almacenados exactamente en un campo de este tipo.
- **real**, **double precision**: números de punto flotante[^2] y punto flotante de doble precisión con precisión dependiente de la computadora.
- **float**(*n*): número de punto flotante con precisión de al menos *n* dígitos.

Cada tipo puede incluir un valor especial llamado el valor `null` (`nulo`). Un valor nulo indica un valor ausente que puede existir pero ser desconocido o que puede no existir en absoluto. En ciertos casos, se podría querer prohibir que se ingresen valores nulos.

### Definición de tablas
En esta sección se trabaja con las tablas de la base de datos `university`, como ejemplo. Se recomienda crear la base de datos en un SABD y reproducir los comandos.


#### CREATE TABLE
En SQL, una tabla se define con la sentencia [CREATE TABLE](https://www.w3schools.com/sql/sql_create_table.asp), en la que se especifican los nombres de las columnas juntos con sus tipos de datos. También pueden especificarse restricciones de llave primaria, llaves foráneas y prohibición de valores nulos, entre otras.

##### Sintaxis básica
```sql
CREATE TABLE tabla (
    columna1 tipo_datos,
    columna2 tipo_datos NOT NULL,
    columna3 tipo_datos,
    ....,
    PRIMARY KEY(columna_llave_primaria),
    FOREIGN KEY(columna_llave_foranea) REFERENCES tabla_referenciada,
    ....
); 
```

##### Ejemplos
El siguiente comando crea la tabla `department`:

```sql
-- Creación de la tabla department
CREATE TABLE department (
    dept_name VARCHAR(20), 
    building VARCHAR(15), 
    budget NUMERIC(12,2), 
    PRIMARY KEY(dept_name)
);
```

La tabla que se crea a partir del comando anterior tiene tres columnas (`dept_name`, `building`, `budget`) y una de ellas (`dept_name`) es la llave primaria.

Los siguientes comandos crean las tablas `instructor` y `student`.

```sql
-- Creación de la tabla instructor
CREATE TABLE instructor (
    ID VARCHAR(5),
    name VARCHAR(20) NOT NULL,
    dept_name VARCHAR(20),
    salary NUMERIC(8,2),
    PRIMARY KEY(ID),
    FOREIGN KEY(dept_name) REFERENCES department
);

-- Creación de la tabla student
CREATE TABLE student (
    ID VARCHAR(5),
    name VARCHAR(20) NOT NULL,
    dept_name VARCHAR(20),
    tot_cred NUMERIC(3,0),
    PRIMARY KEY(ID),
    FOREIGN KEY(dept_name) REFERENCES department
);
```

Note las restricciones de atributos no nulos y de llaves foráneas.

Por último, los siguientes comandos crean las tablas `course`, `section`, `teaches` y `takes`.

```sql
-- Creación de la tabla course
CREATE TABLE course (
    course_id VARCHAR(8),
    title VARCHAR(50),
    dept_name VARCHAR(20),
    credits NUMERIC(2,0),
    PRIMARY KEY(course_id),
    FOREIGN KEY(dept_name) REFERENCES department
);

-- Creación de la tabla section
CREATE TABLE section (
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year NUMERIC(4,0),
    building VARCHAR(15),
    room_number VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY(course_id, sec_id, semester, year),
    FOREIGN KEY(course_id) REFERENCES course
);

-- Creación de la relación teaches
CREATE TABLE  teaches(
    ID VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year NUMERIC(4,0),
    PRIMARY KEY(ID, course_id, sec_id, semester, year),
    FOREIGN KEY(course_id, sec_id, semester, year) REFERENCES section,
    FOREIGN KEY(ID) REFERENCES instructor
);

-- Creación de la tabla takes
CREATE TABLE takes (
    ID VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year NUMERIC(4,0),
    grade NUMERIC(3,0), 
    PRIMARY KEY(ID, course_id, sec_id, semester, year) ,
    FOREIGN KEY(ID) REFERENCES  student,
    FOREIGN KEY(course_id, sec_id, semester, year) REFERENCES section
);
```

#### ALTER TABLE
La sentencia [ALTER TABLE](https://www.w3schools.com/sql/sql_alter.asp) se utiliza para agregar, modificar o borrar columnas en una tabla. También puede agregar y borrar restricciones.

Con los siguientes comandos, se crea una tabla de ejemplo y luego se agrega, modifica y borra una columna, mediante `ALTER TABLE`. También se define la llave primaria de la tabla.

##### Sintaxis básica
```sql
-- Adición de una columna
ALTER TABLE tabla
    ADD columna tipo_datos;

-- Modificación del tipo de datos de una columna (sintaxis de PostgreSQL)
ALTER TABLE tabla
    ALTER COLUMN columna TYPE tipo_datos;

-- Definición de llave primaria
ALTER TABLE tabla
    ADD PRIMARY KEY(columna1, columna2, ...);

-- Borrado de una columna
ALTER TABLE tabla
    DROP COLUMN columna;
```

##### Ejemplos
```sql
-- Creación de una tabla de ejemplo
CREATE TABLE ejemplo (
    col1 INTEGER
);

-- Adición de una columna
ALTER TABLE ejemplo
    ADD col2 NUMERIC(3,0);

-- Modificación del tipo de datos de una columna (sintaxis de PostgreSQL)
ALTER TABLE ejemplo
    ALTER COLUMN col2 TYPE INTEGER;

-- Definición de llave primaria
ALTER TABLE ejemplo
    ADD PRIMARY KEY(col1, col2);

-- Borrado de una columna
ALTER TABLE ejemplo
    DROP COLUMN col2;
```

#### DROP TABLE
La sentencia [DROP TABLE](https://www.w3schools.com/sql/sql_drop_table.asp) se utiliza para borrar una tabla.

##### Sintaxis básica
```sql
DROP TABLE tabla;
```

##### Ejemplos
```sql
-- Borrado de una tabla
DROP TABLE ejemplo;
```

## SQL DML
Los comandos de SQL DML se utilizan para manipular los datos almacenados en una base de datos. Estos comandos incluyen `INSERT`, `UPDATE`, `DELETE`, para modificar los datos, y `SELECT` para consultarlos.

### Modificación de datos

#### INSERT
El comando [INSERT](https://www.w3schools.com/sql/sql_insert.asp) inserta nuevos registros en una tabla.

##### Sintaxis básica
Se presentan dos variantes.
```sql
-- Especificación de las columnas y sus respectivos valores
INSERT INTO tabla
    (columna1, columna2, columna3, ...) 
    VALUES (valor1, valor2, valor3, ...);

-- Especificación de los valores únicamente.
-- Es útil si se usan todas las columnas.
-- Debe respetarse el orden en el que las columnas fueron definidas.
INSERT INTO tabla
    VALUES (valor1, valor2, valor3, ...);
```

##### Ejemplos
```sql
-- Inserción de un registro en la tabla department,
-- especificando las columnas y sus respectivos valores.
INSERT INTO department 
    (dept_name, building, budget) 
    VALUES ('Informática', 'Edificio A', 50000.00);

-- Inserción de un registro en la tabla department,
-- especificando solo los valores.
INSERT INTO department
    VALUES ('Matemáticas', 'Edificio B', 45000.00);    
```

Con el fin de proporcionar datos para los siguientes ejercicios, seguidamente se proporcionan comandos `INSERT` para las restantes tablas de la base de datos `university`.

<details>
    <summary>Inserción de registros en la tabla <code>instructor</code></summary>

```sql
-- Inserción de registros en la tabla instructor

INSERT INTO instructor 
    (ID, name, dept_name, salary) 
    VALUES ('I001', 'Juan Pérez', 'Informática', 35000.00);

INSERT INTO instructor 
    (ID, name, dept_name, salary) 
    VALUES ('I002', 'María García', 'Informática', 36000.00);

INSERT INTO instructor 
    (ID, name, dept_name, salary) 
    VALUES ('I003', 'Carlos Rodríguez', 'Matemáticas', 34000.00);

INSERT INTO instructor 
    (ID, name, dept_name, salary) 
    VALUES ('I004', 'Ana Torres', 'Matemáticas', 33000.00);

INSERT INTO instructor 
    (ID, name, dept_name, salary) 
    VALUES ('I005', 'Luisa Fernández', 'Informática', 35500.00);
```    
</details>

<details>
    <summary>Inserción de registros en la tabla <code>student</code></summary>

```sql
-- Inserción de registros en la tabla student

INSERT INTO student VALUES ('S001', 'Alejandro Ruiz', 'Informática', 50);
INSERT INTO student VALUES ('S002', 'Beatriz Morales', 'Informática', 52);
INSERT INTO student VALUES ('S003', 'Carlos Vargas', 'Informática', 48);
INSERT INTO student VALUES ('S004', 'Daniela Ortega', 'Informática', 55);
INSERT INTO student VALUES ('S005', 'Eduardo Paredes', 'Informática', 51);
INSERT INTO student VALUES ('S006', 'Fernanda Castillo', 'Informática', 53);
INSERT INTO student VALUES ('S007', 'Gabriel Mendoza', 'Informática', 49);
INSERT INTO student VALUES ('S008', 'Hilda Navarro', 'Informática', 54);
INSERT INTO student VALUES ('S009', 'Iván Duarte', 'Informática', 50);
INSERT INTO student VALUES ('S010', 'Jessica Alvarado', 'Informática', 52);
INSERT INTO student VALUES ('S011', 'Kevin Romero', 'Informática', 48);
INSERT INTO student VALUES ('S012', 'Liliana Pérez', 'Informática', 55);
INSERT INTO student VALUES ('S013', 'Miguel Ángel Soto', 'Informática', 51);
INSERT INTO student VALUES ('S014', 'Natalia Gómez', 'Informática', 53);
INSERT INTO student VALUES ('S015', 'Oscar Hernández', 'Informática', 49);
INSERT INTO student VALUES ('S016', 'Patricia Lugo', 'Informática', 54);
INSERT INTO student VALUES ('S017', 'Raúl Torres', 'Informática', 50);
INSERT INTO student VALUES ('S018', 'Sofía Méndez', 'Informática', 52);
INSERT INTO student VALUES ('S019', 'Tomás Cervantes', 'Informática', 48);
INSERT INTO student VALUES ('S020', 'Ursula Vázquez', 'Informática', 55);
INSERT INTO student VALUES ('S021', 'Víctor Delgado', 'Matemáticas', 50);
INSERT INTO student VALUES ('S022', 'Wendy Olvera', 'Matemáticas', 52);
INSERT INTO student VALUES ('S023', 'Ximena Ponce', 'Matemáticas', 48);
INSERT INTO student VALUES ('S024', 'Yahir Ríos', 'Matemáticas', 55);
INSERT INTO student VALUES ('S025', 'Zoe Salinas', 'Matemáticas', 51);
INSERT INTO student VALUES ('S026', 'Andrés Mora', 'Matemáticas', 53);
INSERT INTO student VALUES ('S027', 'Blanca Estela', 'Matemáticas', 49);
INSERT INTO student VALUES ('S028', 'Cecilia Rojas', 'Matemáticas', 54);
INSERT INTO student VALUES ('S029', 'Diego Lira', 'Matemáticas', 50);
INSERT INTO student VALUES ('S030', 'Elena Barrios', 'Matemáticas', 52);
INSERT INTO student VALUES ('S031', 'Roberto Silva', 'Informática', 53);
INSERT INTO student VALUES ('S032', 'Isabel Marín', 'Informática', 50);
INSERT INTO student VALUES ('S033', 'Felipe Guzmán', 'Informática', 52);
INSERT INTO student VALUES ('S034', 'Lorena Ríos', 'Informática', 55);
INSERT INTO student VALUES ('S035', 'Guillermo Paredes', 'Informática', 49);
INSERT INTO student VALUES ('S036', 'Rosa Mendoza', 'Informática', 51);
INSERT INTO student VALUES ('S037', 'Javier Castillo', 'Informática', 53);
INSERT INTO student VALUES ('S038', 'Carmen Lugo', 'Informática', 50);
INSERT INTO student VALUES ('S039', 'Luis Méndez', 'Informática', 52);
INSERT INTO student VALUES ('S040', 'Diana Herrera', 'Informática', 55);
INSERT INTO student VALUES ('S041', 'Ricardo Gómez', 'Informática', 49);
INSERT INTO student VALUES ('S042', 'Mónica Soto', 'Informática', 51);
INSERT INTO student VALUES ('S043', 'Ernesto Vázquez', 'Informática', 53);
INSERT INTO student VALUES ('S044', 'Sandra Ponce', 'Informática', 50);
INSERT INTO student VALUES ('S045', 'Alberto Cervantes', 'Informática', 52);
INSERT INTO student VALUES ('S046', 'Patricia Delgado', 'Informática', 55);
INSERT INTO student VALUES ('S047', 'Francisco Navarro', 'Informática', 49);
INSERT INTO student VALUES ('S048', 'Martha Ortega', 'Informática', 51);
INSERT INTO student VALUES ('S049', 'Gabriela Torres', 'Informática', 53);
INSERT INTO student VALUES ('S050', 'Jorge Alvarado', 'Informática', 50);
INSERT INTO student VALUES ('S051', 'Laura Romero', 'Matemáticas', 52);
INSERT INTO student VALUES ('S052', 'Ramón Duarte', 'Matemáticas', 55);
INSERT INTO student VALUES ('S053', 'Susana Olvera', 'Matemáticas', 49);
INSERT INTO student VALUES ('S054', 'Mario Paredes', 'Matemáticas', 51);
INSERT INTO student VALUES ('S055', 'Teresa Vargas', 'Matemáticas', 53);
INSERT INTO student VALUES ('S056', 'José Luis Morales', 'Matemáticas', 50);
INSERT INTO student VALUES ('S057', 'Adriana Ruiz', 'Matemáticas', 52);
INSERT INTO student VALUES ('S058', 'Pedro García', 'Matemáticas', 55);
INSERT INTO student VALUES ('S059', 'Verónica Castillo', 'Matemáticas', 49);
INSERT INTO student VALUES ('S060', 'Manuel Navarro', 'Matemáticas', 51);
```    
</details>

<details>
    <summary>Inserción de registros en la tabla <code>course</code></summary>

```sql
-- Inserción de registros en la tabla course

INSERT INTO course VALUES ('C001', 'Programación Básica', 'Informática', 4);
INSERT INTO course VALUES ('C002', 'Redes y Comunicaciones', 'Informática', 3);
INSERT INTO course VALUES ('C003', 'Bases de Datos', 'Informática', 4);
INSERT INTO course VALUES ('C004', 'Álgebra Lineal', 'Matemáticas', 4);
INSERT INTO course VALUES ('C005', 'Cálculo Diferencial', 'Matemáticas', 4);
INSERT INTO course VALUES ('C006', 'Estadística y Probabilidad', 'Matemáticas', 3);
```
</details>

<details>
    <summary>Inserción de registros en la tabla <code>section</code></summary>

```sql
-- Inserción de registros en la tabla section

INSERT INTO section VALUES ('C001', 'SEC01', 'S2', 2022, 'Edificio A', '101', 'TS01');
INSERT INTO section VALUES ('C002', 'SEC01', 'S1', 2023, 'Edificio A', '201', 'TS01');
INSERT INTO section VALUES ('C002', 'SEC02', 'S1', 2023, 'Edificio A', '202', 'TS04');
INSERT INTO section VALUES ('C003', 'SEC01', 'S1', 2022, 'Edificio C', '301', 'TS05');
INSERT INTO section VALUES ('C003', 'SEC02', 'S1', 2022, 'Edificio C', '302', 'TS06');
INSERT INTO section VALUES ('C004', 'SEC01', 'S2', 2023, 'Edificio B', '101', 'TS02');
INSERT INTO section VALUES ('C004', 'SEC02', 'S2', 2023, 'Edificio B', '102', 'TS02');
INSERT INTO section VALUES ('C005', 'SEC01', 'S1', 2022, 'Edificio B', '501', 'TS01');
INSERT INTO section VALUES ('C006', 'SEC01', 'S1', 2023, 'Edificio B', '601', 'TS07');
INSERT INTO section VALUES ('C006', 'SEC02', 'S1', 2023, 'Edificio B', '602', 'TS07');
```
</details>

<details>
    <summary>Inserción de registros en la tabla <code>teaches</code></summary>

```sql
-- Inserción de registros en la tabla teaches

INSERT INTO teaches VALUES ('I001', 'C001', 'SEC01', 'S2', 2022);
INSERT INTO teaches VALUES ('I002', 'C002', 'SEC01', 'S1', 2023);
INSERT INTO teaches VALUES ('I002', 'C002', 'SEC02', 'S1', 2023);
INSERT INTO teaches VALUES ('I003', 'C003', 'SEC01', 'S1', 2022);
INSERT INTO teaches VALUES ('I003', 'C003', 'SEC02', 'S1', 2022);
INSERT INTO teaches VALUES ('I004', 'C004', 'SEC01', 'S2', 2023);
INSERT INTO teaches VALUES ('I004', 'C004', 'SEC02', 'S2', 2023);
INSERT INTO teaches VALUES ('I005', 'C005', 'SEC01', 'S1', 2022);
INSERT INTO teaches VALUES ('I001', 'C006', 'SEC01', 'S1', 2023);
INSERT INTO teaches VALUES ('I002', 'C006', 'SEC02', 'S1', 2023);
```
</details>

<details>
    <summary>Inserción de registros en la tabla <code>takes</code></summary>

```sql
-- Inserción de registros en la tabla takes

-- Estudiantes para C001 SEC01 S2 2022
INSERT INTO takes VALUES ('S001', 'C001', 'SEC01', 'S2', 2022, 85);
INSERT INTO takes VALUES ('S002', 'C001', 'SEC01', 'S2', 2022, 78);
INSERT INTO takes VALUES ('S003', 'C001', 'SEC01', 'S2', 2022, 90);
INSERT INTO takes VALUES ('S004', 'C001', 'SEC01', 'S2', 2022, 65);
INSERT INTO takes VALUES ('S005', 'C001', 'SEC01', 'S2', 2022, 72);

-- Estudiantes para C002 SEC01 S1 2023
INSERT INTO takes VALUES ('S006', 'C002', 'SEC01', 'S1', 2023, 88);
INSERT INTO takes VALUES ('S007', 'C002', 'SEC01', 'S1', 2023, 69);
INSERT INTO takes VALUES ('S008', 'C002', 'SEC01', 'S1', 2023, 74);
INSERT INTO takes VALUES ('S001', 'C002', 'SEC01', 'S1', 2023, 82);
INSERT INTO takes VALUES ('S002', 'C002', 'SEC01', 'S1', 2023, 76);

-- Estudiantes para C002 SEC02 S1 2023
INSERT INTO takes VALUES ('S009', 'C002', 'SEC02', 'S1', 2023, 91);
INSERT INTO takes VALUES ('S010', 'C002', 'SEC02', 'S1', 2023, 67);
INSERT INTO takes VALUES ('S011', 'C002', 'SEC02', 'S1', 2023, 95);
INSERT INTO takes VALUES ('S012', 'C002', 'SEC02', 'S1', 2023, 60);
INSERT INTO takes VALUES ('S013', 'C002', 'SEC02', 'S1', 2023, 73);

-- Estudiantes para C003 SEC01 S1 2022
INSERT INTO takes VALUES ('S014', 'C003', 'SEC01', 'S1', 2022, 89);
INSERT INTO takes VALUES ('S015', 'C003', 'SEC01', 'S1', 2022, 70);
INSERT INTO takes VALUES ('S016', 'C003', 'SEC01', 'S1', 2022, 92);
INSERT INTO takes VALUES ('S003', 'C003', 'SEC01', 'S1', 2022, 64);
INSERT INTO takes VALUES ('S004', 'C003', 'SEC01', 'S1', 2022, 79);

-- Estudiantes para C003 SEC02 S1 2022
INSERT INTO takes VALUES ('S017', 'C003', 'SEC02', 'S1', 2022, 87);
INSERT INTO takes VALUES ('S018', 'C003', 'SEC02', 'S1', 2022, 68);
INSERT INTO takes VALUES ('S019', 'C003', 'SEC02', 'S1', 2022, 93);
INSERT INTO takes VALUES ('S020', 'C003', 'SEC02', 'S1', 2022, 62);
INSERT INTO takes VALUES ('S021', 'C003', 'SEC02', 'S1', 2022, 75);

-- Estudiantes para C004 SEC01 S2 2023
INSERT INTO takes VALUES ('S022', 'C004', 'SEC01', 'S2', 2023, 86);
INSERT INTO takes VALUES ('S023', 'C004', 'SEC01', 'S2', 2023, 71);
INSERT INTO takes VALUES ('S024', 'C004', 'SEC01', 'S2', 2023, 94);
INSERT INTO takes VALUES ('S005', 'C004', 'SEC01', 'S2', 2023, 63);
INSERT INTO takes VALUES ('S006', 'C004', 'SEC01', 'S2', 2023, 80);

-- Estudiantes para C004 SEC02 S2 2023
INSERT INTO takes VALUES ('S025', 'C004', 'SEC02', 'S2', 2023, 84);
INSERT INTO takes VALUES ('S026', 'C004', 'SEC02', 'S2', 2023, 66);
INSERT INTO takes VALUES ('S027', 'C004', 'SEC02', 'S2', 2023, 96);
INSERT INTO takes VALUES ('S028', 'C004', 'SEC02', 'S2', 2023, 61);
INSERT INTO takes VALUES ('S029', 'C004', 'SEC02', 'S2', 2023, 77);

-- Estudiantes para C005 SEC01 S1 2022
INSERT INTO takes VALUES ('S030', 'C005', 'SEC01', 'S1', 2022, 83);
INSERT INTO takes VALUES ('S031', 'C005', 'SEC01', 'S1', 2022, 72);
INSERT INTO takes VALUES ('S032', 'C005', 'SEC01', 'S1', 2022, 97);
INSERT INTO takes VALUES ('S007', 'C005', 'SEC01', 'S1', 2022, 59);
INSERT INTO takes VALUES ('S008', 'C005', 'SEC01', 'S1', 2022, 81);

-- Estudiantes para C006 SEC01 S1 2023
INSERT INTO takes VALUES ('S033', 'C006', 'SEC01', 'S1', 2023, 85);
INSERT INTO takes VALUES ('S034', 'C006', 'SEC01', 'S1', 2023, 73);
INSERT INTO takes VALUES ('S035', 'C006', 'SEC01', 'S1', 2023, 98);
INSERT INTO takes VALUES ('S009', 'C006', 'SEC01', 'S1', 2023, 58);
INSERT INTO takes VALUES ('S010', 'C006', 'SEC01', 'S1', 2023, 82);

-- Estudiantes para C006 SEC02 S1 2023
INSERT INTO takes VALUES ('S036', 'C006', 'SEC02', 'S1', 2023, 82);
INSERT INTO takes VALUES ('S037', 'C006', 'SEC02', 'S1', 2023, 74);
INSERT INTO takes VALUES ('S038', 'C006', 'SEC02', 'S1', 2023, 99);
INSERT INTO takes VALUES ('S039', 'C006', 'SEC02', 'S1', 2023, 57);
INSERT INTO takes VALUES ('S040', 'C006', 'SEC02', 'S1', 2023, 76);
```
</details>

#### UPDATE
El comando [UPDATE](https://www.w3schools.com/sql/sql_update.asp) modifica registros de una tabla.

##### Sintaxis básica
```sql
UPDATE tabla
    SET columna1 = valor1, columna2 = valor2, ...
    WHERE condición; 
```

##### Ejemplos
```sql
-- Aumento de un 5% a los salarios de todos los profesores
UPDATE instructor
    SET salary = salary * 1.05;

-- Aumento de un 5% de los salarios de los profesores
-- con salarios menores a 35000
UPDATE instructor
    SET salary = salary * 1.05
    WHERE salary < 35000;

-- Aumento de un 5% de los salarios de los profesores
-- con salarios menores al promedio de todos los salarios.
-- Se utiliza una subconsulta.
UPDATE instructor
    SET salary = salary * 1.05
    WHERE salary < (SELECT AVG(salary) FROM instructor);
```

#### DELETE
El comando [DELETE](https://www.w3schools.com/sql/sql_delete.asp) borra registros de una tabla.

##### Sintaxis básica
```sql
DELETE FROM tabla WHERE condición; 
```

##### Ejemplos
```sql
-- Borrado de un estudiante por ID
DELETE FROM student WHERE ID = 'S060';
```

## Ejercicios
1. Agregue registros de prueba en las tablas de la base de datos `university` de acuerdo con los siguientes pasos.  
    1. Agregue el departamento 'Geografía' en la tabla `department`.  
    2. Agregue el estudiante 'Alexander von Humboldt' en la tabla `student`. Asígnelo al departamento de Geografía.  
    3. Agregue el profesor 'Eratóstenes' en la tabla `instructor`. Asígnelo al departamento de Geografía.  
    4. Agregue el curso 'Fundamentos de la Geodesia' en la tabla `course`. Asígnelo al departamento de Geografía.  
    5. Agregue el grupo 'G001' del curso 'Fundamentos de la Geodesia', que se imparte en el segundo semestre de 2023, en la tabla `section`.  
    6. En la tabla `teaches`, asigne el grupo 'G001' de 'Fundamentos de la Geodesia', segundo semestre 2023, al profesor Eratóstenes.  
    7. En la tabla `takes`, matricule al estudiante Alexander von Humboldt en el grupo 'G001' de 'Fundamentos de la Geodesia', segundo semestre 2023.  

2. Agregue más registros de departamentos, estudiantes, profesores, cursos, grupos y demás. Intente cambiar el orden de las inserciones y observe los resultados.

## Bibliografía
```{bibliography}
:filter: docname in docnames
```

[^1]: En la representación de punto fijo, la posición del punto decimal es fija y no cambia. Por ejemplo, si se tiene un sistema de punto fijo de 4 dígitos con 2 posiciones después del punto decimal, el número 123.45 se representaría como 12345 y se entendería que el punto decimal está entre el segundo y tercer dígito desde la derecha. Generalmente, las operaciones de punto fijo son más rápidas y consumen menos recursos del hardware en comparación con las operaciones de punto flotante, especialmente en hardware que no tiene soporte dedicado para operaciones de punto flotante.

[^2]: En la representación de punto flotante, la posición del punto decimal puede variar, y el número se representa en términos de una mantisa y un exponente. Por ejemplo, el número 123.45 podría representarse como 1.2345 × 10<sup>2</sup> (1.2345 es la mantisa y 2 el exponente). Requiere hardware más complejo para realizar operaciones, pero esto se ha vuelto menos problemático con el tiempo, debido a la inclusión de unidades de punto flotante (FPU) en la mayoría de los procesadores modernos.