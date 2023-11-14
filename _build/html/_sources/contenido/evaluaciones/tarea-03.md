# Tarea 03

## Fecha y hora límite de entrega
Jueves 23 de noviembre de 2023, 15:59.

## Descripción general
Esta tarea consiste en crear un "índice ambiental" de Costa Rica a nivel cantonal, compuesto por indicadores basados en datos geoespaciales de acceso público, como los disponibles en el [Sistema Nacional de Información Territorial (SNIT)](https://www.snitcr.go.cr/) y la [Imfraestructura Mundial de Información en Biodiversidad (GBIF)](https://www.gbif.org/). Debe cargar los datos en una base de datos PostgreSQL/PostGIS, programar en SQL las consultas correspondientes al cálculo de los indicadores y entregar los resultados en un archivo de texto y en un mapa.

La tarea puede realizarse en parejas o individualmente. En el primer caso, solo uno de los integrantes del equipo debe entregar la tarea en Mediación Virtual e indicar el nombre del otro integrante.

## Índice ambiental
Este índice se compone de varios indicadores, cada uno de los cuales está relacionado con diversos [servicios ecosistémicos](https://es.wikipedia.org/wiki/Servicios_del_ecosistema) como captura y almacenamiento de carbono, regulación del clima, hábitat para especies, aprovisionamiento de agua dulce, recreación y ecoturismo, entre otros.

Los indicadores se describen en la siguiente sección.

### Indicadores
Los indicadores deben calcularse para cada cantón. Los datos y las geometrías de los cantones debe obtenerse de la capa "Límite Cantonal" (`IGN_5_CO:limitecantonal_5k`) publicada en el servicio "IGN Cartografía 1:5mil CO" (`https://geos.snitcr.go.cr/be/IGN_5_CO/wfs`) del Instituto Geográfico Nacional (IGN).

#### Proporción de cobertura arbórea
Se calcula, para cada cantón, mediante la siguiente fórmula:

$$
\text{Proporción de cobertura arbórea} = \frac{\text{área del cantón cubierta por árboles (en km}^2\text{)}}{\text{área total del cantón (en km}^2\text{)}}
$$

El área cubierta por árboles debe obtenerse de la capa "Árboles 2017 1:5mil" (`IGN_5:forestal2017_5k`) publicada en el servicio "IGN Cartografía 1:5mil" (`https://geos.snitcr.go.cr/be/IGN_5/wfs?`) del Instituto Geográfico Nacional (IGN).

#### Densidad de red hidrográfica
Se calcula, para cada cantón, mediante la siguiente fórmula:

$$
\text{Densidad de red hídrográfica} = \frac{\text{longitud de la red hidrográfica del cantón (en km)}}{\text{área total del cantón (en km}^2\text{)}}
$$

La longitud de la red hidrográfica del cantón debe obtenerse de la capa "Hidrografía 1:5mil" (`IGN_5:hidrografia_5000`) publicada en el servicio "IGN Cartografía 1:5mil" (`https://geos.snitcr.go.cr/be/IGN_5/wfs?`) del Instituto Geográfico Nacional (IGN). 

#### Riqueza de especies de mamíferos
Se calcula, para cada cantón, mediante la siguiente fórmula:

$$
\text{Riqueza de especies de mamíferos} = \frac{\text{cantidad de especies de mamíferos presentes en el cantón}}{\text{316}}
$$

La cantidad de especies de mamíferos presentes en el cantón debe obtenerse del archivo CSV disponible en [https://doi.org/10.15468/dl.vmdyxe](https://doi.org/10.15468/dl.vmdyxe), el cual contiene el resultado de una consulta al portal de datos de la Infraestructura Mundial de Información en Biodiversidad (GBIF), de todos los registros de presencia georreferenciados de mamíferos de Costa Rica.

El número 316 que se utiliza en la fórmula, corresponde a la cantidad total de especies de mamíferos de Costa Rica presentes en el conjunto de datos obtenido a través de la consulta a GBIF [^footnote-mamiferos].

### Valor total
El valor total del índice se obtiene mediante al sumar el valor de los indicadores:

$$
\begin{gather*}
\text{Índice ambiental} = \\
\text{Proporción de cobertura arbórea} + \text{Densidad de red vial} + \text{Riqueza de especies de mamíferos}
\end{gather*}
$$

## Entregables
El valor porcentual de cada entregable se muestra entre paréntesis.

### Archivo .sql con sentencias SQL y sus resultados
Este archivo debe contener:

1. (20%) Sentencias SQL, y sus resultados, para el cálculo de la proporción de cobertura arbórea.
2. (20%) Sentencias SQL, y sus resultados, para el cálculo de la densidad de red hídrográfica.
3. (20%) Sentencias SQL, y sus resultados, para el cálculo de la riqueza de especies de mamíferos.
4. (30%) Sentencias SQL, y sus resultados, para el cálculo del valor total del índice.

**IMPORTANTE**  
- El problema debe ser resuelto completamente mediante SQL en la base de datos PostgreSQL/PostGIS. La secuencia de las consultas debe ser reproducible y conducir al resultado final, con el cálculo del valor total del índice. Para revisar la tarea, el profesor ejecutará las sentencias SQL y verificará la consistencia de los resultados obtenidos con los reportados.
- Los cálculos de áreas, distancias y otros similares deben realizarse mediante funciones de SQL (ej. `ST_Area()`).
- Los resultados deben presentarse con dos decimales.

### Mapa en archivo gráfico (.png, .jpg u otro)
Este archivo debe contener:

1. (10%) Un mapa de coropletas, proveniente de la tabla que contiene los cálculos finales, cuyos colores muestren el valor total del índice en cada cantón. Debe incluir una leyenda que muestre el significado de los colores.

[^footnote-mamiferos]: De acuerdo con los estudios más recientes, en Costa Rica hay 256 especies de mamíferos silvestres [(Ramírez-Fernández et al., 2023)](https://doi.org/10.12933/therya-23-2142). La diferencia de esta cantidad con las 316 especies contenidas en el conjunto de datos de GBIF puede deberse a que este último incluye especies domésticas, especies en cautiverio y posiblemente errores de identificación. Por limitaciones de tiempo, en esta tarea se usa la cantidad de especies del conjunto de datos de GBIF.

## Recomendaciones
El problema a resolver puede abordarse de varias formas. Se recomienda calcular uno por uno los índicadores, verificarlos, y luego proceder a calcular el valor total. Un posible enfoque (pero no el único) es crear una tabla para indicador y luego, mediante operaciones JOIN, crear la tabla con el valor total del índice.