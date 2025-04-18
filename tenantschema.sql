-- Crear base de datos tenants y su tabla
CREATE DATABASE IF NOT EXISTS tenants;
USE tenants;

CREATE TABLE clientes (
    idcliente INT PRIMARY KEY AUTO_INCREMENT,
    nombreempresacliente TEXT NOT NULL,
    cuit BIGINT NOT NULL,
    contactonombre TEXT,
    contactorol TEXT,
    contactotel TEXT,
    base TEXT NOT NULL,
    habilitadohasta DATE,
    accesopublico BOOLEAN DEFAULT FALSE
);