-- Consultas del Proyecto Final.

-- 1. El nombre de los choferes que hicieron viajes hacia la 
--    Facultad de Ciencias durante el mes de Octubre de 2018.
SELECT persona.id_persona, persona.nombre
FROM choferes
INNER JOIN persona ON choferes.id_persona = persona.id_persona
INNER JOIN transportar ON Choferes.num_licencia = transportar.num_licencia
INNER JOIN viaje ON transportar.id_viaje = viaje.id_viaje
INNER JOIN destino ON viaje.id_viaje = destino.id_viaje
WHERE destino.colonia = 'CU' AND destino.calle = 'Facultad de Ciencias'
AND MONTH(viaje.fecha) = 10 AND YEAR(viaje.fecha) = 2018;

-- 2. Viajes ordenados por delegaci�n y n�mero de veces que se ha
--    realizado un viaje con destino a dicha delegaci�n.
SELECT destino.delegacion AS Delegacion, COUNT(destino.delegacion) AS numero_de_viajes
FROM destino
GROUP BY destino.delegacion;

-- 3. El n�mero de viajes que ha realizado cada veh�culo.
SELECT vehiculo.numero_economico AS vehiculo, COUNT(viaje.id_viaje) as numero_viajes
FROM vehiculo
INNER JOIN transportar ON vehiculo.numero_economico = transportar.numero_economico
INNER JOIN viaje ON transportar.id_viaje = viaje.id_viaje
GROUP BY vehiculo.numero_economico;

-- 4. El nombre del personal (alumnos, acad�micos y trabajadores) que
--    han realizado m�s viajes a la Facultad de Ingenier�a.
SELECT persona.nombre AS nombre, rol.rol as rol, COUNT(viaje.id_viaje) as numero_viajes
FROM persona
INNER JOIN clientes ON persona.id_persona = clientes.id_persona
INNER JOIN rol ON clientes.id_cliente = rol.id_cliente
INNER JOIN transportar ON clientes.id_cliente = transportar.id_cliente
INNER JOIN viaje ON transportar.id_viaje = viaje.id_viaje
INNER JOIN destino ON viaje.id_viaje = destino.id_viaje
WHERE destino.colonia = 'CU' AND destino.calle = 'Facultad de Ingenier�a'
GROUP BY persona.nombre, rol.rol;

-- 5. El promedio de distancias recorridas en viajes realizados
--    durante el semestre 2019-1 (Agosto 2018-Diciembre 2018)
SELECT AVG(viaje.distancia) AS promedio_distancias
FROM viaje
WHERE YEAR(viaje.fecha) = 2018 AND MONTH(viaje.fecha) IN (08,09,10,11,12);

-- 6. Nombre de los choferes que no son due�os.
SELECT persona.nombre, persona.paterno, persona.materno
FROM persona
INNER JOIN choferes ON persona.id_persona = choferes.id_persona
WHERE choferes.id_persona NOT IN(
SELECT due�os.id_persona
FROM due�os);

-- 7. Todas las infracciones durante el mes de diciembre de 2018
--    con costo mayor a 1500.
SELECT infracciones.num_infraccion, infracciones.costo_original, infracciones.fecha_infraccion
FROM infracciones
WHERE costo_original >= 1500 AND (MONTH(infracciones.fecha_infraccion) = 12 AND YEAR(infracciones.fecha_infraccion) = 2018);

-- 8. Las facultades con el numero de viajes como destino.
SELECT destino.calle, COUNT(destino.calle) as numero_viajes
FROM destino
WHERE destino.calle LIKE 'Facultad %'
GROUP BY destino.calle;

-- 9. Todos los clientes que son alumnos.
SELECT clientes.id_cliente
FROM clientes
INNER JOIN rol ON clientes.id_cliente = rol.id_cliente
WHERE rol.rol = 'Alumno';

-- 10. Los viajes regristrados el mes de enero de 2018
--     con destino a la delegaci�n Iztapalapa.
SELECT viaje.id_viaje
FROM viaje
INNER JOIN destino ON viaje.id_viaje = destino.id_viaje
WHERE destino.delegacion = 'Iztapalapa' AND (YEAR(viaje.fecha) = 2018 AND MONTH(viaje.fecha) = 01);

-- 11. El n�mero de infracciones por chofer.
SELECT choferes.id_persona, COUNT(infracciones.num_infraccion) AS num_infracciones
FROM choferes
INNER JOIN infracciones ON choferes.num_licencia = infracciones.num_licencia
GROUP BY choferes.id_persona;

-- 12. Los choferes que nunca han realizado viajes con destino a la 
--     Facultad de Medicina.
SELECT choferes.num_licencia
FROM choferes
INNER JOIN transportar ON choferes.num_licencia = transportar.num_licencia
WHERE transportar.id_viaje NOT IN
(SELECT destino.id_viaje
FROM destino
WHERE destino.calle = 'Facultad de Medicina');

-- 13. El viaje de mayor distancia recorrida con origen en la 
--     delegaci�n Tlahuac realizado por un carro de 4 puertas con
--     destino a la delegaci�n Xochimilco.
SELECT MAX(viaje.distancia) AS distancia_max
FROM viaje
INNER JOIN destino ON viaje.id_viaje = destino.id_viaje
INNER JOIN origen ON viaje.id_viaje = origen.id_viaje
INNER JOIN transportar ON viaje.id_viaje = transportar.id_viaje
WHERE origen.delegacion = 'Tlahuac' AND destino.delegacion = 'Xochimilco' AND
transportar.numero_economico IN (
SELECT numero_economico
FROM vehiculo
WHERE num_puertas = 4);

-- 14. El n�mero de clientes que son alumnos o acad�micos
--     pero no trabajadores registrados en el sistema.
SELECT COUNT(clientes.id_cliente) AS num_alumnos_academicos
FROM clientes
INNER JOIN rol ON clientes.id_cliente = rol.id_cliente
WHERE rol.rol IN ('Alumno', 'Academico');

-- 15. Todos los veh�culos de 4 puertas del a�o
--     2012 que han transportado a alg�n trabajador.
SELECT vehiculo.numero_economico
FROM vehiculo
INNER JOIN transportar ON vehiculo.numero_economico = transportar.numero_economico
WHERE vehiculo.num_puertas = 5 AND vehiculo.a�o = 2012
AND transportar.id_cliente IN(
SELECT transportar.id_cliente
FROM transportar
INNER JOIN clientes ON transportar.id_cliente = clientes.id_cliente
INNER JOIN rol ON clientes.id_cliente = rol.id_cliente
WHERE rol.rol = 'Trabajador');

-- 16. El n�mero promedio de personas que reaizaron 
--     viajes en el a�o 2017 y 2018.
SELECT AVG(viaje.personas) AS promedio_personas
FROM viaje
WHERE YEAR(viaje.fecha) = 2017 OR YEAR(viaje.fecha) = 2018;

-- 17. Todos los choferes que vivien en la delegaci�n 
--     Tlahuac y no son due�os.
SELECT choferes.num_licencia
FROM choferes
INNER JOIN persona ON choferes.id_persona = persona.id_persona
INNER JOIN direccion ON persona.id_persona = direccion.id_persona
INNER JOIN due�os ON persona.id_persona = due�os.id_persona
WHERE direccion.delegacion = 'Tlahuac'
AND  choferes.id_persona NOT IN (
SELECT due�os.id_persona
FROM due�os);

-- 18. Las aseguradoras que tienen en cobertura veh�culos
--     �nicamente de 4 puertas.
SELECT aseguradoras.rfc, aseguradoras.nombre
FROM aseguradoras
INNER JOIN asegurar ON aseguradoras.rfc = asegurar.aseguradoras_rfc
INNER JOIN vehiculo ON asegurar.numero_economico = vehiculo.numero_economico
WHERE vehiculo.num_puertas = 4;

-- 19. Los veh�culos de 4 pasajeros que est�n asegurados y
--     han realizado viajes hacia la delegaci�n Tlalpan.
SELECT vehiculo.numero_economico
FROM vehiculo
INNER JOIN asegurar ON vehiculo.numero_economico = asegurar.numero_economico
WHERE vehiculo.num_pasajeros = 4 AND
vehiculo.numero_economico IN(
SELECT transportar.numero_economico
FROM transportar
INNER JOIN viaje ON transportar.id_viaje = viaje.id_viaje
INNER JOIN destino ON viaje.id_viaje = destino.id_viaje
WHERE destino.delegacion = 'Tlalpan');

-- 20. Todos los veh�culos asegurados con cobertura
--     amplia que son del a�o 2012.
SELECT vehiculo.numero_economico
FROM vehiculo
INNER JOIN asegurar ON vehiculo.numero_economico = asegurar.numero_economico
WHERE vehiculo.a�o = 2012 AND asegurar.cobertura = 'Amplia';