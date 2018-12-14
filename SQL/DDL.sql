USE master;
GO
--Verifica si existe base de datos, elimina si existe
IF DB_ID ('Taxis_Puma') IS NOT NULL DROP
	DATABASE Taxis_Puma;
GO
--Crea base de datos
CREATE
	DATABASE Taxis_Puma;
GO
	USE Taxis_Puma;
GO

CREATE
TABLE
viaje (
id_viaje INT NOT NULL,
fecha DATE,
tiempo TIME,
distancia INT,
personas INT 
);

CREATE TABLE
destino(
id_viaje INT NOT NULL,
delegacion VARCHAR(255),
colonia VARCHAR(255),
calle  VARCHAR(255),
lote INT
)

CREATE TABLE
origen(
id_viaje INT NOT NULL,
delegacion VARCHAR(255),
colonia VARCHAR(255),
calle  VARCHAR(255),
lote INT
)

CREATE TABLE
vehiculo(
numero_economico INT NOT NULL,
año INT,
modelo VARCHAR(255),
marca VARCHAR(255),
cilindros INT,
descripcion_baja VARCHAR(255),
activo BIT,
num_puertas INT,
num_pasajeros INT,
transmicion VARCHAR(255),
llanta_refaccion BIT,
combustible VARCHAR(255),
fecha_baja DATE
)

CREATE TABLE 
asegurar(
aseguradoras_rfc VARCHAR(255) NOT NULL,
numero_economico INT NOT NULL,
dueño_rfc VARCHAR(255) NOT NULL,
num_seguro INT NOT NULL,
cobertura VARCHAR(255)
)

CREATE TABLE
aseguradoras(
rfc VARCHAR(255) NOT NULL,
nombre VARCHAR(255)
)

CREATE TABLE
dueños(
rfc VARCHAR(255) NOT NULL,
id_persona VARCHAR(255) NOT NULL
)

CREATE TABLE
direccion(
id_persona VARCHAR(255) NOT NULL,
delegacion VARCHAR(255),
colonia VARCHAR(255),
calle VARCHAR(255),
lote INT
)

CREATE TABLE
choferes(
num_licencia INT NOT NULL,
id_persona VARCHAR(255) NOT NULL
)

CREATE TABLE 
infracciones(
num_infraccion INT NOT NULL,
num_licencia INT NOT NULL,
costo_original INT,
fecha_infraccion DATE,
)

CREATE TABLE
rol(
id_cliente INT NOT NULL,
rol VARCHAR(255) NOT NULL
)
CREATE TABLE
persona(
id_persona VARCHAR(255) NOT NULL,
nombre VARCHAR(255) NOT NULL,
paterno VARCHAR(255) NOT NULL,
materno VARCHAR(255),
fecha_ingreso DATE,
celular VARCHAR(255),
fotografia VARCHAR(255),
correo_electronico VARCHAR(255),
es_dueño VARCHAR(255),
es_chofer VARCHAR(255),
es_cliente VARCHAR(255)
)

CREATE TABLE
clientes(
id_cliente INT NOT NULL,
id_persona VARCHAR(255) NOT NULL,
ubicacion_cu VARCHAR(255)
)

CREATE TABLE
transportar(
id_viaje INT NOT NULL,
id_cliente INT NOT NULL,
numero_economico INT NOT NULL,
num_licencia INT NOT NULL
)

CREATE TABLE
direccion_infraccion(
num_infraccion  INT NOT NULL,
delegacion VARCHAR(255),
colonia VARCHAR(255),
calle VARCHAR(255),
lote INT
)
--Constraints
--Llaves primarias
--persona
ALTER TABLE
persona ADD CONSTRAINT pk_id_persona PRIMARY KEY(id_persona);
--infracciones
ALTER TABLE
infracciones ADD CONSTRAINT pk_num_infraccion PRIMARY KEY(num_infraccion);
--choferes
ALTER TABLE
choferes ADD CONSTRAINT pk_licencia PRIMARY KEY(num_licencia);          
--clientes
ALTER TABLE
clientes ADD CONSTRAINT pk_id_cliente PRIMARY KEY(id_cliente);
--dueños
ALTER TABLE
dueños ADD CONSTRAINT pk_dueños_rfc PRIMARY KEY(rfc);
--vehiculo
ALTER TABLE 
vehiculo ADD CONSTRAINT pk_numero_economico PRIMARY KEY(numero_economico);
--asegurar
ALTER TABLE
asegurar ADD CONSTRAINT pk_asegurar PRIMARY KEY(dueño_rfc,aseguradoras_rfc,numero_economico, num_seguro);

--aseguradoras
ALTER TABLE
aseguradoras ADD CONSTRAINT pk_aseguradoras_rfc PRIMARY KEY(rfc);

--transportar
ALTER TABLE
transportar ADD CONSTRAINT pk_transportar PRIMARY KEY(id_viaje, id_cliente, num_licencia, numero_economico);

--rol
ALTER TABLE
rol ADD CONSTRAINT pk_rol PRIMARY KEY(id_cliente, rol);

--viaje
ALTER TABLE
viaje ADD CONSTRAINT  pk_id_viaje PRIMARY KEY(id_viaje);

--Destino
ALTER TABLE
destino ADD CONSTRAINT pk_id_viaje_destino PRIMARY KEY(id_viaje);

--Origen
ALTER TABLE
origen ADD CONSTRAINT pk_id_viaje_origen PRIMARY KEY(id_viaje);

--direccion_infraccion
ALTER TABLE
direccion_infraccion ADD CONSTRAINT pk_direccion_infraccion PRIMARY KEY(num_infraccion);

--direccion
ALTER TABLE
direccion ADD CONSTRAINT pk_direccion PRIMARY KEY(id_persona);

--LLAVES FORANEAS

--direccion_infraccion
ALTER TABLE
direccion_infraccion ADD CONSTRAINT fk_num_infraccion FOREIGN KEY(num_infraccion) REFERENCES infracciones(num_infraccion)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--infracciones
ALTER TABLE
infracciones ADD CONSTRAINT fk_licencia FOREIGN KEY(num_licencia) REFERENCES choferes(num_licencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Rol
ALTER TABLE
rol ADD CONSTRAINT fk_rol FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Destino
ALTER TABLE
destino ADD CONSTRAINT fk_id_viaje_destino FOREIGN KEY(id_viaje) REFERENCES viaje(id_viaje)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Origen

ALTER TABLE
origen ADD CONSTRAINT fk_id_viaje_origen FOREIGN KEY(id_viaje) REFERENCES viaje(id_viaje)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


--Asegurar
ALTER TABLE
asegurar ADD CONSTRAINT fk_dueños_rfc FOREIGN KEY(dueño_rfc) REFERENCES dueños(rfc)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE
asegurar ADD CONSTRAINT fk_aseguradoras_rfc FOREIGN KEY(aseguradoras_rfc) REFERENCES aseguradoras(rfc)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE
asegurar ADD CONSTRAINT fk_numero_economico FOREIGN KEY(numero_economico) REFERENCES vehiculo(numero_economico)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Transportar

ALTER TABLE
transportar ADD CONSTRAINT fk_id_viaje FOREIGN KEY(id_viaje) REFERENCES viaje(id_viaje)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE
transportar ADD CONSTRAINT fk_trasnportar_cliente FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE
transportar ADD CONSTRAINT fk_trasnportar_num_licencia FOREIGN KEY(num_licencia) REFERENCES choferes(num_licencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE
transportar ADD CONSTRAINT fk_numero_economico_transportar FOREIGN KEY(numero_economico) REFERENCES vehiculo(numero_economico)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Choferes

ALTER TABLE
choferes ADD CONSTRAINT fk_id_persona FOREIGN KEY(id_persona) REFERENCES persona(id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Clientes

ALTER TABLE
clientes ADD CONSTRAINT fk_id_persona_clientes FOREIGN KEY(id_persona) REFERENCES persona(id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--Dueños

ALTER TABLE
dueños ADD CONSTRAINT fk_id_persona_dueños FOREIGN KEY(id_persona) REFERENCES persona(id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--ORIGEN columna para conocer si la ubicacion esta en CU
--ALTER TABLE origen 
--DROP COLUMN en_cu;

--DESTINO columna para conocer si la ubicacion esta en CU
--ALTER TABLE destino
--DROP COLUMN en_cu;


