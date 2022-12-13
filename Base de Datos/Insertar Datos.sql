INSERT INTO `smilecare`.`clinicas` (`nombre`, `direccion`) VALUES ('Cuernavaca', 'Cuernavaca');
INSERT INTO `smilecare`.`clinicas` (`nombre`, `direccion`) VALUES ('Temixco', 'Temixco');

INSERT INTO `smilecare`.`rol` (`nombre`) VALUES ('Administrador');
INSERT INTO `smilecare`.`rol` (`nombre`) VALUES ('Medico');
INSERT INTO `smilecare`.`rol` (`nombre`) VALUES ('Asistente Administrativo');

INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('1', '1', 'Ivan Enrique', 'Couto Campoy', '12312312312', 'admin1cuerna@gmail.com', 'admin1cuerna123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('1', '3', 'Alexis', 'Herrera Romero', '12312312312', 'asistente1cuerna@gmail.com', 'asistente1cuerna123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('1', '2', 'Victor', 'Hernandez Perez', '12312312312', 'medico1cuerna@gmail.com', 'medico1cuerna123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('1', '2', 'Alejandro', 'Sanchez Salazar', '12312312', 'medico2cuerna@gmail.com', 'medico2cuerna123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('1', '2', 'Sandra', 'Hernandez Perez', '1231231231', 'medico3cuerna@gmail.com', 'medico3cuerna123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('1', '2', 'James', 'Hernandez Cabrera', '1231231231', 'medico4cuerna@gmail.com', 'medico4cuerna123', 'Activo');

INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('2', '1', 'Luis', 'Ferreira Castro', '12312312312', 'admin1temixco@gmail.com', 'admin1temixco123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('2', '3', 'Alejandro', 'Rosales Homer', '12312312312', 'asistente1temixco@gmail.com', 'asistente1temixco123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('2', '2', 'Valeriano', 'Hudson Pavarotti', '12312312312', 'medico1temixco@gmail.com', 'medico1temixco123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('2', '2', 'Astrid', 'Seila Salgado', '12312312', 'medico2temixco@gmail.com', 'medico2temixco123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('2', '2', 'Soraida', 'Huicochea Paredes', '1231231231', 'medico3temixco@gmail.com', 'medico3temixco123', 'Activo');
INSERT INTO `smilecare`.`empleados` (`id_clinica`, `id_rol`, `nombre`, `apellidos`, `telefono`, `correo`, `contraseña`, `estado`) VALUES ('2', '2', 'Javier', 'Himalaya Cabrales', '1231231231', 'medico4temixco@gmail.com', 'medico4temixco123', 'Activo');

INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('1', '1', '3');
INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('2', '1', '4');
INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('3', '1', '5');
INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('4', '1', '6');

INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('1', '2', '9');
INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('2', '2', '10');
INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('3', '2', '11');
INSERT INTO `smilecare`.`consultorios` (`numero`, `id_sucursal`, `id_medico`) VALUES ('4', '2', '12');

INSERT INTO `smilecare`.`servicios` (`nombre`, `costo`, `tiempo`) VALUES ('Ortodoncia', '1000', '60');
INSERT INTO `smilecare`.`servicios` (`nombre`, `costo`, `tiempo`) VALUES ('Limpieza Dental', '800', '40');
INSERT INTO `smilecare`.`servicios` (`nombre`, `costo`, `tiempo`) VALUES ('Muelas del Juicio', '1500', '60');
INSERT INTO `smilecare`.`servicios` (`nombre`, `costo`, `tiempo`) VALUES ('Consulta General', '500', '30');


INSERT INTO `smilecare`.`citas` (`id_consultorio`, `id_servicio`, `fecha_cita`, `hora_cita`, `nombre`, `apellidos`, `telefono`, `duracion`,`costo_total`,`estatus`) VALUES ('1', '1', '2022-11-30', '12:30:00', 'Samuel', 'Diaz Mendez', '7771231523', '60',1000,"Activo");
INSERT INTO `smilecare`.`pagos` (`id_cita`) VALUES ('1');
INSERT INTO `smilecare`.`cancelaciones` (`id_cita`) VALUES ('1');
INSERT INTO `smilecare`.`citas` (`id_consultorio`, `id_servicio`, `fecha_cita`, `hora_cita`, `nombre`, `apellidos`, `telefono`, `duracion`,`costo_total`,`estatus`) VALUES ('2', '1', '2022-12-30', '12:30:00', 'Salamancha', 'Doroteo Mendoza', '7771231523', '60',1000,"Activo");
INSERT INTO `smilecare`.`pagos` (`id_cita`) VALUES ('2');
INSERT INTO `smilecare`.`cancelaciones` (`id_cita`) VALUES ('2');

INSERT INTO `smilecare`.`citas` (`id_consultorio`, `id_servicio`, `fecha_cita`, `hora_cita`, `nombre`, `apellidos`, `telefono`, `duracion`,`costo_total`,`estatus`) VALUES ('5', '1', '2022-11-30', '12:30:00', 'Salatiel', 'Dolores Medrano', '7771231523', '60',1000,"Activo");
INSERT INTO `smilecare`.`pagos` (`id_cita`) VALUES ('3');
INSERT INTO `smilecare`.`cancelaciones` (`id_cita`) VALUES ('3');
INSERT INTO `smilecare`.`citas` (`id_consultorio`, `id_servicio`, `fecha_cita`, `hora_cita`, `nombre`, `apellidos`, `telefono`, `duracion`,`costo_total`,`estatus`) VALUES ('6', '1', '2022-12-30', '12:30:00', 'Sergio', 'Dalma Merendi', '7771231523', '60',1000,"Activo");
INSERT INTO `smilecare`.`pagos` (`id_cita`) VALUES ('4');
INSERT INTO `smilecare`.`cancelaciones` (`id_cita`) VALUES ('4');

SELECT * FROM consultorios;
SELECT * FROM clinicas;
SELECT * FROM empleados;
SELECT * FROM cancelaciones;