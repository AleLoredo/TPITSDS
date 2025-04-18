CREATE DATABASE IF NOT EXISTS centro_salud;
USE centro_salud;

CREATE TABLE Contactos (
    idcontacto INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    docum VARCHAR(50),
    tipodoc VARCHAR(20),
    fechanacim DATE,
    telcontacto VARCHAR(20),
    telemergencia VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(200)
);

CREATE TABLE SystemUsers (
    idusuario INT PRIMARY KEY,
    idcontacto INT,
    usuario VARCHAR(50),
    contraseña VARCHAR(100),
    rolpaciente BOOLEAN,
    rolmedico BOOLEAN,
    roladministrativo BOOLEAN,
    rolsuperadmin BOOLEAN,
    FOREIGN KEY (idcontacto) REFERENCES Contactos(idcontacto)
);

CREATE TABLE Profesionales (
    idprofesional INT PRIMARY KEY,
    idcontacto INT,
    rolmedico BOOLEAN,
    activo BOOLEAN,
    FOREIGN KEY (idcontacto) REFERENCES Contactos(idcontacto)
);

CREATE TABLE Servicios (
    idservicio INT PRIMARY KEY,
    nombre VARCHAR(100),
    activo BOOLEAN,
    duracionturno INT
);

CREATE TABLE ProfServicios (
    idservicio INT,
    idprofesional INT,
    activo BOOLEAN,
    PRIMARY KEY (idservicio, idprofesional),
    FOREIGN KEY (idservicio) REFERENCES Servicios(idservicio),
    FOREIGN KEY (idprofesional) REFERENCES Profesionales(idprofesional)
);

CREATE TABLE FichaMedica (
    idficha INT PRIMARY KEY,
    idcontacto INT,
    gruposang VARCHAR(5),
    cobertura VARCHAR(100),
    histerenfmlia TEXT,
    observficha TEXT,
    FOREIGN KEY (idcontacto) REFERENCES Contactos(idcontacto)
);

CREATE TABLE AgendaFeriados (
    dia DATE PRIMARY KEY,
    motivoferiado TEXT
);

CREATE TABLE AgendaProfExcep (
    idprofesional INT,
    idservicio INT,
    dia_inicio DATE,
    dia_fin DATE,
    hora_inicio TIME,
    hora_fin TIME,
    disponible BOOLEAN,
    motivo_inasistencia VARCHAR(255),
    PRIMARY KEY (idprofesional, idservicio, dia_inicio),
    FOREIGN KEY (idprofesional) REFERENCES Profesionales(idprofesional),
    FOREIGN KEY (idservicio) REFERENCES Servicios(idservicio)
);

CREATE TABLE AgendaProRegular (
    idprofesional INT,
    idservicio INT,
    lun BOOLEAN,
    hora_init_lun TIME,
    hora_fin_lun TIME,
    mar BOOLEAN,
    hora_init_mar TIME,
    hora_fin_mar TIME,
    mie BOOLEAN,
    hora_init_mie TIME,
    hora_fin_mie TIME,
    jue BOOLEAN,
    hora_init_jue TIME,
    hora_fin_jue TIME,
    vie BOOLEAN,
    hora_init_vie TIME,
    hora_fin_vie TIME,
    sab BOOLEAN,
    hora_init_sab TIME,
    hora_fin_sab TIME,
    dom BOOLEAN,
    hora_init_dom TIME,
    hora_fin_dom TIME,
    PRIMARY KEY (idprofesional, idservicio),
    FOREIGN KEY (idprofesional) REFERENCES Profesionales(idprofesional),
    FOREIGN KEY (idservicio) REFERENCES Servicios(idservicio)
);

CREATE TABLE Turnos (
    idturno INT PRIMARY KEY,
    idcontacto INT,
    idservicio INT,
    idprofesional INT,
    hora TIME,
    dia DATE,
    tipo INT,
    prioridad INT,
    reservado BOOLEAN,
    confirmado BOOLEAN,
    acreditado BOOLEAN,
    atendido BOOLEAN,
    observaciones TEXT,
    updsystemuser INT,
    updatetime DATETIME,
    FOREIGN KEY (idcontacto) REFERENCES Contactos(idcontacto),
    FOREIGN KEY (idservicio) REFERENCES Servicios(idservicio),
    FOREIGN KEY (idprofesional) REFERENCES Profesionales(idprofesional),
    FOREIGN KEY (updsystemuser) REFERENCES SystemUsers(idusuario)
);

CREATE TABLE Chat (
    idmsg INT PRIMARY KEY,
    idchat INT,
    idcontactoemisor INT,
    idcontactoreceptor INT,
    msgdia DATE,
    msghora TIME,
    msgtexto TEXT,
    msgstatus INT,
    FOREIGN KEY (idcontactoreceptor) REFERENCES Contactos(idcontacto),
    FOREIGN KEY (idcontactoemisor) REFERENCES Contactos(idcontacto)
);

