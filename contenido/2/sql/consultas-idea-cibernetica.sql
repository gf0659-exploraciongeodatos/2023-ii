-- Nombre, apellidos y nombre de departamento de cada empleado
SELECT 
    empleado.nombre AS "Nombre del empleado",
    empleado.apellidos AS "Apellidos del empleado",
    departamento.nombre AS "Nombre del departamento"
FROM empleado
LEFT JOIN departamento ON empleado.departamento_id = departamento.id;


-- Nombre, apellidos, nombre de departamento y nombre de puesto de cada empleado
SELECT 
    empleado.nombre AS "Nombre del empleado",
    empleado.apellidos AS "Apellidos del empleado",
    departamento.nombre AS "Nombre del eepartamento",
    puesto.nombre AS "Nombre del puesto"
FROM empleado
LEFT JOIN departamento ON empleado.departamento_id = departamento.id
LEFT JOIN puesto ON empleado.puesto_id = puesto.id;


-- Edad de los empleados al 2023-09-21
SELECT 
    nombre,
    apellidos,
    fecha_nacimiento,
    DATE_PART('year', AGE('2023-09-21', fecha_nacimiento)) AS edad
FROM empleado;


-- Edad promedio de todos los empleados
SELECT 
    AVG(DATE_PART('year', AGE('2023-09-21', fecha_nacimiento))) AS edad_promedio
FROM empleado;


-- Edad promedio de los empleados por departamento 
-- (debe mostrarse el nombre de todos los departamentos)
SELECT 
    departamento.nombre AS "Nombre del departamento",
    AVG(DATE_PART('year', age('2023-09-21', empleado.fecha_nacimiento))) AS "Edad promedio"
FROM departamento
LEFT JOIN empleado ON departamento.id = empleado.departamento_id
GROUP BY departamento.id, departamento.nombre
ORDER BY "Edad promedio" DESC;


-- Liste los departamentos que no tienen empleados
SELECT departamento.id, departamento.nombre
FROM departamento
LEFT JOIN empleado ON departamento.id = empleado.departamento_id
WHERE empleado.id IS NULL
GROUP BY departamento.id, departamento.nombre;


-- Salario promedio de los todos los empleados
SELECT AVG(salario) AS salario_promedio
FROM empleado;

-- Salario promedio de los empleados por departamento 
-- (debe mostrarse el nombre de todos los departamentos)
SELECT 
    departamento.nombre AS "Nombre del departamento",
    AVG(salario) AS "Salario promedio"
FROM departamento
LEFT JOIN empleado ON departamento.id = empleado.departamento_id
GROUP BY departamento.id, departamento.nombre
ORDER BY "Salario promedio" DESC;


-- Salario promedio de los empleados por proyecto 
-- (debe mostrarse el nombre de todos los proyectos)
SELECT 
    proyecto.nombre AS "Nombre del proyecto",
    AVG(empleado.salario) AS "Salario promedio"
FROM proyecto
LEFT JOIN empleado_proyecto ON proyecto.id = empleado_proyecto.proyecto_id
LEFT JOIN empleado ON empleado_proyecto.empleado_id = empleado.id
GROUP BY proyecto.id, proyecto.nombre
ORDER BY "Salario promedio" DESC;


-- Liste los empleados que no están asignados a ningún proyecto.
SELECT empleado.id, empleado.nombre, empleado.apellidos
FROM empleado
LEFT JOIN empleado_proyecto ON empleado.id = empleado_proyecto.empleado_id
WHERE empleado_proyecto.proyecto_id IS NULL;


-- Liste los proyectos que no tienen empleados asignados.
SELECT proyecto.id, proyecto.nombre
FROM proyecto
LEFT JOIN empleado_proyecto ON proyecto.id = empleado_proyecto.proyecto_id
WHERE empleado_proyecto.empleado_id IS NULL
GROUP BY proyecto.id, proyecto.nombre;


-- Liste los proyectos que no han concluído al 2023-09-21.
SELECT id, nombre, descripcion, fecha_inicio, fecha_fin
FROM proyecto
WHERE fecha_fin IS NULL OR fecha_fin > '2023-09-21';


-- Proyecto con el mayor período de ejecución.
SELECT 
    id,
    nombre,
    fecha_inicio,
    fecha_fin,
    CASE 
        WHEN fecha_fin IS NOT NULL THEN age(fecha_fin, fecha_inicio)
        ELSE age(CURRENT_DATE, fecha_inicio)
    END AS "Duracion"
FROM proyecto
ORDER BY "Duracion" DESC
LIMIT 1;
