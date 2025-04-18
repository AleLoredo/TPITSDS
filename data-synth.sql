
-- Inserción de datos sintéticos para el sistema

-- Contactos (12)
INSERT INTO Contactos (idcontacto, nombre, apellido, docum, tipodoc, fechanacim, telcontacto, telemergencia, correo, direccion) VALUES
(1, 'Juan', 'Pérez', '30123456', 'DNI', '1980-01-15', '1134567890', '1198765432', 'juan.perez@example.com', 'Calle Falsa 123'),
(2, 'Ana', 'Gómez', '31123456', 'DNI', '1985-03-22', '1134567891', '1198765433', 'ana.gomez@example.com', 'Av. Siempreviva 456'),
(3, 'Luis', 'Martínez', '32123456', 'DNI', '1978-07-09', '1134567892', '1198765434', 'luis.martinez@example.com', 'Calle 8 1010'),
(4, 'Marta', 'Fernández', '33123456', 'DNI', '1990-12-01', '1134567893', '1198765435', 'marta.fernandez@example.com', 'Mitre 2020'),
(5, 'Carlos', 'Sosa', '34123456', 'DNI', '1982-11-30', '1134567894', '1198765436', 'carlos.sosa@example.com', 'Belgrano 3300'),
(6, 'Lucía', 'Ramírez', '35123456', 'DNI', '1987-06-15', '1134567895', '1198765437', 'lucia.ramirez@example.com', 'San Martín 550'),
(7, 'Diego', 'Suárez', '36123456', 'DNI', '1975-08-23', '1134567896', '1198765438', 'diego.suarez@example.com', 'Lavalle 700'),
(8, 'Paula', 'Rivas', '37123456', 'DNI', '1992-02-17', '1134567897', '1198765439', 'paula.rivas@example.com', 'Av. Córdoba 808'),
(9, 'Matías', 'Ibarra', '38123456', 'DNI', '1983-09-30', '1134567898', '1198765440', 'matias.ibarra@example.com', 'Rivadavia 1200'),
(10, 'Andrea', 'López', '39123456', 'DNI', '1989-05-20', '1134567899', '1198765441', 'andrea.lopez@example.com', 'Catamarca 345'),
(11, 'Sofía', 'Moreno', '40123456', 'DNI', '1993-04-10', '1134567800', '1198765442', 'sofia.moreno@example.com', 'Independencia 321'),
(12, 'Javier', 'Vega', '41123456', 'DNI', '1986-10-05', '1134567801', '1198765443', 'javier.vega@example.com', 'Corrientes 1500');

-- SystemUsers (12)
INSERT INTO SystemUsers (idusuario, idcontacto, usuario, contraseña, rolpaciente, rolmedico, roladministrativo, rolsuperadmin) VALUES
(1, 1, 'jperez', '1234', false, true, false, false),
(2, 2, 'agomez', '1234', false, true, false, false),
(3, 3, 'lmartinez', '1234', false, true, false, false),
(4, 4, 'mfernandez', '1234', false, true, false, false),
(5, 5, 'csosa', '1234', false, true, false, false),
(6, 6, 'lramirez', '1234', false, true, false, false),
(7, 7, 'dsuarez', '1234', false, true, false, false),
(8, 8, 'privas', '1234', false, true, false, false),
(9, 9, 'mibarra', '1234', false, true, false, false),
(10, 10, 'alopez', '1234', true, false, false, false),
(11, 11, 'smoreno', '1234', true, false, false, false),
(12, 12, 'jvega', '1234', false, false, true, false);

-- Servicios
INSERT INTO Servicios (idservicio, nombre, activo, duracionturno) VALUES
(1, 'Dermatología', true, 30),
(2, 'Clínica', true, 20),
(3, 'Traumatología', true, 40);

-- Profesionales
INSERT INTO Profesionales (idprofesional, idcontacto, rolmedico, activo) VALUES
(1, 1, true, true),
(2, 2, true, true),
(3, 3, true, true),
(4, 4, true, true),
(5, 5, true, true),
(6, 6, true, true),
(7, 7, true, true),
(8, 8, true, true),
(9, 9, true, true);

-- ProfServicios
INSERT INTO ProfServicios (idservicio, idprofesional, activo) VALUES
(1, 1, true), (1, 2, true), (1, 3, true),
(2, 4, true), (2, 5, true), (2, 6, true),
(3, 7, true), (3, 8, true), (3, 9, true);

-- AgendaProRegular (horarios 9-12hs)
INSERT INTO AgendaProRegular (idprofesional, idservicio, lun, hora_init_lun, hora_fin_lun) VALUES
(1, 1, true, '09:00:00', '12:00:00'),
(4, 2, true, '09:00:00', '12:00:00'),
(7, 3, true, '09:00:00', '12:00:00');

-- FichaMedica (para pacientes)
INSERT INTO FichaMedica (idficha, idcontacto, gruposang, cobertura, histenfermflia, observficha) VALUES
(1, 10, 'A+', 'OSDE', 'Padre con hipertensión', 'Paciente sin antecedentes propios'),
(2, 11, 'O-', 'Swiss Medical', 'Madre con diabetes', 'Consulta por control anual');

-- Turnos
INSERT INTO Turnos (idturno, idcontacto, idservicio, idprofesional, hora, dia, tipo, prioridad, reservado, confirmado, acreditado, atendido, observaciones, updtssystemuser, updatetime) VALUES
(1, 10, 1, 1, '09:00:00', '2025-04-21', 1, 1, true, true, true, false, 'Consulta de piel', 12, NOW()),
(2, 11, 2, 4, '09:30:00', '2025-04-21', 1, 2, true, true, true, false, 'Dolor de cabeza', 12, NOW()),
(3, 10, 3, 7, '10:00:00', '2025-04-21', 1, 3, true, true, true, false, 'Chequeo post cirugía', 12, NOW());

-- AgendaFeriados
INSERT INTO AgendaFeriados (dia, motivoferiado) VALUES
('2025-01-01', 'Año Nuevo'),
('2025-03-24', 'Día de la Memoria por la Verdad y la Justicia'),
('2025-04-18', 'Viernes Santo');

-- Chat
INSERT INTO Chat (idmsg, idchat, idcontactoemisor, idcontactoreceptor, msgdia, msghora, msgtexto, msgstatus) VALUES
(1, 1, 10, 12, '2025-04-10', '10:00:00', 'Hola, quería confirmar mi turno con el Dr. Pérez.', 'leido'),
(2, 1, 12, 10, '2025-04-10', '10:05:00', 'Hola Andrea, sí está confirmado para el lunes a las 9:00.', 'leido'),
(3, 2, 11, 12, '2025-04-10', '11:00:00', '¿Podés indicarme la dirección del consultorio?', 'leido');
