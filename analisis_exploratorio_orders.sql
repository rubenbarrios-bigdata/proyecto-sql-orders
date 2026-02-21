-- =====================================================
-- ======
-- PROYECTO PRÁCTICO DE ANÁLISIS EXPLORATORIO (EDA)
-- Análisis de Ventas Minoristas
-- Database: Dataset Superstore
-- Fuente de los datos: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final 
-- Período: 01/01/2017 - 09/09/2017
-- Autor: Ruben Barrios
-- Herramienta: MySQL
-- =====================================================
-- ======


-- =====================================================
-- 📊 DESCRIPCIÓN INICIAL DEL PROYECTO
-- =====================================================

-- El presente proyecto tiene como finalidad realizar
-- un análisis exploratorio y financiero del dataset "orders",
-- siguiendo una estructura ordenada que permita validar
-- la calidad de los datos antes de desarrollar el análisis
-- y obtener conclusiones estratégicas.

-- =====================================================
-- 1. Validación inicial de los datos
-- =====================================================
-- Visualizar los primeros 5 registros del dataset
-- para confirmar que la tabla fue importada correctamente,
-- verificar la estructura de las columnas y asegurar
-- que la información esté disponible para su análisis.

-- =====================================================
-- 2. Validación y calidad de los datos
-- =====================================================
-- Evaluar la consistencia del dataset antes de iniciar
-- el análisis, con el fin de garantizar confiabilidad
-- en los resultados posteriores.

-- 2.1 Verificar valores nulos
-- Verificar la existencia de valores faltantes en columnas
-- clave como Sales, Profit y Order Date,
-- con el objetivo de evitar distorsiones en el análisis.

-- 2.2 Verificar registros duplicados
-- Verificar la posible existencia de órdenes repetidas
-- mediante el análisis del identificador de orden,
-- para determinar si corresponden a errores o a líneas
-- de detalle dentro de una misma transacción.

-- 2.3 Verificar valores negativos
-- Identificar posibles valores atípicos como ventas
-- o ganancias negativas, con el fin de detectar
-- inconsistencias o situaciones relevantes del negocio.

-- 2.4 Cuantificar órdenes con pérdidas
-- Calcular el número de registros que presenten
-- ganancias negativas, con el propósito de dimensionar
-- su posible impacto financiero.

-- 2.5 Determinar impacto porcentual de pérdidas
-- Determinar el porcentaje de registros con ganancias
-- negativas respecto al total de operaciones,
-- para contextualizar su peso dentro del dataset.

-- =====================================================
-- 3. Cantidad total de registros
-- =====================================================
-- Calcular el número total de transacciones registradas,
-- estableciendo la base cuantitativa del análisis.

-- =====================================================
-- 4. Ventas totales
-- =====================================================
-- Calcular el total de ingresos generados durante
-- el período analizado, con el fin de conocer
-- el volumen general del negocio.

-- =====================================================
-- 5. Ventas por categoría
-- =====================================================
-- Analizar las ventas agrupadas por categoría
-- para identificar cuáles generan mayor participación
-- en los ingresos.

-- =====================================================
-- 6. Ventas por región
-- =====================================================
-- Analizar el desempeño comercial por región geográfica,
-- con el objetivo de identificar concentraciones
-- de ventas y posibles oportunidades de crecimiento.

-- =====================================================
-- 7. Top 10 clientes por volumen de compra
-- =====================================================
-- Identificar los clientes con mayor volumen de compra,
-- para evaluar su importancia dentro de la estructura
-- de ingresos del negocio.

-- =====================================================
-- 8. Rentabilidad por categoría
-- =====================================================
-- Comparar las ventas totales con la ganancia obtenida
-- por categoría, con el propósito de evaluar
-- el desempeño financiero de cada segmento.

-- =====================================================
-- 9. Ventas mensuales
-- =====================================================
-- Analizar la evolución mensual de las ventas
-- para identificar tendencias, comportamientos
-- estacionales y variaciones en el tiempo.

-- =====================================================
-- 🎯 Enfoque del proyecto
-- =====================================================
-- Seguir una metodología estructurada que inicie
-- con la validación de datos, continúe con métricas
-- generales de desempeño y finalice con análisis
-- estratégicos orientados a la toma de decisiones.
-- =====================================================


-- -----------------------------------------------------
-- Consulta período de ventas
-- -----------------------------------------------------

SELECT 
    MIN(`order date`) AS fecha_inicio,
    MAX(`order date`) AS fecha_fin
FROM orders;

-- Las ventas corresponden al período 01/01/2017 - 09/09/2017


-- -----------------------------------------------------
-- 0. Definición del entorno de trabajo
-- Selección de la base de datos
-- Objetivo:
-- Establecer la base de datos que se utilizará
-- para ejecutar las consultas del proyecto.
-- -----------------------------------------------------

USE superstore_db;

-- Interpretación:
-- A partir de este punto, todas las consultas se
-- ejecutarán sobre la base de datos seleccionada.

-- -----------------------------------------------------
-- 1. Validación inicial de los datos
-- Objetivo:
-- Visualizar los primeros 5 registros del dataset
-- para confirmar que la tabla fue importada correctamente,
-- verificar la estructura de las columnas y asegurar
-- que la información esté disponible para su análisis.
-- -----------------------------------------------------

SELECT *
FROM orders
LIMIT 5;

-- Interpretación:
-- Se observan las primeras 5 filas del dataset para confirmar
-- que las columnas y los datos fueron cargados correctamente.

-- =====================================================
-- 2. Validación y calidad de los datos
-- =====================================================
-- Objetivo:
-- Evaluar la consistencia del dataset antes de iniciar
-- el análisis, con el fin de garantizar confiabilidad
-- en los resultados posteriores.
-- =====================================================


-- -----------------------------------------------------
-- 2.1 Verificación de valores nulos
-- -----------------------------------------------------
-- Objetivo:
-- Verificar la existencia de valores nulos en columnas
-- clave como Sales, Profit y Order Date,
-- con el objetivo de evitar distorsiones en el análisis.
-- -----------------------------------------------------

SELECT 
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS sales_nulos,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS profit_nulos,
    SUM(CASE WHEN `order date` IS NULL THEN 1 ELSE 0 END) AS order_date_nulos
FROM orders;

-- Interpretación:
-- Esta consulta permite confirmar si existen o no valores nulos
-- en variables críticas para el análisis.
-- En este caso, los resultados fueron 0, lo que indica que
-- el dataset no presenta valores nulos en estas columnas.


-- -----------------------------------------------------
-- 2.2 Verificación de registros duplicados
-- -----------------------------------------------------
-- Objetivo:
-- Verificar la posible existencia de órdenes repetidas
-- mediante el análisis del identificador de orden,
-- para determinar si corresponden a errores o a líneas
-- de detalle dentro de una misma transacción.
-- -----------------------------------------------------

SELECT `Order ID`, COUNT(*) AS cantidad
FROM orders
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

-- Interpretación:
-- La consulta devuelve órdenes con más de un registro.
-- Esto no necesariamente indica duplicados erróneos,
-- ya que una misma orden puede incluir múltiples productos.
-- Por lo tanto, estos casos representan líneas de detalle
-- dentro de una misma orden y no errores en los datos.


-- -----------------------------------------------------
-- 2.3 Verificación de valores negativos
-- -----------------------------------------------------
-- Objetivo:
-- Identificar posibles valores atípicos como ventas
-- o ganancias negativas, con el fin de detectar
-- inconsistencias o situaciones relevantes del negocio.
-- -----------------------------------------------------

SELECT *
FROM orders
WHERE Sales < 0 OR Profit < 0;

-- Interpretación:
-- No se detectaron ventas negativas.
-- Se identificaron registros con Profit < 0,
-- lo que indica que existen órdenes que generaron pérdidas.
-- Esto no representa un error en el dataset,
-- sino situaciones reales del negocio que pueden
-- estar asociadas a descuentos elevados,
-- altos costos o productos poco rentables.


-- -----------------------------------------------------
-- 2.4 Cuantificación de órdenes con pérdidas
-- -----------------------------------------------------
-- Objetivo:
-- Calcular el número de registros que presenten
-- ganancias negativas, con el propósito de dimensionar
-- su posible impacto financiero. 
-- -----------------------------------------------------

SELECT COUNT(*) AS total_perdidas
FROM orders
WHERE Profit < 0;

-- Interpretación:
-- Esta consulta permite conocer el número total de registros
-- que generaron pérdidas.
-- Con este resultado se puede calcular posteriormente
-- el porcentaje de órdenes no rentables sobre el total,
-- lo que aporta mayor profundidad al análisis financiero.


-- -----------------------------------------------------
-- 2.5 Impacto porcentual de órdenes con pérdidas
-- -----------------------------------------------------
-- Objetivo:
-- Determinar el porcentaje de registros con ganancias
-- negativas respecto al total de operaciones,
-- para contextualizar su peso dentro del dataset.
-- -----------------------------------------------------

SELECT 
    COUNT(*) AS total_registros,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS total_perdidas,
    ROUND(
        SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS porcentaje_perdidas
FROM orders;

-- Interpretación:
-- Esta consulta permite evaluar la magnitud real
-- de las órdenes con pérdida dentro del total
-- de registros del dataset.
--
-- A diferencia de solo contar las pérdidas,
-- aquí se obtiene también su proporción porcentual,
-- lo que facilita un análisis más estratégico.
--
-- El análisis muestra que, de un total de 9.694 registros,
-- 1.808 corresponden a ventas con pérdida, lo que representa
-- un 18,65% del total de operaciones.
--
-- Esto indica que aproximadamente 2 de cada 10 ventas no generan ganancia,
-- lo cual puede impactar de manera significativa en la rentabilidad
-- general del negocio.


-- -----------------------------------------------------
-- 3. Cantidad total de registros
-- Objetivo:
-- Calcular el número total de transacciones registradas,
-- estableciendo la base cuantitativa del análisis.
-- -----------------------------------------------------

SELECT COUNT(*) AS total_registros
FROM orders;

-- Interpretación:
-- El dataset contiene 9694 registros de ventas,
-- lo que representa el total de transacciones analizadas.

-- -----------------------------------------------------
-- 4. Ventas totales
-- Objetivo:
-- Calcular el total de ingresos generados durante
-- el período analizado, con el fin de conocer
-- el volumen general del negocio.
-- -----------------------------------------------------

SELECT ROUND(SUM(Sales),2) AS ventas_totales
FROM orders;

-- Interpretación:
-- La empresa generó un total de 2,272,499.86 en ventas
-- durante el período analizado, lo que refleja el volumen
-- general de ingresos del negocio.

-- -----------------------------------------------------
-- 5. Ventas por categoría
-- Objetivo:
-- Analizar las ventas agrupadas por categoría
-- para identificar cuáles generan mayor participación
-- en los ingresos.
-- -----------------------------------------------------

SELECT Category,
       ROUND(SUM(Sales),2) AS ventas_totales
FROM orders
GROUP BY Category
ORDER BY ventas_totales DESC;

-- Interpretación:
-- Esta consulta permite identificar cuál categoría
-- tiene mayor participación en los ingresos y cuál
-- presenta menor volumen de ventas.
-- Mayor participación ingresos (Technology) 835,900.07
-- Menor volumen de ventas (Office Supplies) 703,502.93

-- -----------------------------------------------------
-- 6. Ventas por región
-- Objetivo:
-- Analizar el desempeño comercial por región geográfica,
-- con el objetivo de identificar concentraciones
-- de ventas y posibles oportunidades de crecimiento.
-- -----------------------------------------------------

SELECT Region,
       ROUND(SUM(Sales),2) AS ventas_totales
FROM orders
GROUP BY Region
ORDER BY ventas_totales DESC;

-- Interpretación:
-- Se observa qué región concentra mayor volumen
-- de ventas y cuáles tienen menor participación,
-- lo que puede ayudar a detectar oportunidades
-- de crecimiento.

-- -----------------------------------------------------
-- 7. Top 10 clientes por volumen de compra
-- Objetivo:
-- Identificar los clientes con mayor volumen de compra,
-- para evaluar su importancia dentro de la estructura
-- de ingresos del negocio.
-- -----------------------------------------------------

SELECT `Customer Name`,
       ROUND(SUM(Sales), 2) AS total_comprado
FROM orders
GROUP BY `Customer Name`
ORDER BY total_comprado DESC
LIMIT 10;

-- Interpretación:
-- Se identifican los clientes con mayor nivel
-- de compra, lo que puede ser útil para estrategias
-- de fidelización o programas especiales.

-- -----------------------------------------------------
-- 8. Rentabilidad por categoría
-- Objetivo:
-- Comparar las ventas totales con la ganancia obtenida
-- por categoría, con el propósito de evaluar
-- el desempeño financiero de cada segmento.
-- -----------------------------------------------------

SELECT Category,
       ROUND(SUM(Sales),2) AS ventas_totales,
       ROUND(SUM(Profit),2) AS ganancia_total
FROM orders
GROUP BY Category
ORDER BY ganancia_total DESC;

-- Interpretación:
-- Esta consulta permite evaluar no solo cuánto se vende,
-- sino cuánto se gana realmente por categoría.
-- Una categoría puede vender mucho pero generar
-- menor rentabilidad 
-- (Furniture) mayor venta 733,046.86 que (Office Supplies) pero menos rentabilidad 16,980.77
-- (Office Supplies) venta 703,502.93 rentabilidad 120,489.89

-- -----------------------------------------------------
-- 9. Ventas mensuales
-- Objetivo:
-- Analizar la evolución mensual de las ventas
-- para identificar tendencias, comportamientos
-- estacionales y variaciones en el tiempo.
-- -----------------------------------------------------

SELECT DATE_FORMAT(
           STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
           '%Y-%m'
       ) AS mes,
       ROUND(SUM(Sales),2) AS ventas_mensuales
FROM orders
GROUP BY mes
ORDER BY mes;

-- Interpretación:
-- Permite observar la tendencia mensual de ventas,
-- identificar posibles picos estacionales y evaluar
-- el crecimiento del negocio a lo largo del tiempo.

-- =====================================================
-- ======
-- 📊 CONCLUSIÓN FINAL DEL PROYECTO
-- =====================================================
-- ======

-- Tras realizar la validación inicial y el análisis completo
-- del dataset "orders", se confirma que la información
-- se encuentra estructurada correctamente y sin valores nulos
-- en las variables clave analizadas.

-- El dataset contiene un total de 9,694 registros,
-- lo que representa el volumen total de transacciones evaluadas.

-- Se identificó la existencia de registros con ganancias negativas.
-- En total, 1,808 órdenes presentan pérdidas,
-- lo que equivale al 18.65% del total de operaciones.
-- Esto indica que aproximadamente 2 de cada 10 ventas
-- no generan rentabilidad, lo que representa
-- un punto crítico para la estrategia financiera.

-- Las ventas totales alcanzan 2,272,499.86,
-- reflejando el volumen general de ingresos del negocio.

-- En el análisis por categoría, Technology lidera
-- en generación de ingresos, mientras Office Supplies
-- presenta el menor volumen de ventas.
-- Sin embargo, el análisis de rentabilidad demuestra
-- que no siempre la categoría que más vende
-- es la que mayor ganancia genera.

-- El análisis por región permite identificar
-- diferencias en el desempeño comercial,
-- lo que puede orientar estrategias de expansión
-- o fortalecimiento en zonas específicas.

-- El estudio del Top 10 de clientes revela
-- una concentración relevante de ingresos,
-- lo que sugiere la importancia de estrategias
-- de fidelización y gestión de clientes clave.

-- Finalmente, el análisis mensual permite observar
-- el comportamiento de las ventas a lo largo del tiempo,
-- identificando variaciones y posibles patrones estacionales.

-- =====================================================
-- ======
-- 🎯 CONCLUSIÓN ESTRATÉGICA
-- =====================================================
-- ======

-- El proyecto confirma que, aunque el negocio
-- presenta un volumen sólido de ventas,
-- existe un porcentaje significativo de operaciones
-- no rentables que puede impactar la utilidad general.

-- Por lo tanto, se recomienda profundizar en:
-- • Análisis de productos con baja rentabilidad.
-- • Evaluación de descuentos y estructura de costos.
-- • Estrategias de optimización en categorías con pérdidas.
-- • Fortalecimiento de relaciones con clientes de alto valor.

-- Este análisis proporciona una base sólida
-- para la toma de decisiones estratégicas
-- orientadas a mejorar la rentabilidad del negocio.
-- =====================================================