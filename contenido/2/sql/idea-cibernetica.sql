-- Creación de la tabla de departamentos
CREATE TABLE departamento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Creación de la tabla de puestos
CREATE TABLE puesto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    nivel_jerarquico INT
);

-- Creación de la tabla de empleados
CREATE TABLE empleado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    salario NUMERIC(10, 2),
    departamento_id INT REFERENCES departamento(id),
    puesto_id INT REFERENCES puesto(id)
);

-- Creación de la tabla de proyectos
CREATE TABLE proyecto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Creación de la tabla de empledos-proyectos
CREATE TABLE empleado_proyecto (
    empleado_id INT REFERENCES empleado(id),
    proyecto_id INT REFERENCES proyecto(id),
    PRIMARY KEY (empleado_id, proyecto_id)
);


-- Inserción de departamentos
INSERT INTO departamento (nombre) VALUES ('Desarrollo');
INSERT INTO departamento (nombre) VALUES ('Diseño');
INSERT INTO departamento (nombre) VALUES ('Recursos Humanos');
INSERT INTO departamento (nombre) VALUES ('Ventas');

-- Inserción de puestos
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Desarrollador Junior', 'Desarrollo de software', 1);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Desarrollador Senior', 'Desarrollo de software', 2);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Gerente de Proyecto', 'Gestión de proyectos', 3);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Diseñador UX/UI', 'Diseño de interfaces', 1);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Analista QA', 'Control de calidad', 1);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Asistente de Recursos Humanos', 'Gestión de personal', 2);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Gerente de Recursos Humanos', 'Gestión de personal', 3);
INSERT INTO puesto (nombre, descripcion, nivel_jerarquico) VALUES ('Vendedor', 'Ventas', 1);

-- Inserción de empleados
-- Con departamento asignado
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('John', 'Doe', '1985-05-15', 60000.00, 1, 1);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Emily', 'Smith', '1990-08-12', 75000.00, 1, 2);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('William', 'Brown', '1992-11-25', 50000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Sophia', 'Johnson', '1980-03-22', 70000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Jack', 'Williams', '1995-07-19', 55000.00, 3, 6);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Olivia', 'Jones', '1986-01-31', 65000.00, 3, 7);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Benjamin', 'Garcia', '1993-12-05', 68000.00, 1, 1);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Lucas', 'Miller', '1989-04-15', 54000.00, 1, 2);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Henry', 'Davis', '1975-10-09', 73000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('James', 'Rodriguez', '1998-02-28', 49000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Alexander', 'Martinez', '1994-06-18', 62000.00, 3, 6);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Sebastian', 'Hernandez', '1982-11-11', 60000.00, 3, 7);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Jack', 'Lee', '1999-07-20', 52000.00, 1, 1);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Daniel', 'Gonzalez', '1991-05-25', 72000.00, 1, 2);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Ella', 'Perez', '1978-12-15', 75000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Aiden', 'Lewis', '1987-09-01', 56000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Matthew', 'Nelson', '1983-04-21', 64000.00, 3, 6);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Samuel', 'Carter', '1970-08-30', 58000.00, 3, 7);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('David', 'Mitchell', '1996-10-12', 53000.00, 1, 1);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Joseph', 'Roberts', '1988-11-07', 71000.00, 1, 2);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Carter', 'Long', '1995-02-28', 69000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Owen', 'Foster', '1976-06-15', 54000.00, 2, 4);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, departamento_id, puesto_id) VALUES ('Wyatt', 'Russell', '1984-03-17', 57000.00, 3, 6);
-- Sin departamento asignado
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, puesto_id) VALUES ('Nathan', 'Ortiz', '1981-07-11', 60000.00, 8);
INSERT INTO empleado (nombre, apellidos, fecha_nacimiento, salario, puesto_id) VALUES ('Isabella', 'Gomez', '1974-05-24', 67000.00, 5);

-- Inserción de proyectos
INSERT INTO proyecto (nombre, descripcion, fecha_inicio, fecha_fin) VALUES ('Proyecto A', 'Desarrollo de una aplicación móvil', '2022-01-01', '2023-12-31');
INSERT INTO proyecto (nombre, descripcion, fecha_inicio, fecha_fin) VALUES ('Proyecto B', 'Desarrollo de un sitio web', '2021-06-01', NULL);
INSERT INTO proyecto (nombre, descripcion, fecha_inicio, fecha_fin) VALUES ('Proyecto C', 'Desarrollo de una API', '2022-06-01', '2023-01-31');
INSERT INTO proyecto (nombre, descripcion, fecha_inicio, fecha_fin) VALUES ('Proyecto D', 'Desarrollo de un juego', '2022-01-15', '2022-12-15');
INSERT INTO proyecto (nombre, descripcion, fecha_inicio, fecha_fin) VALUES ('Proyecto E', 'Desarrollo de sistema de información geográfica', '2023-01-01', '2023-12-31');

-- Inserción de empleados - proyectos
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (1, 1);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (2, 1);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (3, 1);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (4, 1);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (5, 1);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (6, 1);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (7, 2);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (8, 2);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (9, 2);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (10, 2);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (11, 2);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (12, 2);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (13, 3);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (14, 3);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (15, 3);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (16, 3);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (17, 3);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (18, 3);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (19, 4);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (20, 4);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (21, 4);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (22, 4);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (23, 4);
INSERT INTO empleado_proyecto (empleado_id, proyecto_id) VALUES (24, 4);

