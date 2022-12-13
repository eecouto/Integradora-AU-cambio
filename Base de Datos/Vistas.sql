DROP VIEW IF EXISTS inicio;
CREATE VIEW inicio AS
SELECT
	tabla2.correo AS "Correo",
    tabla2.contraseña AS "Contraseña",
    tabla2.nombre1 AS "Nombre Clinica",
    tabla2.nombre2 AS "Nombre del Rol",
    tabla2.id AS "ID",
    tabla2.estado AS "Estatus",
    tabla2.Nombre_empleado AS "Nombre Empleado",
    tabla2.Apellidos_empleado AS "Apellidos Empleado"
FROM
(
SELECT
	tabla1.correo,
    tabla1.contraseña,
    tabla1.nombre AS "nombre1",
    rol.nombre AS "nombre2",
    tabla1.id,
    tabla1.estado,
    tabla1.Nombre_empleado,
    tabla1.Apellidos_empleado
FROM
	(SELECT 
		empleados.correo,
		empleados.contraseña,
        clinicas.nombre,
        empleados.id_rol,
        empleados.id,
        empleados.estado,
        empleados.nombre AS "Nombre_empleado",
        empleados.apellidos AS "Apellidos_empleado"
	FROM
    empleados INNER JOIN clinicas ON
    clinicas.id=empleados.id_clinica) AS tabla1
INNER JOIN rol ON rol.id=tabla1.id_rol) AS tabla2 ORDER BY tabla2.id ;

-- ----------------------------------------------------------------------

DROP VIEW IF EXISTS lista_empleados;
CREATE VIEW lista_empleados AS
SELECT
	tabla2.nombre AS "Nombre Empleado",
    tabla2.apellidos AS "Apellidos Empleado",
    tabla2.telefono AS "Telefono",
    tabla2.estado AS "Estado",
	tabla2.correo AS "Correo",
    tabla2.contraseña AS "Contraseña",
    tabla2.nombre1 AS "Nombre_Clinica",
    tabla2.nombre2 AS "Nombre del Rol",
    tabla2.id AS "ID empleado",
    tabla2.Estatus
FROM
(
SELECT
	tabla1.nombre,
    tabla1.apellidos,
    tabla1.telefono,
	tabla1.correo,
    tabla1.contraseña,
    tabla1.estado,
    tabla1.nombre1,
    rol.nombre AS "nombre2",
    tabla1.id,
    tabla1.Estatus
FROM
	(SELECT
		empleados.nombre,
        empleados.apellidos,
        empleados.telefono,
		empleados.correo,
		empleados.contraseña,
        clinicas.nombre AS "nombre1",
        empleados.id_rol,
        empleados.estado,
        empleados.id,
        empleados.estado AS "Estatus"
	FROM
    empleados INNER JOIN clinicas ON
    clinicas.id=empleados.id_clinica) AS tabla1
INNER JOIN rol ON rol.id=tabla1.id_rol) AS tabla2 ORDER BY tabla2.id AND tabla2.nombre2;

-- ------------------------------------------------------

DROP VIEW IF EXISTS roles;
CREATE VIEW roles AS
SELECT
	nombre
FROM
rol;

DROP VIEW IF EXISTS total_consultorios;
CREATE VIEW total_consultorios AS
SELECT
	clinicas.nombre AS "Nombre_Clinica",
    consultorios.numero AS "Número Consultorio"
FROM
clinicas INNER JOIN consultorios ON consultorios.id_sucursal=clinicas.id GROUP BY clinicas.nombre,consultorios.numero;

-- -----------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS tabla_citas;
CREATE VIEW tabla_citas AS

SELECT
	tabla5.id,
    tabla5.Sucursal,
    tabla5.Consultorio,
    empleados.nombre AS "Nombre Medico",
    empleados.apellidos AS "Apellidos Medico",
    tabla5.Servicio,
    DATE_FORMAT(tabla5.fecha_cita,"%d-%c-%Y") AS "Fecha Cita",
    TIME_FORMAT(tabla5.hora_cita,"%h:%i %p") AS "Hora Cita",
    tabla5.Nombre AS "Nombre Paciente",
    tabla5.apellidos AS "Apellidos Paciente",
    tabla5.telefono AS "Telefono",
    tabla5.duracion AS "Duracion",
    tabla5.costo_total AS "Costo Total",
    tabla5.estatus AS "Estatus",
    tabla5.id_empleado,
    tabla5.fecha_pago,
    tabla5.hora_pago,
    tabla5.monto,
    DATE_FORMAT(tabla5.fecha_cancelacion,"%d-%c-%Y") AS "Fecha Cancelacion",
    TIME_FORMAT(tabla5.hora_cancelacion,"%h:%i %p") AS "Hora Cancelacion",
    tabla5.fecha_cita,
    tabla5.hora_cita
FROM
	(
SELECT
	tabla4.id,
    tabla4.Sucursal,
    tabla4.Consultorio,
    tabla4.id_medico,
    tabla4.Servicio,
    tabla4.fecha_cita,
    tabla4.hora_cita,
    tabla4.Nombre,
    tabla4.apellidos,
    tabla4.telefono,
    tabla4.duracion,
    tabla4.costo_total,
    tabla4.estatus,
    tabla4.id_empleado,
    tabla4.fecha_pago,
    tabla4.hora_pago,
    tabla4.monto,
    cancelaciones.fecha_cancelacion,
    cancelaciones.hora_cancelacion
FROM
(SELECT
	tabla3.id,
    tabla3.Sucursal,
    tabla3.Consultorio,
    tabla3.id_medico,
    tabla3.Servicio,
    tabla3.fecha_cita,
    tabla3.hora_cita,
    tabla3.Nombre,
    tabla3.apellidos,
    tabla3.telefono,
    tabla3.duracion,
    tabla3.costo_total,
    tabla3.estatus,
    pagos.id_empleado,
    pagos.fecha_pago,
    pagos.hora_pago,
    pagos.monto
FROM
(SELECT
	tabla2.id,
    clinicas.nombre AS "Sucursal",
    tabla2.numero AS "Consultorio",
    tabla2.id_medico,
    tabla2.nombre AS "Servicio",
    tabla2.fecha_cita,
    tabla2.hora_cita,
    tabla2.Nombre1 AS "Nombre",
    tabla2.apellidos,
    tabla2.telefono,
    tabla2.duracion,
    tabla2.costo_total,
    tabla2.estatus
FROM
(SELECT
	tabla1.id,
    consultorios.numero,
    consultorios.id_medico,
    consultorios.id_sucursal,
    tabla1.nombre,
    tabla1.fecha_cita,
    tabla1.hora_cita,
    tabla1.Nombre1,
    tabla1.apellidos,
    tabla1.telefono,
    tabla1.duracion,
    tabla1.costo_total,
    tabla1.estatus
FROM
(SELECT 
	citas.id,
    citas.id_consultorio,
    servicios.nombre,
    citas.fecha_cita,
    citas.hora_cita,
    citas.nombre AS "Nombre1",
    citas.apellidos,
    citas.telefono,
    citas.duracion,
    citas.costo_total,
    citas.estatus
FROM
citas INNER JOIN servicios ON citas.id_servicio=servicios.id) AS tabla1 INNER JOIN consultorios ON
tabla1.id_consultorio=consultorios.id) AS tabla2 INNER JOIN clinicas ON clinicas.id=tabla2.id_sucursal
) AS tabla3 INNER JOIN pagos ON pagos.id_cita=tabla3.id) AS tabla4 INNER JOIN cancelaciones ON cancelaciones.id_cita=tabla4.id) AS tabla5
INNER JOIN empleados ON empleados.id=tabla5.id_medico ORDER BY tabla5.id;

-- -------------------------------------------------------------------------------------

DROP VIEW IF EXISTS lista_servicios;
CREATE VIEW lista_servicios AS
SELECT
	nombre
FROM
	servicios;
    
-- -----------------------------------------------

DROP VIEW IF EXISTS consultorios_doctores;
CREATE VIEW consultorios_doctores AS

SELECT
	tabla2.id AS "Id Cita",
    tabla2.id_clinica AS "Id Clinica",
    clinicas.nombre AS "Nombre Clinica",
    tabla2.id_consultorio AS "Id Consultorio",
    tabla2.Numero_Consultorio as "Numero de Consultorio",
    tabla2.Doctor,
    tabla2.Rol,
    tabla2.Estatus
FROM
(SELECT
	tabla1.id,
    tabla1.id_clinica,
    consultorios.id AS "id_consultorio",
    consultorios.numero AS "Numero_Consultorio",
    tabla1.Doctor,
    tabla1.nombre AS "Rol",
    tabla1.estado AS "Estatus"
FROM

(SELECT
	empleados.id,
    empleados.id_clinica,
    CONCAT(empleados.nombre,' ',empleados.apellidos) AS "Doctor",
    rol.nombre,
    empleados.estado
FROM
empleados INNER JOIN rol ON rol.id=empleados.id_rol) AS tabla1
INNER JOIN consultorios ON consultorios.id_medico=tabla1.id) AS tabla2
INNER JOIN clinicas ON clinicas.id=tabla2.id_clinica;

SELECT * FROM consultorios_doctores;


SELECT * FROM clinicas;
SELECT * FROM rol;
SELECT * FROM empleados;
SELECT * FROM consultorios;
SELECT * FROM citas;
SELECT * FROM servicios;
SELECT * FROM pagos;
SELECT * FROM cancelaciones;

SELECT * FROM tabla_citas;
SELECT * FROM inicio;
SELECT * FROM lista_servicios;
SELECT * FROM lista_empleados;
SELECT * FROM roles;
SELECT * FROM total_consultorios;