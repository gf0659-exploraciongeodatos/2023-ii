# Diseño de bases de datos

## Introducción
En este capítulo, se explica como diseñar el esquema de una base de datos mediante el modelo de datos entidad-relación (ER).

## El modelo Entidad-Relación (ER)
El [modelo Entidad-Relación (ER)](https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model) es un modelo conceptual de alto nivel que se utiliza para representar y organizar la información en una base de datos. Fue propuesto por Peter Chen en 1976.

Sus principales componentes son:

1. **Entidades**: Representan objetos o conceptos del mundo real que se desean almacenar en la base de datos como, por ejemplo, una persona, un producto o un evento.

2. **Atributos**: Son las propiedades o características que describen una entidad. Por ejemplo, una entidad "Persona" podría tener atributos como "Nombre", "Edad" y "Dirección".

3. **Relaciones**: Indican cómo las entidades se relacionan o asocian entre sí. Por ejemplo, para las entidades "Estudiante" y "Curso", una relación podría ser "matriculado en".

4. **Cardinalidad**: Se refiere a la naturaleza cuantitativa de la relación entre dos entidades. Especifica cuántas instancias de una entidad se relacionan con una instancia de otra entidad. Los tipos más comunes de cardinalidad son uno a uno (1:1), uno a muchos (1:N) y muchos a muchos (M:N).

## Niveles de abstracción
Es usual dividir un modelo ER en varios niveles de abstracción:

- Diseño conceptual.
- Diseño lógico.
- Diseño físico.

### Diseño conceptual
Es una representación de alto nivel de la estructura de la base de datos, comprensible tanto para el diseñador como para los usuarios finales. Debe capturar todas las necesidades de datos de los usuarios y cómo se relacionan entre sí. Se compone de entidades, sus atributos, relaciones entre entidades y restricciones sobre estas entidades y relaciones.

### Diseño lógico
Transforma el modelo conceptual en un esquema que representa la estructura de la base de datos según un modelo de datos específico (ej. el modelo relacional), pero aún independiente de detalles físicos (ej. tipos de datos, índices). El resultado es un conjunto de definiciones de tablas, llaves, relaciones entre tablas y otras estructuras lógicas.

### Diseño físico
Implementa el diseño lógico en un SABD, por lo que sus detalles son dependientes de la elección del SABD. Se ocupa de cuestiones relacionadas con el almacenamiento, la indexación, el acceso y la recuperación de datos. Mientras que algunos aspectos del diseño físico de una base de datos puede cambiarse con relativa facilidad después de que una base de datos ha sido construída, los cambios en el esquema lógico son más difíciles de realizar porque es más probable que impliquen modificaciones en las aplicaciones que acceden la base de datos.