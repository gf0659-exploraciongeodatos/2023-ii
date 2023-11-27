# Proyecto

## Fecha y hora límite de entrega
Miércoles 6 de diciembre de 2023, 11:59 a.m.

## Descripción general
Este proyecto consiste en programar consultas a datos espaciales en el lenguaje SQL para calcular la densidad de la red vial en las provincias de Costa Rica y en los distritos de un cantón de su elección. Los resultados deben visualizarse como tablas, gráficos estadísticos y mapas en un cuaderno de notas Jupyter (*Jupyter notebook*) de la plataforma [Google Colab](https://colab.research.google.com/).

Debe utilizar las siguientes herramientas:

- La bibliotecaca GDAL y su comando `ogr2ogr`, para descargar los datos.
- Una base de datos DuckDB residente en memoria, para almacenar los datos.
- La extensión JupySQL de Jupyter, para ejecutar consultas SQL y generar gráficos estadísticos en cuadernos de notas Jupyter.
- El paquete Leafmap para generar mapas interactivos.

Debe utilizar los siguientes conjuntos de datos, disponibles en el [Sistema Nacional de Información Territorial (SNIT)](https://www.snitcr.go.cr/):

- Capa "Límite Provincial" (`IGN_5_CO:limiteprovincial_5k`) publicada en el servicio WFS "IGN Cartografía 1:5mil CO" (`https://geos.snitcr.go.cr/be/IGN_5_CO/wfs`) del Instituto Geográfico Nacional (IGN).
- Capa "Límite Distrital" (`IGN_5_CO:limitedistrital_5k`) publicada en el servicio WFS "IGN Cartografía 1:5mil CO" (`https://geos.snitcr.go.cr/be/IGN_5_CO/wfs`) del IGN.
- Capa "Red vial" (`IGN_200:redvial_200k`) publicada en el servicio WFS "IGN 1:200mil" (`https://geos.snitcr.go.cr/be/IGN_200/wfs?`) del IGN.

La tarea puede realizarse en parejas o individualmente. En el primer caso, solo uno de los integrantes del equipo debe entregar la tarea en Mediación Virtual e indicar el nombre del otro integrante.

## Desarrollo
Debe calcular la densidad de la red vial para los siguientes conjuntos de datos:

1. Las siete provincias de Costa Rica.
2. Los distritos de un cantón de su elección, el cual debe tener al menos dos distritos.

La densidad de la red vial de un polígono (provincia, distrito) se define como:

$$
\text{Densidad de red vial} = \frac{\text{longitud de la red vial del polígono (en km)}}{\text{área total del polígono (en km}^2\text{)}}
$$

Para cada conjunto de datos, debe presentar los resultados del cálculo de densidad de red vial en una tabla (la que genera un comando `SELECT` de SQL), en un gráfico de barras y en un mapa de coropletas.


## Entregables
Debe ingresar en la plataforma Mediación Virtual el enlace a un cuaderno de notas Jupyter hospedado en Google Colab, con el siguiente contenido (el valor porcentual de cada punto se muestra entre paréntesis):

1. (5%) Una breve introducción (uno o dos párrafos) en la que se explique el contenido del cuaderno de notas y se mencionen las fuentes de datos. Puede considerarlo como el primer paso para elaborar un artículo.
2. (15%) Comandos [ogr2ogr](https://gdal.org/programs/ogr2ogr.html) para la descarga de los tres conjuntos de datos.
3. (20%) Cálculo en SQL de la densidad de la red vial para los dos conjuntos de datos. El resultado debe mostrarse en una tabla, producto de una sentencia `SELECT`.
4. (20%) Dos gráficos de barras (uno para cada conjunto de datos), elaborados con JupySQL, que muestren la densidad de la red vial en las provincias o distritos, según corresponda. Las barras deben estar ordenadas (de menor a mayor o de mayor a menor) y correctamente etiquetadas con los nombres de las provincias o de los distritos.
5. (25%) Dos mapas de coropletas (uno para cada conjunto de datos), elaborados con Leafmap, que muestren la densidad de la red vial en las provincias o distritos, según corresponda.

Además, el 15% de la nota corresponde a la estructura y el orden del cuaderno de notas. También puede considerarlo como un borrador de un artículo. Se tomarán en cuenta los siguientes aspectos:

- El documento debe dividirse en secciones. Puede usarse una estructura similar a la que se ha visto en clase u otra que se considere apropiada.
- No deben mostrarse mensajes de error, advertencias o cualquier otro texto que dificulte la lectura. Estos textos pueden limpiarse desde la interfaz de Colab.
- Redacción y ortografía.

**IMPORTANTE**  
- Se pretende que este proyecto sea un ejemplo de un flujo de trabajo reproducible y debe realizarse completamente en el cuaderno de notas Jupyter, desde la descarga de los conjuntos de datos hasta la generación de las salidas en tablas, gráficos y mapas. Para revisar la tarea, el profesor ejecutará las sentencias SQL y verificará la consistencia de los resultados obtenidos con los reportados.
- Los cálculos de áreas, distancias y otros similares deben realizarse mediante funciones de SQL (ej. `ST_Area()`, `ST_Length()`).
- Los valores de densidad de la red vial deben presentarse con dos decimales.