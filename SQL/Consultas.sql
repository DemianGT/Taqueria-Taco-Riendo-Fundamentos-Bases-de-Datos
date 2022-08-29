-- C1. Obtener nombre, rfc, estado, email y salario de los empleados con mayor 
-- y menor sueldo.
SELECT nombre, rfc, estado, email, salario
FROM cliente
WHERE salario = (SELECT MIN (salario)
	             FROM cliente
	             WHERE esEmpleado = true) or
	  salario = (SELECT MAX(salario) 
			     FROM cliente
			     WHERE esEmpleado = true);
                 
-- C2. Obtener el nombre, curp y fecha de nacimiento de los empleados cuya edad es 
-- mayor que 60 o menor que 20.
SELECT nombre,curp,nacimiento
FROM cliente
WHERE (nacimiento < '1962-01-01' OR nacimiento > '2002-12-31') AND esEmpleado = true;

-- C3. Obtener el total de ventas por comida durante el año 2020 en la sucursal
-- Rand Casey.
SELECT SUM(precioactual) AS ganancias
FROM registrarComida NATURAL JOIN ticket
WHERE nombresucursal = 'Rand Casey' AND (fecha >= '2020-01-01' and fecha <= '2020-12-31');

-- C4. Obtener el nombre de las comidas que requieren limón para su preparación.
SELECT nombre
FROM comida
WHERE idcomida IN (SELECT DISTINCT idcomida
				   FROM insumo NATURAL JOIN PrepararComida
				   WHERE nombre = 'Limon');

-- C5. Obtener la fecha del último y penúltimo cambio de precio del té de pera.
SELECT nombre, MAX(fechadecambio)
FROM registroPrecioBebida NATURAL JOIN bebida
WHERE nombre = 'Te de Pera'
GROUP BY nombre
UNION
SELECT nombre, MAX(fechadecambio)
FROM (SELECT nombre, fechadecambio
FROM registroPrecioBebida NATURAL JOIN bebida        
WHERE nombre = 'Te de Pera'
EXCEPT
SELECT nombre, MAX(fechadecambio)
FROM registroPrecioBebida NATURAL JOIN bebida                                  
WHERE nombre = 'Te de Pera'
GROUP BY nombre) AS laSegundaMaxima
GROUP BY nombre
ORDER BY MAX DESC;

-- C6. Obtener el nombre de las comidas recomendadas con una salsa de 
-- nivel de picor 5.
SELECT nombre
FROM comida
WHERE idComida IN (SELECT DISTINCT idComida
                   FROM salsa NATURAL JOIN recomendar
                   WHERE nivelPicor = 5); 
                   
-- C7. Obtener la cantidad de bebidas que se ha vendido de la bebida mas cara.
SELECT COUNT(nombre)
FROM Bebida NATURAL JOIN registrarBebida
WHERE nombre = (SELECT nombre
                FROM Bebida
                WHERE precioActual = (SELECT MAX (precioActual)
					                  FROM Bebida));

-- C8. Obtener todos los empleados con salario mayor o igual al promedio.
SELECT nombre, rfc, salario, telefono
FROM cliente
WHERE salario >= (SELECT AVG(salario)
			      FROM cliente
			      WHERE esEmpleado!=false)
ORDER BY salario;

-- C9. Calcula el total de la compra por comida de un cliente en especifico 
-- (la cliente Saundra) en la sucursal Rand Casey.
SELECT SUM(precioactual)
FROM registrarComida NATURAL JOIN ticket
WHERE nombresucursal = 'Rand Casey' AND curpcliente = (SELECT curpcliente
                                                       FROM ticket
                                                       WHERE nombrecliente = 'Saundra');

-- C10. Obtener el número de sucursales en cada estado.
SELECT estado, COUNT(rfc) AS nosucursales
FROM sucursal
GROUP BY estado;

-- C11. Obtener curp y rfc de todos los empleados que se desempeñen como parrilleros en cualquier 
-- sucursal que no este ubicada en Colorado o Pennsylvania.
SELECT curp, rfc,estado
FROM parrillero NATURAL JOIN sucursal
WHERE estado NOT IN ('Colorado', 'Pennsylvania');

-- C12. Obtener el número de tickets que ha registrado cada sucursal en Texas así como la fecha en 
-- la que registró su primer ticket.
SELECT COUNT(idticket) as notickets, nombresucursal, MIN(fecha) as fechaprimerticket
FROM ticket NATURAL JOIN sucursal
WHERE estado = 'Texas'
GROUP BY nombresucursal;

-- C13. Obtener el nombre y curp de todos los clientes que hayan nacido antes de 1970 o cuyo nombre 
-- empiece con la cadena Pa y no usen una tarjeta de crédito como método de pago.
SELECT nombre, curp
FROM cliente NATURAL JOIN metodopago
WHERE ((nacimiento < '1970-01-01' OR nombre LIKE 'Pa%') AND escredito = false);

-- C14. Obtener el número de taqueros contratados en cada sucursal en California.
SELECT nombre AS sucursal, COUNT(curp) AS notaqueros
FROM sucursal NATURAL JOIN taquero
WHERE estado = 'California'
GROUP BY sucursal;

-- C15. Obtener el total de ventas realizadas por cada salsa con distinto nivel de picor.
SELECT nivelpicor, SUM(precioactual) AS totalventas
FROM salsa NATURAL JOIN registrarsalsa
GROUP BY nivelpicor;

-- C16. Obtener el número de clientes atendidos en cada sucursal durante el tercer y cuarto
-- trimestre del 2020.
SELECT nombresucursal, count(nombrecliente) AS clientesatendidos
FROM ticket
WHERE ('2020-07-01' >= fecha AND fecha <= '2020-12-31')
GROUP BY nombresucursal;

-- C17. Obtener el nombre y precio del insumo cuyo cambio de precio es el más reciente.
SELECT nombre, precio, fechadecambio
FROM insumo NATURAL JOIN registroprecioinsumo
WHERE fechadecambio = (SELECT MAX (fechadecambio)
                       FROM registroprecioinsumo);
