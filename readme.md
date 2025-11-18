

## 🌟 Data Engineering Challenge: Ingesta y Procesamiento Transaccional

-----

## 🎯 Objetivo del Challenge

Este repositorio contiene la solución completa para el Challenge Técnico de Ingeniería de Datos, cuyo objetivo principal fue diseñar e implementar un **pipeline ETL** robusto y optimizado para **ingestar datos transaccionales (JSONL anidados)** y prepararlos para el consumo analítico en un entorno de **SQL Server**.

La solución fue diseñada priorizando la **eficiencia de memoria** en el procesamiento Python y la **flexibilidad** en el consumo de datos vía SQL.

-----

## 🚀 Arquitectura del Pipeline

El flujo de trabajo se estructura en un diseño modular de tres etapas principales ejecutadas en Python, garantizando un control de fallos granular y una alta optimización de recursos.

### 1\. 🔍 Análisis y Preparación de Datos

  * **Exploración Inicial:** Se realizó un análisis exploratorio en Python para determinar el formato, identificar la data **transaccional** (sin claves primarias) y localizar **datos faltantes** en las estructuras JSONL remitidas.
  * **Decisión Tecnológica:** Se descartó el uso de integraciones nativas de GCP/BigQuery (que aplanan JSONL automáticamente) para demostrar la capacidad de realizar el **aplanamiento de archivos JSONL** íntegramente mediante código Python.

### 2\. ⚙️ Parametrización y Modelado en SQL Server

Se diseñó la base de datos para funcionar como un **repositorio de datos inmutable**, apto para el consumo analítico sin riesgo de modificación:

  * **Creación de Tablas:** Se crearon tres tablas maestras en SQL Server que reflejan la información transaccional.
  * **Integridad de Datos:** Se procedió a **crear manualmente llaves primarias** y configurar los tipos de datos en la base de datos de destino para garantizar la integridad y el buen rendimiento de las consultas.

### 3\. 💾 Ingesta Eficiente de la Información

La fase de carga se ejecutó con una solución Python optimizada para el volumen de datos manejado (información transaccional de un mes):

  * **Herramientas:** Uso de **`json`**, **`pandas`** y **`pyodbc`**.
  * **Procesamiento:** Se realizó el aplanamiento de los archivos JSONL, el ajuste de nombres de columnas y la coerción de tipos de datos (**`astype()`**) para la eficiencia de memoria (ej. `float64` a `float32`).
  * **Carga Masiva:** Se utilizó **`pyodbc`** con el método **`executemany`** para la carga de datos a SQL Server, garantizando un proceso de inserción masiva y rápido.
  * **Escalabilidad Futura:** Se justifica el uso de **Pandas** por el tamaño manejable de la data, pero se deja clara la alternativa de migrar a **PySpark** en caso de enfrentar volúmenes de datos mayores a los 5GB.

-----

## 💻 Procesamiento y Consumo SQL

El enfoque del procesamiento fue facilitar la sinergia entre los equipos de desarrollo y análisis:

  * **Lógica en SQL:** El procesamiento final (transformación y agregación) se realiza con código SQL ejecutado directamente en el servidor.
  * **Parametrización:** Las consultas SQL están diseñadas para trabajar con **parámetros embebidos** en el código. Esto permite modificar la lógica de consulta (ej. rangos de fechas, filtros de estado) sin necesidad de modificar el código principal de Python, reduciendo riesgos de fallos de integración.

-----

## 💡 Notas de Diseño y Optimización

El proyecto se estructura en tres secciones separadas para garantizar la calidad y la optimización:

  * **Modularidad y Debugging:** Dividir el proceso en tres secciones (Análisis/Ingesta/Procesamiento) permite identificar rápidamente qué parte del *pipeline* falló (conexión, transformación, o carga) para una **gestión de corrección más rápida y concreta**.
  * **Control de Versiones:** Todo el proyecto se encuentra en un repositorio Git para el **control de versiones** y la trazabilidad del código.
  * **Optimización de Recursos:** Se priorizó el uso eficiente de la memoria y el consumo de recursos en Python (evitando la sobrecarga y los tipos de datos ineficientes) y se aplicó la carga masiva en SQL Server.