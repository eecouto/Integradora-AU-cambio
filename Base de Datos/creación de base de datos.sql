CREATE DATABASE smilecare;
USE smilecare;

CREATE TABLE clinicas(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
nombre VARCHAR(25),
direccion VARCHAR (120)
);

CREATE TABLE rol(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
nombre VARCHAR(25)
);

CREATE TABLE servicios(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
nombre VARCHAR(250),
costo INT,
tiempo INT
);

CREATE TABLE empleados(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
id_clinica INT,
id_rol INT,
nombre VARCHAR(50),
apellidos VARCHAR(50),
telefono VARCHAR(12),
correo VARCHAR(100),
contraseña VARCHAR(100),
estado VARCHAR(20),
FOREIGN KEY(id_clinica) REFERENCES clinicas(id),
FOREIGN KEY(id_rol) REFERENCES rol(id)
);

CREATE TABLE consultorios(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
numero INT,
id_sucursal INT,
id_medico INT,
FOREIGN KEY(id_sucursal) REFERENCES clinicas(id),
FOREIGN KEY(id_medico) REFERENCES empleados(id));

CREATE TABLE citas(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
id_consultorio INT,
id_servicio INT,
fecha_cita DATE,
hora_cita TIME,
nombre VARCHAR(50),
apellidos VARCHAR(50),
telefono VARCHAR(12),
duracion VARCHAR(10),
costo_total INT,
estatus VARCHAR(20),
FOREIGN KEY(id_consultorio) REFERENCES consultorios(id),
FOREIGN KEY(id_servicio) REFERENCES servicios(id)
);

CREATE TABLE cancelaciones(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
id_cita INT,
fecha_cancelacion DATE,
hora_cancelacion TIME,
FOREIGN KEY(id_cita) REFERENCES citas(id)
);

CREATE TABLE pagos(
id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
id_cita INT,
id_empleado INT,
fecha_pago DATETIME,
hora_pago TIME,
monto INT DEFAULT 0,
FOREIGN KEY(id_cita) REFERENCES citas(id),
FOREIGN KEY(id_empleado) REFERENCES empleados(id)
);