-- Ejercicios de SQL
-- Para esta evaluación usaremos la BBDD de northwind con la que ya estamos familiarizadas de los ejercicios de pair programming. En esta evaluación tendréis que contestar a las siguientes preguntas:
-- 1. Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, que tengan stock en el almacén, y al mismo tiempo que sus precios unitarios estén entre 50 y 100. Por último, ordena los resultados por código de proveedor de forma ascendente.

SELECT *
FROM products
WHERE 				supplier_id IN (1, 3, 7, 8, 9)
				AND    units_in_stock > 0
                AND 	unit_price BETWEEN 50 AND 100

ORDER BY supplier_id;

-- 2. Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, además que hayan vendido a clientes que tengan códigos que comiencen con las letras de la A hasta la G. Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año.

SELECT employees.first_name, employees.last_name, employees.employee_id
FROM employees
INNER JOIN orders
ON employees.employee_id = orders.employee_id

	WHERE 			(MONTH(orders.order_date) = 12 AND DAY(orders.order_date) >= 22
				OR   	 MONTH(orders.order_date) = 12 AND DAY(orders.order_date) <= 31)
                
                AND orders.customer_id REGEXP '^[A-G].*'
                
                AND employees.employee_id BETWEEN 3 AND 6
;

-- 3. Calcula el precio de venta de cada pedido una vez aplicado el descuento. Muestra el
-- order_id, el id del producto, el nombre del producto, el precio unitario, la cantidad, el descuento 
-- y el precio de venta después de haber aplicado el descuento.

SELECT order_id, product_id, product_name, unit_price, quantity, discount ,
((unit_price * quantity) * (1 - discount)) AS TotalPedido
FROM order_details
NATURAL  JOIN products;



-- 4. Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio
--  medio total de los productos de la BBDD.

SELECT product_name, product_id, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price)
									FROM products);
                                    
-- 5. ¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?

SELECT e.employee_id, e.first_name, e.last_name, p.product_name,  COUNT(od.quantity) AS CantidadTotal
FROM employees AS e
						INNER JOIN orders
							ON e.employee_id = orders.employee_id
						INNER JOIN order_details AS od
							ON od.order_id = orders.order_id
						INNER JOIN products AS p
							ON p.product_id = od.product_id
                            
GROUP BY employee_id, product_name;


-- 6. Basándonos en la query anterior, ¿qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery


SELECT first_name , last_name, COUNT(product_name) AS "Productos_vendidos"

    FROM (		SELECT DISTINCT first_name, last_name, e.employee_id, product_name
							FROM employees AS e
							INNER JOIN orders AS o
							ON e.employee_id = o.employee_id
							INNER JOIN order_details AS od
							ON od.order_id = o.order_id
							INNER JOIN products AS p
							ON od.product_id = p.product_id) AS TablaTemporal
GROUP BY employee_id
ORDER BY Productos_vendidos DESC
LIMIT 1;

			-- La empleada que más productos vende es Margaret Peacock con un total de 75.
			-- Hay que contar por product_name porque porque product_id está en diferentes tablas.
    

-- 7. BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?

WITH Empleados_Productos 
AS (
			SELECT DISTINCT first_name , last_name , e.employee_id , product_name
			FROM employees AS e
			INNER JOIN orders AS o
				ON e.employee_id = o.employee_id
			INNER JOIN order_details AS od
				ON od.order_id = o.order_id
			INNER JOIN products AS p
				ON od.product_id = p.product_id)
                
SELECT first_name, last_name, COUNT(Product_name) AS "Productos_Vendidos"
FROM empleados_productos
GROUP BY employee_id;  
                
                
                


			
  