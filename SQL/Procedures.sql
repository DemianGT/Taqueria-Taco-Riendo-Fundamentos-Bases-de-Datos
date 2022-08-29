

-- *************************** FUNCIÓN AUXILIAR PARA PROCEDIMIENTO 1 ***************************


---------------------------------------------------------------------------------------------------
-- Función que nos devuelve los años de antiguedad que tiene un cliente laborando en una sucursal.
---------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION aniosAntiguedad(curpEmpl CHAR(18))
	RETURNS INT
	AS $$
	DECLARE antiguedad INT;
	DECLARE inicio DATE;
	BEGIN
	    SELECT fechaInicio into inicio from Cliente where curp = curpEmpl;
		antiguedad := CAST ((SELECT EXTRACT(YEAR FROM age(now(), date(inicio)))) AS INT);
    RETURN antiguedad;
	END;
	$$
	LANGUAGE plpgsql;	
	
	
-- *********************************** PROCEDIMIENTO 1 ***********************************

---------------------------------------------------------------------------------------------
-- Procedimiento que le aumenta 1500 al salario de un empleado con más de 2 años de antiguedad.
---------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE bonosEmpleado(curpE CHAR(18))
	AS $$
	DECLARE esEmple BOOLEAN;
	DECLARE aniosTrabajando INT;
	BEGIN
	    IF(NOT EXISTS (SELECT * FROM Cliente WHERE curp = curpE)) THEN
			RAISE EXCEPTION 'NO FUE POSIBLE ENCONTRAR AL EMPLEADO';
		ELSE 
		    SELECT esEmpleado into esEmple from Cliente where curp = curpE;
		    IF (esEmple = 'false') THEN
				 RAISE EXCEPTION 'LA CURP % PERTENECE A UN CLIENTE Y NO A UN EMPLEADO', curpE;
			ELSE 
				aniosTrabajando := aniosAntiguedad(CAST(curpE AS CHAR(18)));
				IF (aniosTrabajando >= 2) THEN
					UPDATE Cliente SET salario = salario + 1500 WHERE curp = curpE;
				END IF;
			END IF;
	    END IF;   	
	END;
	$$
	Language plpgsql;


-- ************************************ PRUEBA PROCEDIMIENTO 1 ************************************

-- Consulta la tabla de los empleados.	
   SELECT curp, nombre, fechaInicio, salario FROM Cliente WHERE esEmpleado = 'true';
   
-- Atualizamos el saldo de un empleado que ha laborado más de dos años en una Sucursal.
-- (Es el primer empleado de la tabla)
	CALL bonosEmpleado('MOMR363569VDDYEMES');

	
	
	
	
	
	
	
------------------------------------------------------------------------------------------------------------------------------------------
	
	
-- *************************** FUNCIÓN AUXILIAR PARA PROCEDIMIENTO 2 ***************************


---------------------------------------------------------------------------------------------------
-- Función que nos devuelve la cuenta total de lo que ha consumido un cliente.
---------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION cuentaTotalTicket(idCliente CHAR(18))
	RETURNS FLOAT
	AS 
	$$
	DECLARE totalSalsa FLOAT;
	DECLARE totalBebida FLOAT;
	DECLARE totalComida FLOAT;
	DECLARE cuentaTotal FLOAT;
	BEGIN
	    IF NOT EXISTS (SELECT * FROM Cliente WHERE curp = idCliente) THEN
		   RAISE EXCEPTION 'El cliente con id % no existe', idCliente;
		END IF;
		--Sumamos los precios de todo lo que ha consumido el cliente en comidas.
		SELECT COALESCE(sum(precioActual),0) INTO totalComida FROM Ticket JOIN RegistrarComida ON Ticket.idTicket = RegistrarComida.idTicket
		WHERE Ticket.curpCliente =  idCliente;
		--Sumamos los precios de todo lo que ha consumido el cliente en salsas.
		SELECT COALESCE(sum(precioActual),0) INTO totalSalsa FROM Ticket JOIN RegistrarSalsa ON Ticket.idTicket = RegistrarSalsa.idTicket
		WHERE Ticket.curpCliente =  idCliente;
		--Sumamos los precios de todo lo que ha consumido el cliente en bebidas.
		SELECT COALESCE(sum(precioActual),0) INTO totalBebida FROM Ticket JOIN RegistrarBebida ON Ticket.idTicket = RegistrarBebida.idTicket
		WHERE Ticket.curpCliente =  idCliente;
		cuentaTotal = totalSalsa + totalComida + TotalBebida;
		RETURN cuentaTotal;
	END;
	$$
	LANGUAGE plpgsql;
	

-- *********************************** PROCEDIMIENTO 2 ***********************************

-----------------------------------------------------------------
-- Esta tabla almacenará los puntos que tiene un Cliente.
-----------------------------------------------------------------
CREATE TABLE PuntosCliente(
	curpCliente CHAR(18) NOT NULL CHECK(curpCliente <> '') UNIQUE,
	puntosTotales INT NOT NULL CHECK(puntosTotales >= 0),
	PRIMARY KEY(curpCliente)
);

---------------------------------------------------------------------------
-- Procedimiento que almacenará en una Tabla los puntos que tiene un cliente.
---------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE taquero_Corazon(idCliente CHAR(18))
	AS $$
	DECLARE cuentaTotal FLOAT;
	DECLARE puntos FLOAT;
	BEGIN
	    IF(NOT EXISTS (SELECT * FROM Cliente WHERE curp = idCliente)) THEN
			RAISE EXCEPTION 'EL CLIENTE CON CURP % NO EXISTE', idCliente;
		ELSE 
			cuentaTotal := cuentaTotalTicket(idCliente);
			puntos := cuentaTotal * 0.10;
			INSERT INTO PuntosCliente(curpCliente, puntosTotales) VALUES (idCliente, puntos);	
	    END IF;   	
	END;
	$$
	Language plpgsql;



-- ************************************ PRUEBA PROCEDIMIENTO 2 ************************************

-- Consulta la tabla de los clientes.	
   SELECT * FROM Cliente;
   
-- Obtenemos los puntos de un cliente en particular.
-- (Es el primer cliente de la tabla).
	CALL taquero_Corazon('MOMR363569VDDYEMES');
	
-- Consulta la tabla de puntos de los Clientes.	
   SELECT * FROM PuntosCliente;