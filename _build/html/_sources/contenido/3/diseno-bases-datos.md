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

Estos niveles corresponden también a las etapas del proceso de diseño.

### Diseño conceptual
Es una representación de alto nivel de la estructura de la base de datos, comprensible tanto para el diseñador como para los usuarios finales. Debe capturar todas las necesidades de datos de los usuarios y cómo se relacionan entre sí. Se compone de entidades, sus atributos, relaciones entre entidades y restricciones sobre estas entidades y relaciones.

En el diseño conceptual:

- Se definen los requerimientos (*business needs*).
- Se establece el vocabulario.
- Se facilita la comunicación entre el equipo de desarrollo y los usuarios.

**Tareas**:

- Identificar entidades (*business objects*) y nombrarlas.
- Identificar relaciones entre entidades y nombrarlas.
- Determinar la cardinalidad de las relaciones.
- Delimitar el problema.

### Diseño lógico
Transforma el modelo conceptual en un esquema que representa la estructura de la base de datos según un modelo de datos específico (ej. el modelo relacional), pero aún independiente de detalles físicos (ej. tipos de datos, índices). El resultado es un conjunto de definiciones de tablas, llaves, relaciones entre tablas y otras estructuras lógicas.

**Tareas**:

- Identificar atributos de las entidades.
- Identificar llaves primarias.
- Identificar llaves foráneas.
- Normalizar.

### Diseño físico
Implementa el diseño lógico en un SABD, por lo que sus detalles son dependientes de la elección del SABD. Se ocupa de cuestiones relacionadas con el almacenamiento, la indexación, el acceso y la recuperación de datos. Mientras que algunos aspectos del diseño físico de una base de datos puede cambiarse con relativa facilidad después de que una base de datos ha sido construída, los cambios en el esquema lógico son más difíciles de realizar porque es más probable que impliquen modificaciones en las aplicaciones que acceden la base de datos.

## Ejercicios
Considere los datos de un servicio de entrega de comida a domicilio disponibles en [pedidos.csv](https://github.com/gf0659-exploraciongeodatos/2023-ii/blob/main/datos/pedidos/pedidos.csv). 

Los clientes ordenan y los pedidos se les entregan en la dirección que cada uno especifique. Se desea llevar el control de los pedidos de acuerdo por sucursal, fecha y promoción. El servicio cuenta con varias sucursales y cada sucursal tiene uno o varios empleados para tomar las órdenes. Cada empleado trabaja para una sola sucursal.

Realice los siguientes ejercicios para diseñar una base de datos del servicio de entrega a domicilio. Para dibujar los diagramas, puede utilizar el complemento `Draw.io integration` de [Visual Studio Code](https://code.visualstudio.com/).

1. Elabore un diagrama que muestre las entidades, sus relaciones y su cardinalidad.

    - Cree una versión adicional del diagrama anterior que contemple el control de los datos de la entrega del pedido (tiempo, mensajero, costo, etc.).

2. Elabore un diagrama que muestre las entidades, sus atributos, sus relaciones y su cardinalidad.