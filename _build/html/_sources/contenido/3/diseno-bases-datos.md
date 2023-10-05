# Diseño de bases de datos

## Introducción
En este capítulo, se explica como diseñar el esquema de una base de datos mediante el modelo de datos entidad - relación. El proceso de diseño se divide en especificación de requerimientos de los usuarios, diseño conceptual, diseño lógico y diseño físico.

## El modelo entidad - relación (ER)
El [modelo entidad - relación (ER)](https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model) es un modelo conceptual de alto nivel que se utiliza para representar y organizar la información de una base de datos. Fue propuesto por Peter Chen en 1976.

### Componentes
Los principales componentes de un modelo ER son:

1. **Entidades**: Representan objetos o conceptos del mundo real que se desean almacenar en la base de datos como, por ejemplo, una persona, un producto o un evento.

2. **Atributos**: Son las propiedades o características que describen una entidad. Por ejemplo, una entidad "Persona" podría tener atributos como "Nombre", "Edad" y "Dirección".

3. **Relaciones**: Indican cómo las entidades se relacionan o asocian entre sí. Por ejemplo, para las entidades "Estudiante" y "Curso", una relación podría ser "matriculado en". Un aspecto de suma importancia de una relación entre dos entidades es su cardinalidad, la cual especifica cuántas instancias de una entidad se relacionan con una instancia de la otra entidad. Hay varios tipos de cardinalidad en un modelo ER:

    - **Uno a uno (1:1)**: Una instancia de una entidad está asociada con exactamente una instancia de la otra entidad y viceversa. Por ejemplo, un empleado tiene un número de seguridad social y un número de seguridad social pertenece a un solo empleado.

    - **Uno a muchos (1:N)**: Una instancia de una entidad puede estar asociada con muchas instancias de la otra entidad, pero una instancia de la segunda entidad solo puede estar asociada con una instancia de la primera. Por ejemplo, un departamento puede tener muchos empleados, pero un empleado pertenece a un solo departamento.

    - **Muchos a uno (N:1)**: Es el caso inverso del anterior. Muchas instancias de una entidad pueden estar asociadas con una única instancia de la otra entidad.

    - **Muchos a muchos (N:M)**: Una instancia de una entidad puede estar asociada con muchas instancias de la otra entidad y viceversa. Por ejemplo, un estudiante puede estar matriculado en muchos cursos y un curso puede tener muchos estudiantes matriculados.

### Simbología
Las entidades se representan mediante rectángulos, las relaciones mediante líneas y la cardinalidad mediante la notación de ["patas de gallo" (*crow foot*)](https://www.freecodecamp.org/news/crows-foot-notation-relationship-symbols-and-how-to-read-diagrams/), como se ilustra en la {numref}`figure-er-simbologia-0`.

```{figure} img/er-simbologia-0.png
:name: figure-er-simbologia-0

Simbología básica de un diagrama ER. Fuente: [freeCodeCamp](https://www.freecodecamp.org/news/crows-foot-notation-relationship-symbols-and-how-to-read-diagrams/).
```

La {numref}`figure-er-simbologia` muestra cuatro entidades: `Departamento`, `Empleado`, `Proyecto` y `Carné`, con las siguientes relaciones:

- `Contrata`, entre `Departamento` y `Empleado`, es una relación de uno a muchos (1:N): un departamento contrata muchos empleados, un empleado es contratado por un único departamento.
- `Participa`: entre `Empleado` y `Proyecto`, es una relación de muchos a muchos (N:M): un empleado puede participar en muchos proyectos, un proyecto puede tener muchos empleados.
- `Tiene`: entre `Empleado` y `Carné`, es una relación de uno a uno (1:1): un empleado solo tiene un carné, un carné pertenece a un único empleado.

La notación de "patas de gallo", para cardinalidad, se resumen en la {numref}`figure-er-patas-gallo`.

```{figure} img/er-patas-gallo.png
:name: figure-er-patas-gallo

Notación de "patas de gallo" para cardinalidad. Fuente: [Lucidchart](https://www.lucidchart.com/pages/es/simbolos-de-diagramas-entidad-relacion).
```

Para representar tablas, sus columnas, llaves primarias (PK) y llaves foráneas (FK), se utiliza la simbología que se ilustra en la {numref}`figure-er-simbologia-1`.

```{figure} img/er-simbologia-1.png
:name: figure-er-simbologia-1

Simbología detallada de un diagrama ER. Fuente: [Lucidchart](https://www.lucidchart.com/pages/es/simbolos-de-diagramas-entidad-relacion).
```

## Fases del proceso de diseño

### Especificación de requerimientos de los usuarios
Durante la fase inicial del diseño, es esencial identificar, detallar y entender las necesidades de los futuros usuarios de la base de datos. Esta tarea exige una profunda interacción del diseñador con los usuarios y expertos del dominio, por ejemplo, mediante entrevistas. El resultado de esta fase es una especificación de los requerimientos del usuario, usualmente en forma textual, aunque también pueden emplearse formatos gráficos.

### Diseño conceptual
En esta fase, el diseñador elige un modelo de datos y aplica sus conceptos para traducir los requerimientos de los usuarios en un esquema conceptual de la base de datos. En términos del modelo ER, el esquema conceptual especifica las entidades que se representan en la base de datos, los atributos de las entidades, las relaciones entre las entidades y la cardinalidad de las relaciones. Típicamente, la fase de diseño conceptual resulta en la creación de un diagrama ER que proporciona una representación gráfica del esquema de la base de datos.

### Diseño lógico
En la fase de diseño lógico, el diseñador mapea el esquema conceptual en el modelo de datos de implementación del sistema de base de datos que se utilizará. El modelo de datos de implementación es usualmente el modelo de datos relacional.

### Diseño físico
Finalmente, el diseñador utiliza el esquema de base de datos resultante en la fase de diseño físico subsiguiente, en la cual se especifican las características físicas de la base de datos. Estas características incluyen la forma de almacenamiento, las estructuras de indexación y el particionamiento, entre otras.

## Errores comunes de diseño
Al diseñar un esquema de base de datos, es importante evitar algunos errores comunes, como la redundancia y la incompletitud {cite:p}`silberschatz_database_2019`.

### Redundancia
Un diseño deficiente tiende a repetir información. Por ejemplo, si se almacena la identificación y el nombre de un curso en grupo (*section*), el nombre se almacenaría de manera redundante (es decir, múltiples veces, innecesariamente) con cada grupo. Sería suficiente almacenar solo el identificador del curso con cada grupo y asociar el nombre con el identificador del curso solo una vez, en una entidad de curso.

El mayor inconveniente de la redundancia es que las copias de un componente de información pueden volverse inconsistentes si la información se actualiza sin tomar precauciones para actualizar todas las copias de la información. Por ejemplo, diferentes grupos de un curso pueden tener el mismo identificador de curso, pero pueden tener diferentes nombres. Entonces, no estaría claro cuál es el nombre correcto del curso. Idealmente, la información debería estar en un solo lugar.

### Incompletitud
Un mal diseño también puede dificultar o imposibilitar modelar ciertos aspectos de la una organización. Por ejemplo, supongamos que, siguiendo con el ejemplo anterior de los cursos y sus grupos, solo tenemos la entidad correspondiente a los grupos de los cursos, sin tener una entidad correspondiente a los cursos. Esto equivaldría a tener una sola tabla donde se repite toda la información del curso una vez por cada grupo. Así sería imposible representar información sobre un nuevo curso, a menos que ese curso se imparta. Se podría intentar solucionar este problema almacenando valores nulos en la información del curso. Esta solución no solo es poco elegante desde el punto de vista de diseño, sino que puede ser impedida por restricciones de llave primaria.

Evitar estos errores de diseño no es suficiente. Usualmente, hay varios buenos diseños entre los que debe realizarse una elección. Como un ejemplo simple, considere un cliente que compra un producto. ¿Es la venta de este producto una relación entre una entidad "Cliente" y una entidad "Producto"? Alternativamente, ¿es la "Venta" en sí misma una entidad que está relacionada tanto con "Cliente" como con "Producto"? Este tipo de elecciones puede marcar una diferencia importante en los resultados del diseño. Como puede verse, un buen diseño de bases de datos requiere de una combinación de ciencia, experiencia, intuición y "buen gusto" {cite:p}`silberschatz_database_2019`.

## Ejercicios

### Especificación de requerimientos
Debe diseñar una base de datos relacional para un servicio de entrega de comida a domicilio, con las siguientes características y requerimientos:

- Los clientes ordenan pedidos de comidas y bebidas que son entregados en la dirección que indique cada cliente.
- El servicio cuenta con varias sucursales, cada una con uno o varios empleados que toman los pedidos. Cada empleado trabaja para una sola sucursal.
- Regularmente, se distribuyen promociones entre los clientes a través de cupones, los cuales permiten aplicar descuentos a los pedidos.
- Se desea llevar el control de los pedidos por sucursal, fecha y promoción. Por ejemplo, poder obtener:
    - Total de ventas por sucursal.
    - Total de ventas por fecha o por rango de fechas.
    - Total de ventas asociadas por promoción.
    - Total de ventas por platillo. 
- Actualmente, el negocio administra sus datos en una hoja de cálculo Excel. Una muestra de su estructura y sus datos está disponible en [pedidos.csv](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/pedidos/pedidos.csv). Su tarea es reemplazar esta hoja de cálculo por una base de datos que pueda implementarse en un sistema administrador de bases de datos relacionales (ej. PostgreSQL).

### Diseño conceptual, lógico y físico
Realice los siguientes pasos para diseñar la base de datos del servicio de entrega de comida a domicilio. Para dibujar los diagramas, puede utilizar el complemento `Draw.io integration` de [Visual Studio Code](https://code.visualstudio.com/).

1. **Elabore un diagrama que muestre las entidades, sus relaciones y su cardinalidad.**

En la {numref}`figure-pedidos-diagrama-0`, se muestra una posible solución.

```{figure} img/pedidos-diagrama-0.png
:name: figure-pedidos-diagrama-0

Diagrama conceptual de entidades, relaciones y cardinalidad.
```

2. **Cree una versión adicional del diagrama anterior que contemple el control de los datos de la entrega del pedido (tiempo, mensajero, costo, etc.).**

3. **Elabore un diagrama ER que muestre las entidades, sus atributos, sus relaciones, su cardinalidad, sus llaves primarias y sus llaves foráneas, de manera que pueda ser implementado en un sistema administrador de bases de datos (ej. PostgreSQL).**

4. **Escriba los comandos SQL para crear las tablas e insertar datos de prueba.**

## Bibliografía
```{bibliography}
:filter: docname in docnames
```
