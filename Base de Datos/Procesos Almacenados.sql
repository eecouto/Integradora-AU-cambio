DROP PROCEDURE IF EXISTS registrar_empleado;

DELIMITER $$
CREATE PROCEDURE registrar_empleado(
	IN inombre VARCHAR(75),
    IN iapellidos VARCHAR(75),
    IN icorreo VARCHAR(100),
    IN itelefono VARCHAR(10),
    IN irol VARCHAR(25),
    IN inumero_consultorio INT,
    IN icontraseña VARCHAR(100),
    IN iclinica VARCHAR(25))
BEGIN
	DECLARE id_de_clinica INT;
    DECLARE id_del_rol INT;
    DECLARE id_del_medico INT;
    
    SET id_de_clinica=(SELECT id FROM clinicas WHERE nombre=iclinica);
    SET id_del_rol=(SELECT id FROM rol WHERE nombre=irol);
    
    IF irol="Medico" THEN
		INSERT INTO empleados(id_clinica,id_rol,nombre,apellidos,telefono,correo,contraseña,estado) VALUES (id_de_clinica,id_del_rol,inombre,iapellidos,itelefono,icorreo,icontraseña,"Activo");
        SET id_del_medico=(SELECT MAX(id) from empleados);
        INSERT INTO consultorios(numero,id_sucursal,id_medico) VALUES(inumero_consultorio,id_de_clinica,id_del_medico);
	
    ELSEIF irol!="Medico" THEN
		INSERT INTO empleados(id_clinica,id_rol,nombre,apellidos,telefono,correo,contraseña,estado) VALUES (id_de_clinica,id_del_rol,inombre,iapellidos,itelefono,icorreo,icontraseña,"Activo");
    END IF;
END$$
DELIMITER ;

-- CALL registrar_empleado("Alberto","Sanchez López","alberto@gmail.com","7775155151","Medico",1,"alberto123","Cuernavaca");


DROP PROCEDURE IF EXISTS registrar_cita;

DELIMITER $$
CREATE PROCEDURE registrar_cita(
	IN inombre VARCHAR(75),
    IN iapellidos VARCHAR(75),
    IN itelefono VARCHAR(10),
    IN ifecha VARCHAR(10),
    IN ihora VARCHAR(10),
    IN iservicio VARCHAR(20),
    IN isucursal VARCHAR(20))
BEGIN
	DECLARE fecha_hora DATETIME;
    DECLARE Doctor VARCHAR(100);
    DECLARE Idconsultorio INT;
    DECLARE Idclinica INT;
    DECLARE tiempo_consulta INT;
    DECLARE Idservicio INT;
    DECLARE icosto INT;
    DECLARE ultimacita INT;
    
    -- DATOS PARA EL CICLO WHILE
    DECLARE j INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE C1 CURSOR FOR SELECT `Doctor`,`Id Consultorio`,`Id clinica` FROM consultorios_doctores WHERE `Nombre Clinica`=isucursal AND Estatus="Activo";
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET j=1;
    
    SET fecha_hora = CAST(CONCAT(ifecha,' ',ihora) AS DATETIME);
    SET tiempo_consulta=(SELECT tiempo FROM servicios WHERE nombre=iservicio);
    SET Idservicio=(SELECT id FROM servicios WHERE nombre=iservicio);
    SET icosto=(SELECT costo FROM servicios WHERE nombre=iservicio);
    
    
    IF IF(ihora>"13:00",true,false) AND IF(ihora<"15:00",true,false) THEN
		SELECT 0;
        
	ELSE
		OPEN C1;
        BUCLE: LOOP
        FETCH C1 INTO Doctor,Idconsultorio,Idclinica;

        IF j=1 THEN
			LEAVE bucle;
		END IF;
        
        SET i=(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id_consultorio=Idconsultorio AND fecha_hora BETWEEN  CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
		SET i=i+(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id_consultorio=Idconsultorio AND CAST(DATE_ADD(fecha_hora, INTERVAL tiempo_consulta MINUTE) AS DATETIME) BETWEEN CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
		SET i=i+(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id_consultorio=Idconsultorio AND CAST(fecha_hora AS DATETIME) BETWEEN CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
		SET i=i+(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id_consultorio=Idconsultorio AND CAST(DATE_ADD(fecha_hora, INTERVAL tiempo_consulta MINUTE) AS DATETIME) BETWEEN CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
        
        IF i=0 THEN
			INSERT INTO `smilecare`.`citas` (`id_consultorio`, `id_servicio`, `fecha_cita`, `hora_cita`, `nombre`, `apellidos`, `telefono`, `duracion`,`costo_total`,`estatus`) VALUES (Idconsultorio,Idservicio,ifecha,ihora,inombre,iapellidos,itelefono,tiempo_consulta,icosto,"Activo");
			SET ultimacita=(SELECT MAX(id) FROM citas);
            INSERT INTO `smilecare`.`pagos` (`id_cita`) VALUES (ultimacita);
			INSERT INTO `smilecare`.`cancelaciones` (`id_cita`) VALUES (ultimacita);
            SELECT 1;
            LEAVE bucle;
        END IF;
		
        SET i=0;
        END LOOP bucle;
        CLOSE C1;
        
        IF j=1 THEN
			SELECT 2;
		END IF;
        
		
    END IF;

END$$
DELIMITER ;

-- CALL registrar_cita("Alfredo","Diaz Mendez","777516225","2022-01-30","12:10","Ortodoncia","Cuernavaca");

DROP PROCEDURE IF EXISTS editar_empleado;

DELIMITER $$
CREATE PROCEDURE editar_empleado(
	IN inombre VARCHAR(75),
    IN iapellidos VARCHAR(75),
    IN icorreo VARCHAR(100),
    IN itelefono VARCHAR(10),
    IN iestatus VARCHAR(20),
    IN icontraseña VARCHAR(100),
    IN iid INT)
BEGIN

	UPDATE `smilecare`.`empleados` SET `nombre`=inombre,`apellidos`=iapellidos,`correo`=icorreo,`telefono`=telefono,`estado`=iestatus,`contraseña`=icontraseña WHERE `id`=iid;

END$$
DELIMITER ;

-- --------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS editar_cita;

DELIMITER $$
CREATE PROCEDURE editar_cita(
	IN inombre VARCHAR(75),
    IN iapellidos VARCHAR(75),
    IN itelefono VARCHAR(10),
    IN ifecha VARCHAR(10),
    IN ihora VARCHAR(10),
    IN iservicio VARCHAR(20),
    IN isucursal VARCHAR(20),
    IN ifolio INT)
BEGIN
	DECLARE fecha_hora DATETIME;
    DECLARE Doctor VARCHAR(100);
    DECLARE Idconsultorio INT;
    DECLARE Idclinica INT;
    DECLARE tiempo_consulta INT;
    DECLARE Idservicio INT;
    DECLARE icosto INT;
    DECLARE ultimacita INT;
    
    -- DATOS PARA EL CICLO WHILE
    DECLARE j INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE C1 CURSOR FOR SELECT `Doctor`,`Id Consultorio`,`Id clinica` FROM consultorios_doctores WHERE `Nombre Clinica`=isucursal AND Estatus="Activo";
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET j=1;
    
    SET fecha_hora = CAST(CONCAT(ifecha,' ',ihora) AS DATETIME);
    SET tiempo_consulta=(SELECT tiempo FROM servicios WHERE nombre=iservicio);
    SET Idservicio=(SELECT id FROM servicios WHERE nombre=iservicio);
    SET icosto=(SELECT costo FROM servicios WHERE nombre=iservicio);
    
    
    IF IF(ihora>"13:00",true,false) AND IF(ihora<"15:00",true,false) THEN
		SELECT 0;
        
	ELSE
		OPEN C1;
        BUCLE: LOOP
        FETCH C1 INTO Doctor,Idconsultorio,Idclinica;

        IF j=1 THEN
			LEAVE bucle;
		END IF;
        
        SET i=(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id!=ifolio AND id_consultorio=Idconsultorio AND fecha_hora BETWEEN  CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
		SET i=i+(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id!=ifolio AND id_consultorio=Idconsultorio AND CAST(DATE_ADD(fecha_hora, INTERVAL tiempo_consulta MINUTE) AS DATETIME) BETWEEN CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
		SET i=i+(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id!=ifolio AND id_consultorio=Idconsultorio AND CAST(fecha_hora AS DATETIME) BETWEEN CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
		SET i=i+(SELECT COUNT(id) FROM citas WHERE estatus="Activo" AND id!=ifolio AND id_consultorio=Idconsultorio AND CAST(DATE_ADD(fecha_hora, INTERVAL tiempo_consulta MINUTE) AS DATETIME) BETWEEN CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME) AND CAST(DATE_ADD(CAST(TIMESTAMP(fecha_cita,hora_cita) AS DATETIME), INTERVAL duracion MINUTE) AS DATETIME));
        
        IF i=0 THEN
			UPDATE `smilecare`.`citas` SET `id_consultorio` = Idconsultorio, `id_servicio` = Idservicio, `fecha_cita` = ifecha, `hora_cita` = ihora, `nombre` = inombre, `apellidos` = iapellidos, `telefono` = itelefono, `duracion` = tiempo_consulta, `costo_total` = icosto WHERE (`id` = ifolio);

            SELECT 1;
            LEAVE bucle;
        END IF;
		
        SET i=0;
        END LOOP bucle;
        CLOSE C1;
        
        IF j=1 THEN
			SELECT 2;
		END IF;
        
		
    END IF;

END$$
DELIMITER ;

-- -----------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS cancelar_cita;

DELIMITER $$
CREATE PROCEDURE cancelar_cita(
	IN iid INT)
BEGIN
	UPDATE `smilecare`.`citas` SET `estatus` = "Cancelada" WHERE (`id` = iid);
    UPDATE `smilecare`.`cancelaciones` SET `fecha_cancelacion` = now(),`hora_cancelacion` = now() WHERE (`id` = iid);
    
END$$
DELIMITER ;

-- -------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS buscar_empleado;

DELIMITER $$
CREATE PROCEDURE buscar_empleado(
	IN busqueda VARCHAR(20),
    IN datos VARCHAR(20),
    IN sucursal VARCHAR(20))
BEGIN
	IF busqueda="puesto" THEN
		SELECT * FROM lista_empleados WHERE `Nombre_Clinica` LIKE CONCAT("%",sucursal,"%") AND `Nombre del Rol` LIKE CONCAT("%",datos,"%");
	ELSEIF busqueda="estatus" THEN
		SELECT * FROM lista_empleados WHERE `Nombre_Clinica` LIKE CONCAT("%",sucursal,"%") AND `Estatus` LIKE CONCAT("%",datos,"%");
    END IF;
END$$
DELIMITER ;

-- -------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS buscar_cita;

DELIMITER $$
CREATE PROCEDURE buscar_cita(
	IN busqueda VARCHAR(20),
    IN datos VARCHAR(20),
    IN sucursal VARCHAR(20))
BEGIN
	IF busqueda="estatus" THEN
		SELECT * FROM tabla_citas WHERE `Sucursal` LIKE CONCAT("%",sucursal,"%") AND `Estatus` LIKE CONCAT("%",datos,"%");
	ELSEIF busqueda="medico" THEN
		SELECT * FROM tabla_citas WHERE `Sucursal` LIKE CONCAT("%",sucursal,"%") AND CONCAT(`Nombre Medico`,' ',`Apellidos Medico`) LIKE CONCAT("%",datos,"%");
    END IF;
END$$
DELIMITER ;

-- --------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS registrar_pago;

DELIMITER $$
CREATE PROCEDURE registrar_pago(
	IN folio INT,
    IN imonto INT,
    IN empleado INT)
BEGIN
	DECLARE validar INT;
    DECLARE pagado INT;
    DECLARE precio INT;
    
    SET precio=(SELECT costo_total FROM citas WHERE id=folio);
    SET pagado=(SELECT monto FROM pagos WHERE id_cita=folio);
    
    IF (imonto+pagado)>=precio THEN
		UPDATE `smilecare`.`citas` SET `estatus` = "Atendida" WHERE (`id` = folio);
    END IF;
    
    SET validar=(SELECT monto FROM pagos WHERE id_cita=folio);
    IF validar=0 THEN
		UPDATE `smilecare`.`pagos` SET `id_empleado` = empleado, fecha_pago=now(),hora_pago=now(),monto=imonto WHERE (`id_cita` = folio);
	ELSE
		UPDATE `smilecare`.`pagos` SET `id_empleado` = empleado, fecha_pago=now(),hora_pago=now(),monto=(imonto+monto) WHERE (`id_cita` = folio);
    END IF;
    
END$$
DELIMITER ;

CALL registrar_pago(16,500,10);
SELECT * FROM pagos WHERE id_cita=16;
SELECT * FROM pagos;
SELECT * FROM citas;