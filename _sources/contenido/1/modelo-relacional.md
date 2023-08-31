# El modelo relacional
El modelo relacional para bases de datos toma su nombre del concepto matemático de [relación](https://es.wikipedia.org/wiki/Relaci%C3%B3n_matem%C3%A1tica). En matemáticas, específicamente en teoría de conjuntos, una relación es un conjunto de [tuplas](https://es.wikipedia.org/wiki/Tupla) (i.e. listas ordenadas de elementos). En el contexto de las bases de datos, una relación se representa generalmente como una tabla, donde cada fila o registro es una tupla, y cada columna es un atributo de la relación, como se ilustra en la {numref}`figure-relacion-profesor`. El relacional es un modelo lógico, en el que una base de datos es un conjunto de relaciones.

```{figure} img/relacion-profesor.png
:name: figure-relacion-profesor

La relación `Instructor` representada en una tabla {cite:p}`silberschatz_database_2019`.
```

El modelo relacional fue introducido por [Edgar Frank Codd](https://es.wikipedia.org/wiki/Edgar_Frank_Codd) en 1970 en su artículo "A Relational Model of Data for Large Shared Data Banks", publicado en la revista Communications of the ACM. Codd propuso este modelo como una forma más intuitiva y flexible de organizar y consultar datos en comparación con los modelos de bases de datos previamente existentes, como los modelos jerárquico y de red.

Las bases de datos relacionales, y los SABD que las implementan, utilizan el modelo relacional como base teórica y han dominado la industria de bases de datos durante décadas debido a su eficiencia, flexibilidad y capacidad de soportar transacciones complejas.

## Estructura de datos
La **relación (tabla)** es la estructura principal del modelo relacional. Como se mencionó, cada tabla contiene un conjunto de **tuplas (filas o registros)** y cada tupla es una lista ordenada de **atributos (columnas o campos)**. Al igual que en los conjuntos, las tuplas de una relación no están ordenadas y no se repiten.

El conjunto de valores que puede tener un atributo es su **dominio**. Algunos ejemplos de dominios son el conjunto de los números reales, el conjunto de los números enteros o un conjunto finito de hileras de texto (`Hombre`, `Mujer`; `H`, `M`; `Casado`, `Soltero`; `Sí`, `No`). Usualmente, los valores que componen un dominio son *atómicos* (indivisibles). El valor `nulo` (o `null`, en inglés) es un miembro de cualquier dominio. El manejo de valores nulos puede causar problemas en operaciones de manejo de datos.

El **esquema** de una base de datos es su estructura lógica (i.e. la lista de sus atributos). Por ejemplo, el esquema de la relación Instructor es:

`Instructor(ID, name, dept_name, salary)`

## Integridad de datos
La integridad en el modelo relacional de bases de datos se refiere a un conjunto de reglas y restricciones que garantizan la precisión y la consistencia de los datos en una base de datos relacional. Estas reglas ayudan a asegurar que la información almacenada en la base de datos sea confiable y que cualquier operación (inserción, actualización, borrado) no conduzca a un estado inválido de la base de datos.

La integridad en el modelo relacional se centra principalmente la **integridad de relación**, la **integridad referencial** y la **integridad de dominio**.

### Integridad de relación
Asegura que cada tupla en una relación pueda ser identificada de manera única por su **llave primaria (en inglés, *Primary Key* o PK)**. La PK está compuesta por uno o varios atributos que no se repiten en las tuplas de la relación.

### Integridad referencial
Se implementa a través de llaves foráneas. Una **llave foránea (en inglés, *Foreign Key* o FK)** establece una relación entre dos tablas. Una llave foránea en una tabla debe coincidir con la llave primaria de otra tabla, garantizando que no se creen registros "huérfanos" o que se borren registros que aún están siendo referenciados. Por ejemplo, en la tabla `Instructor`, el atributo `dept_name` es una llave foránea a otra tabla llamada `Department`, en la cual es su llave primaria.

### Integridad de dominio
Garantiza que todos los valores de una columna se encuentren dentro de un dominio específico o conjunto de valores aceptables. Por ejemplo, una columna que almacena `dia_semana` podría restringirse para que solo acepte los valores `lunes`, `martes`, ..., `domingo`.

El esquema de una base de datos, junto con sus llaves primarias y foráneas puede representarse mediante un **diagrama de esquema**, como el que se muestra en la {numref}`figure-schema-university`.

```{figure} img/schema-university.png
:name: figure-schema-university

Diagrama del esquema de la base de datos Universidad {cite:p}`silberschatz_database_2019`.
```

## Manipulación de datos
Los datos se manipulan mediante lenguajes. En este curso, se estudia en detalle el lenguaje SQL, el más utilizado. Existen otros lenguajes, como el álgebra relacional.

### Álgebra relacional
Es un lenguaje con un conjunto de operaciones que reciben una o dos relaciones como entrada y producen una nueva relación como salida.

Las operaciones básicas son seis:

1. Selección: σ
2. Proyección: ∏
3. Unión: ∪
4. Diferencia: –
5. Producto cartesiano: x
6. Renombrabiento: ρ

Para más detalles sobre álgebra relacional, puede consultar [Database System Concepts (Chapter 2)](https://www.db-book.com/slides-dir/PDF-dir/ch2.pdf).

## Ejercicios
Estructure la base de datos de estadísticas policiales del OIJ, que tiene una sola tabla en su estado original, en varias tablas. Para cada una, identifique:

- Nombre
- Llave primaria
- Llaves foráneas

## Bibliografía
```{bibliography}
:filter: docname in docnames
```
