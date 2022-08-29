/*
Script para la creación de la base de datos Taco Riendo
*/

--Creacion del esquema
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
COMMENT ON SCHEMA public IS 'El esquema que viene por defecto en postgres';

/*
  ------------------------------------------------  TABLAS  ------------------------------------------------------
*/


/* ------------------------------------------------  PRIMARIAS  ------------------------------------------------------ */

-- Proveedor

CREATE TABLE Proveedor(
	rfc CHAR(13) NOT NULL CHECK(rfc <> '') UNIQUE,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	paterno VARCHAR(50) NOT NULL CHECK(paterno <> ''),
	materno VARCHAR(50) NOT NULL CHECK(materno <> ''),
	marca VARCHAR(50) NOT NULL CHECK(marca <> ''),
	telefono CHAR(10) NOT NULL CHECK(telefono SIMILAR TO '[0-9]{10}'),
	calle VARCHAR(50) NOT NULL CHECK(calle <> ''),
	numero CHAR(4) NOT NULL CHECK(numero SIMILAR TO '[0-9]{4}'),
	estado VARCHAR NOT NULL CHECK(estado <> ''),
	cp CHAR(5) NOT NULL CHECK(cp SIMILAR TO '[0-9]{5}'),
	email VARCHAR(50) NOT NULL CHECK(email <> '')
);

-- Insumo

CREATE TABLE Insumo(
	idInsumo CHAR(10) NOT NULL CHECK(idInsumo <> '') UNIQUE,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> '')
);
-- Salsa

CREATE TABLE Salsa(
	idSalsa CHAR(10) NOT NULL CHECK (idSalsa<>'') UNIQUE,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	descripcion VARCHAR(100) NOT NULL CHECK(descripcion <> ''),
	presentacion VARCHAR(50) NOT NULL CHECK(presentacion <> ''),
	nivelPicor INT NOT NULL CHECK(nivelPicor >=1 AND nivelPicor <=5),
	precioActual FLOAT NOT NULL CHECK(precioActual > 0)
);

-- Comida

CREATE TABLE Comida(
	idComida CHAR(10) NOT NULL CHECK (idComida<>'') UNIQUE,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	descripcion VARCHAR(100) NOT NULL CHECK(descripcion <> ''),
	precioActual FLOAT NOT NULL CHECK(precioActual > 0)
);

-- Bebida

CREATE TABLE Bebida(
	idBebida CHAR(10) NOT NULL CHECK (idBebida<>'') UNIQUE,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	descripcion VARCHAR(100) NOT NULL CHECK(descripcion <> ''),
	sabor VARCHAR(20) NOT NULL CHECK(sabor <> ''),
	cantidadML VARCHAR(10) NOT NULL CHECK(cantidadML <> ''),
	precioActual FLOAT NOT NULL CHECK(precioActual > 0)
);

-- Cliente

CREATE TABLE Cliente(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	paterno VARCHAR(50) NOT NULL CHECK(paterno <> ''),
	materno VARCHAR(50) NOT NULL CHECK(materno <> ''),
	telefono CHAR(10) NOT NULL CHECK(telefono SIMILAR TO '[0-9]{10}'),
	calle VARCHAR(50) NOT NULL CHECK(calle <> ''),
	numero CHAR(4) NOT NULL CHECK(numero SIMILAR TO '[0-9]{4}'),
	estado VARCHAR NOT NULL CHECK(estado <> ''),
	cp CHAR(5) NOT NULL CHECK(cp SIMILAR TO '[0-9]{5}'),
	email VARCHAR(50) NOT NULL CHECK(email <> ''),
	rfc CHAR(13) CHECK(rfc <> ''),
	nSS CHAR(11) CHECK(nSS SIMILAR TO '[0-9]{11}'),
	nacimiento DATE NOT NULL CHECK(nacimiento > '1950-01-01' AND nacimiento < '2004-01-01'),
	salario FLOAT CHECK(salario>0),
	fechaInicio DATE CHECK(fechaInicio > '2000-01-01' AND fechaInicio < '2022-01-01'),
	esEmpleado BOOLEAN NOT NULL
	
);
--Inventario

CREATE TABLE Inventario(
	idInventario CHAR(10) NOT NULL CHECK(idInventario <> '') UNIQUE
);

-- Promocion

CREATE TABLE Promocion(
	idPromocion CHAR(50) NOT NULL CHECK(idPromocion <> ''),
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	descuento FLOAT NOT NULL CHECK (descuento > 0),
	diaPromo VARCHAR(10) NOT NULL CHECK(diaPromo <> ''),
	descripcion VARCHAR(100) NOT NULL CHECK(descripcion <> '')
);

/* ------------------------------------------------  COMPUESTAS  ------------------------------------------------------ */


-- RegistroPrecioInsumo

CREATE TABLE RegistroPrecioInsumo(
	idInsumo CHAR(10) NOT NULL CHECK (idInsumo<>''),
	registroPrecioInsumo CHAR(10) NOT NULL CHECK (registroPrecioInsumo<>'') UNIQUE,
	precio FLOAT NOT NULL CHECK (precio > 0),
	fechaDeCambio DATE NOT NULL CHECK(fechaDeCambio > '2000-01-01' AND fechaDeCambio < '2022-01-01') 
);

-- RegistroPrecioSalsa

CREATE TABLE RegistroPrecioSalsa(
	idSalsa CHAR(10) NOT NULL CHECK (idSalsa<>''),
	registroPrecioSalsa CHAR(10) NOT NULL CHECK (registroPrecioSalsa<>''),
	precio FLOAT NOT NULL CHECK (precio > 0),
	fechaDeCambio DATE NOT NULL CHECK(fechaDeCambio > '2000-01-01' AND fechaDeCambio < '2022-01-01') 
);

-- RegistroPrecioComida

CREATE TABLE RegistroPrecioComida(
	idComida CHAR(10) NOT NULL CHECK (idComida<>''),
	registroPrecioComida CHAR(10) NOT NULL CHECK (registroPrecioComida<>''),
	precio FLOAT NOT NULL CHECK (precio > 0),
	fechaDeCambio DATE NOT NULL CHECK(fechaDeCambio > '2000-01-01' AND fechaDeCambio < '2022-01-01') 
);

-- RegistroPrecioBebida

CREATE TABLE RegistroPrecioBebida(
	idBebida CHAR(10) NOT NULL CHECK (idBebida<>''),
	registroPrecioBebida CHAR(10) NOT NULL CHECK (registroPrecioBebida<>''),
	precio FLOAT NOT NULL CHECK (precio > 0),
	fechaDeCambio DATE NOT NULL CHECK(fechaDeCambio > '2000-01-01' AND fechaDeCambio < '2022-01-01') 
);
-- Transporte

CREATE TABLE Transporte(
	curp CHAR(18) NOT NULL CHECK (curp<>'') UNIQUE,
	idTransporte CHAR(10) NOT NULL CHECK (idTransporte<>'') UNIQUE,
	tipo VARCHAR(50) NOT NULL CHECK (tipo<>''),
	marca VARCHAR(50) NOT NULL CHECK (marca<>''),
	modelo VARCHAR(50) NOT NULL CHECK (modelo<>'')
);
/* ------------------------------------------------  MEZCLADAS  ------------------------------------------------------ */

-- Ticket

CREATE TABLE Ticket(
	idTicket CHAR(10) NOT NULL CHECK(idTicket <> '') UNIQUE,
	rfc CHAR(13) NOT NULL,
	curpCliente CHAR(18) NOT NULL,
	curpMesero CHAR(18) NOT NULL,
	nombreSucursal VARCHAR(50) NOT NULL CHECK(nombreSucursal <> ''),
	nombreCliente VARCHAR(50) NOT NULL CHECK(nombreCliente <> ''),
	nombreMesero VARCHAR(50) NOT NULL CHECK(nombreMesero <> ''),
	fecha DATE NOT NULL CHECK(fecha > '2000-01-01' AND fecha < '2022-01-01')
);

--Sucursal

CREATE TABLE Sucursal(
	rfc CHAR(13) NOT NULL CHECK(rfc <> '') UNIQUE,
	idInventario CHAR(10),
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	calle VARCHAR(50) NOT NULL CHECK(calle <> ''),
	alcaldia VARCHAR(50) NOT NULL CHECK(alcaldia <> ''),
	cp CHAR(5) NOT NULL CHECK(cp <> '[0-9]{5}'),
	estado VARCHAR(50) NOT NULL CHECK(estado <> ''),
	numero CHAR(4) NOT NULL CHECK(numero SIMILAR TO '[0-9]{4}'),
	email VARCHAR(50) NOT NULL CHECK(email <> ''),
	telefono CHAR(10) NOT NULL CHECK(telefono SIMILAR TO '[0-9]{10}')
);

--MetodoPago

CREATE TABLE MetodoPago(
	idPago CHAR(10) NOT NULL CHECK(idPago <> '') UNIQUE,
	curp CHAR(18) NOT NULL,
	cantidad FLOAT NOT NULL CHECK(cantidad>0),
	nombreTitular VARCHAR(50) NOT NULL CHECK(nombreTitular <> ''),
	esEfectivo BOOLEAN NOT NULL,
	esPuntos BOOLEAN NOT NULL,
	esDebito BOOLEAN NOT NULL,
	esCredito BOOLEAN NOT NULL

);

/* ------------------------------------------------  FORANEAS  ------------------------------------------------------ */

-- Proveer

CREATE TABLE Proveer(
	idInsumo CHAR(10) NOT NULL CHECK (idInsumo <>''),
	rfc CHAR(13) NOT NULL CHECK (rfc<>''),
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> '')
);

-- Tener Insumo
CREATE TABLE TenerInsumo(
	idInventario CHAR(10) NOT NULL CHECK(idInventario <> ''),
	idInsumo CHAR(10) NOT NULL,
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	precio FLOAT NOT NULL CHECK(precio>0),
	cantidad INT NOT NULL CHECK(cantidad>0),
	caducidad DATE CHECK(caducidad > '2022-01-01'),
	diaCompra DATE NOT NULL CHECK(diaCompra > '2000-01-01' AND diaCompra < '2022-01-01'),
	marcaProducto VARCHAR(50) NOT NULL CHECK(marcaProducto <> '')
);
-- PrepararSalsa

CREATE TABLE PrepararSalsa(
	idInsumo CHAR(10) NOT NULL CHECK (idInsumo<>''),
	idSalsa CHAR(10) NOT NULL CHECK (idSalsa<>''),
	cantidad INT NOT NULL CHECK(cantidad > 0)
);

-- PrepararComida

CREATE TABLE PrepararComida(
	idInsumo CHAR(10) NOT NULL CHECK (idInsumo<>''),
	idComida CHAR(10) NOT NULL CHECK (idComida<>''),
	cantidad INT NOT NULL CHECK(cantidad > 0)
);

-- PrepararBebida

CREATE TABLE PrepararBebida(
	idInsumo CHAR(10) NOT NULL CHECK (idInsumo<>''),
	idBebida CHAR(10) NOT NULL CHECK (idBebida<>''),
	cantidad INT NOT NULL CHECK(cantidad > 0)
);

-- TenerPromocion

CREATE TABLE TenerPromocion(
	idPromocion CHAR(50) NOT NULL CHECK(idPromocion <> ''),
	idComida CHAR(10) NOT NULL CHECK(idComida <> '')
);

-- RegistrarSalsa

CREATE TABLE RegistrarSalsa(
	idTicket CHAR(10) NOT NULL CHECK (idTicket<>''),
	idSalsa CHAR(10) NOT NULL CHECK (idSalsa<>''),
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	precioActual FLOAT NOT NULL CHECK(precioActual > 0)
);

-- RegistrarComida

CREATE TABLE RegistrarComida(
	idTicket CHAR(10) NOT NULL CHECK (idTicket<>''),
	idComida CHAR(10) NOT NULL CHECK (idComida<>''),
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	precioActual FLOAT NOT NULL CHECK(precioActual > 0)
);

-- RegistrarBebida

CREATE TABLE RegistrarBebida(
	idTicket CHAR(10) NOT NULL CHECK (idTicket<>''),
	idBebida CHAR(10) NOT NULL CHECK (idBebida<>''),
	nombre VARCHAR(50) NOT NULL CHECK(nombre <> ''),
	precioActual FLOAT NOT NULL CHECK(precioActual > 0)
);

-- Recomendar

CREATE TABLE Recomendar(
	idSalsa CHAR(10) NOT NULL CHECK (idSalsa <>''),
	idComida CHAR(10) NOT NULL CHECK (idComida <>'')
);

-- Mesero

CREATE TABLE Mesero(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	rfc CHAR(13) NOT NULL CHECK(rfc <> '')
);
-- Parrillero

CREATE TABLE Parrillero(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	rfc CHAR(13) NOT NULL CHECK(rfc <> '')
);
-- Taquero

CREATE TABLE Taquero(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	rfc CHAR(13) NOT NULL CHECK(rfc <> '')
);
-- Repartidor

CREATE TABLE Repartidor(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	rfc CHAR(13) NOT NULL CHECK(rfc <> ''),
	numLicencia CHAR(10) CHECK(numLicencia <> ''), 
	transporte VARCHAR(20) CHECK(transporte = 'Bicicleta' OR transporte = 'Motocicleta') 
);
-- Tortillero

CREATE TABLE Tortillero(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	rfc CHAR(13) NOT NULL CHECK(rfc <> '')
);
-- Cajero

CREATE TABLE Cajero(
	curp CHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp) = 18) CHECK(curp SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{8}') UNIQUE,
	rfc CHAR(13) NOT NULL CHECK(rfc <> '')
);

/*------------------------------------------------  LLAVES  ------------------------------------------------------*/


/*********************************** Llaves Primarias Normales ***********************************/

--Llave Proveedor
ALTER TABLE Proveedor ADD CONSTRAINT Proveedor_pkey PRIMARY KEY(rfc);
--Llaves Insumo
ALTER TABLE Insumo ADD CONSTRAINT Insumo_pkey PRIMARY KEY(idInsumo);
--Llave Salsa
ALTER TABLE Salsa ADD CONSTRAINT Salsa_pkey PRIMARY KEY(idSalsa);
--Llave Comida
ALTER TABLE Comida ADD CONSTRAINT Comida_pkey PRIMARY KEY(idComida);
--Llave Bebida
ALTER TABLE Bebida ADD CONSTRAINT Bebida_pkey PRIMARY KEY(idBebida);
--Llave Cliente
ALTER TABLE Cliente ADD CONSTRAINT Cliente_pkey PRIMARY KEY(curp); 
--Llaves Inventario
ALTER TABLE Inventario ADD CONSTRAINT Inventario_pkey PRIMARY KEY(idInventario);
--Llaves Promocion
ALTER TABLE Promocion ADD CONSTRAINT Promocion_pkey PRIMARY KEY(idPromocion);
/*********************************** Llaves Primarias Compuestas ***********************************/

--Llaves RegistroPrecioInsumo
ALTER TABLE RegistroPrecioInsumo ADD CONSTRAINT RegistroPrecioInsumo_pkey PRIMARY KEY(idInsumo, registroPrecioInsumo);
ALTER TABLE RegistroPrecioInsumo ADD CONSTRAINT RegistroPrecioInsumo_fkey FOREIGN KEY(idInsumo)
REFERENCES Insumo(idInsumo) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves RegistroPrecioSalsa
ALTER TABLE RegistroPrecioSalsa ADD CONSTRAINT RegistroPrecioSalsa_pkey PRIMARY KEY(idSalsa, registroPrecioSalsa);
ALTER TABLE RegistroPrecioSalsa ADD CONSTRAINT RegistroPrecioSalsa_fkey FOREIGN KEY(idSalsa)
REFERENCES Salsa(idSalsa) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves RegistroPrecioComida
ALTER TABLE RegistroPrecioComida ADD CONSTRAINT RegistroPrecioComida_pkey PRIMARY KEY(idComida, registroPrecioComida);
ALTER TABLE RegistroPrecioComida ADD CONSTRAINT RegistroPrecioComida_fkey FOREIGN KEY(idComida)
REFERENCES Comida(idComida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves RegistroPrecioBebida
ALTER TABLE RegistroPrecioBebida ADD CONSTRAINT RegistroPrecioBebida_pkey PRIMARY KEY(idBebida, registroPrecioBebida);
ALTER TABLE RegistroPrecioBebida ADD CONSTRAINT RegistroPrecioBebida_fkey FOREIGN KEY(idBebida)
REFERENCES Bebida(idBebida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Transporte
ALTER TABLE Transporte ADD CONSTRAINT Transporte_pkey PRIMARY KEY(curp, idTransporte);
ALTER TABLE Transporte ADD CONSTRAINT Transporte_fkey FOREIGN KEY(curp)
REFERENCES Repartidor(curp) ON UPDATE CASCADE ON DELETE CASCADE;
/*********************************** Llaves Mezcladas (Primarias, Compuestas y Foraneas) ***********************************/
--Llaves Ticket
ALTER TABLE Ticket ADD CONSTRAINT Ticket_pkey PRIMARY KEY(idTicket);
ALTER TABLE Ticket ADD CONSTRAINT Ticket_fkey1 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Ticket ADD CONSTRAINT Ticket_fkey2 FOREIGN KEY(curpCliente)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Ticket ADD CONSTRAINT Ticket_fkey3 FOREIGN KEY(curpMesero)
REFERENCES Mesero(curp) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Sucursal
ALTER TABLE Sucursal ADD CONSTRAINT Sucursal_pkey PRIMARY KEY(rfc);
ALTER TABLE Sucursal ADD CONSTRAINT Sucursal_fkey FOREIGN KEY(idInventario)
REFERENCES Inventario(idInventario) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves MetodoPago
ALTER TABLE MetodoPago ADD CONSTRAINT MetodoPago_pkey PRIMARY KEY(idPago);
ALTER TABLE MetodoPago ADD CONSTRAINT MetodoPago_fkey FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;

/*********************************** Llaves Foraneas (Solo tienen este tipo de llaves) ***********************************/
--Llaves Proveer
ALTER TABLE Proveer ADD CONSTRAINT Proveer_fkey1 FOREIGN KEY(idInsumo)
REFERENCES Insumo(idInsumo) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Proveer ADD CONSTRAINT Proveer_fkey2 FOREIGN KEY(rfc)
REFERENCES Proveedor(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
--Tener Insumo
ALTER TABLE TenerInsumo ADD CONSTRAINT TenerInsumo_fkey1 FOREIGN KEY(idInventario)
REFERENCES Inventario(idInventario) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE TenerInsumo ADD CONSTRAINT TenerInsumo_fkey2 FOREIGN KEY(idInsumo)
REFERENCES Insumo(idInsumo) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves PrepararSalsa
ALTER TABLE PrepararSalsa ADD CONSTRAINT PrepararSalsa_fkey1 FOREIGN KEY(idInsumo)
REFERENCES Insumo(idInsumo) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE PrepararSalsa ADD CONSTRAINT PrepararSalsa_fkey2 FOREIGN KEY(idSalsa)
REFERENCES Salsa(idSalsa) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves PrepararComida
ALTER TABLE PrepararComida ADD CONSTRAINT PrepararComida_fkey1 FOREIGN KEY(idInsumo)
REFERENCES Insumo(idInsumo) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE PrepararComida ADD CONSTRAINT PrepararComida_fkey2 FOREIGN KEY(idComida)
REFERENCES Comida(idComida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves PrepararBebida
ALTER TABLE PrepararBebida ADD CONSTRAINT PrepararBebida_fkey1 FOREIGN KEY(idInsumo)
REFERENCES Insumo(idInsumo) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE PrepararBebida ADD CONSTRAINT PrepararBebida_fkey2 FOREIGN KEY(idBebida)
REFERENCES Bebida(idBebida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves RegistrarSalsa
ALTER TABLE RegistrarSalsa ADD CONSTRAINT RegistrarSalsa_fkey1 FOREIGN KEY(idTicket)
REFERENCES Ticket(idTicket) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE RegistrarSalsa ADD CONSTRAINT RegistrarSalsa_fkey2 FOREIGN KEY(idSalsa)
REFERENCES Salsa(idSalsa) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves RegistrarComida
ALTER TABLE RegistrarComida ADD CONSTRAINT RegistrarComida_fkey1 FOREIGN KEY(idTicket)
REFERENCES Ticket(idTicket) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE RegistrarComida ADD CONSTRAINT RegistrarComida_fkey2 FOREIGN KEY(idComida)
REFERENCES Comida(idComida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves RegistrarBebida
ALTER TABLE RegistrarBebida ADD CONSTRAINT RegistrarBebida_fkey1 FOREIGN KEY(idTicket)
REFERENCES Ticket(idTicket) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE RegistrarBebida ADD CONSTRAINT RegistrarBebida_fkey2 FOREIGN KEY(idBebida)
REFERENCES Bebida(idBebida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves TenerPromocion
ALTER TABLE TenerPromocion ADD CONSTRAINT TenerPromocion_fkey1 FOREIGN KEY(idPromocion)
REFERENCES Promocion(idPromocion) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE TenerPromocion ADD CONSTRAINT TenerPromocion_fkey2 FOREIGN KEY(idComida)
REFERENCES Comida(idComida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Recomendar
ALTER TABLE Recomendar ADD CONSTRAINT Recomendar_fkey1 FOREIGN KEY(idSalsa)
REFERENCES Salsa(idSalsa) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Recomendar ADD CONSTRAINT Recomendar_fkey2 FOREIGN KEY(idComida)
REFERENCES Comida(idComida) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Mesero
ALTER TABLE Mesero ADD CONSTRAINT Mesero_fkey1 FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Mesero ADD CONSTRAINT Mesero_fkey2 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Parrillero
ALTER TABLE Parrillero ADD CONSTRAINT Parrillero_fkey1 FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Parrillero ADD CONSTRAINT Parrillero_fkey2 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Taquero
ALTER TABLE Taquero ADD CONSTRAINT Taquero_fkey1 FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Taquero ADD CONSTRAINT Taquero_fkey2 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Repartidor
ALTER TABLE Repartidor ADD CONSTRAINT Repartidor_fkey1 FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Repartidor ADD CONSTRAINT Repartidor_fkey2 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Tortillero
ALTER TABLE Tortillero ADD CONSTRAINT Tortillero_fkey1 FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Tortillero ADD CONSTRAINT Tortillero_fkey2 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;
--Llaves Cajero
ALTER TABLE Cajero ADD CONSTRAINT Cajero_fkey1 FOREIGN KEY(curp)
REFERENCES Cliente(curp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Cajero ADD CONSTRAINT Cajero_fkey2 FOREIGN KEY(rfc)
REFERENCES Sucursal(rfc) ON UPDATE CASCADE ON DELETE CASCADE;