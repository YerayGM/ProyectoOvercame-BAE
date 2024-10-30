DROP DATABASE IF EXISTS OvercameDB;
CREATE DATABASE OvercameDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_as_cs;
USE OvercameDB;

-- Tabla Productos
CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Precio DECIMAL(10, 2)
);

-- Tabla Servicio
CREATE TABLE Servicio (
    IdServicio INT PRIMARY KEY,
    Tipo VARCHAR(100),
    Precio DECIMAL(10, 2),
    Duracion INT
);

-- Tabla Empleado
CREATE TABLE Empleado (
    IdEmpleado INT PRIMARY KEY,
    Nombre VARCHAR(100),
    DNI VARCHAR(20),
    Direccion VARCHAR(200)
);

-- Relación "Contiene" entre Servicio y Empleado
CREATE TABLE Contiene (
    IdServicio INT,
    IdEmpleado INT,
    FechaRealizacion DATE,
    PRIMARY KEY (IdServicio, IdEmpleado),
    FOREIGN KEY (IdServicio) REFERENCES Servicio(IdServicio),
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

-- Relación "Contrata a" entre Empleado y Servicio
CREATE TABLE Contrata (
    IdEmpleado INT,
    IdServicio INT,
    Contrato VARCHAR(100),
    Duracion INT,
    CostoServicio DECIMAL(10, 2),
    PRIMARY KEY (IdEmpleado, IdServicio),
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
    FOREIGN KEY (IdServicio) REFERENCES Servicio(IdServicio)
);

-- Tabla Overcame (Tienda)
CREATE TABLE Overcame (
    IdTienda INT PRIMARY KEY,
    Direccion VARCHAR(200),
    Telefono VARCHAR(20),
    Email VARCHAR(100)
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
    IdProveedor INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(200)
);

-- Tabla Taller
CREATE TABLE Taller (
    IdTaller INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Direccion VARCHAR(200)
);

-- Relación "Tiene un" entre Proveedor y Taller
CREATE TABLE TieneUn (
    IdProveedor INT,
    IdTaller INT,
    PRIMARY KEY (IdProveedor, IdTaller),
    FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor),
    FOREIGN KEY (IdTaller) REFERENCES Taller(IdTaller)
);

-- Tabla Coche
CREATE TABLE Coche (
    IdCoche INT PRIMARY KEY,
    Modelo VARCHAR(100),
    Marca VARCHAR(100),
    Año INT,
    Color VARCHAR(50)
);

-- Relación "Entrega" entre Proveedor, Coche y Productos
CREATE TABLE Entrega (
    IdProveedor INT,
    IdCoche INT,
    IdProducto INT,
    FechaEntrega DATE,
    Cantidad INT,
    PRIMARY KEY (IdProveedor, IdCoche, IdProducto, FechaEntrega),
    FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor),
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche),
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

-- Relación "Compra en" entre Overcame, Coche y Productos
CREATE TABLE Compra (
    IdTienda INT,
    IdCoche INT,
    IdProducto INT,
    FechaCompra DATE,
    Cantidad INT,
    PRIMARY KEY (IdTienda, IdCoche, IdProducto),
    FOREIGN KEY (IdTienda) REFERENCES Overcame(IdTienda),
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche),
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

-- Relación "Vende" entre Overcame y Coche
CREATE TABLE Venta (
    IdTienda INT,
    IdCoche INT,
    FechaCompra DATE,
    PRIMARY KEY (IdTienda, IdCoche),
    FOREIGN KEY (IdTienda) REFERENCES Overcame(IdTienda),
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche)
);

-- Relación "Trabaja con" entre Proveedor y Overcame
CREATE TABLE TrabajaCon (
    IdProveedor INT,
    IdTienda INT,
    PRIMARY KEY (IdProveedor, IdTienda),
    FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor),
    FOREIGN KEY (IdTienda) REFERENCES Overcame(IdTienda)
);

-- Relación "Mantiene" entre Taller y Coche
CREATE TABLE Mantiene (
    IdTaller INT,
    IdCoche INT,
    FechaMantenimiento DATE,
    Precio DECIMAL(10, 2),
    PRIMARY KEY (IdTaller, IdCoche, FechaMantenimiento),
    FOREIGN KEY (IdTaller) REFERENCES Taller(IdTaller),
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche)
);

-- Tabla Cliente
CREATE TABLE Cliente (
    IdCliente INT PRIMARY KEY,
    Nombre VARCHAR(100),
    DNI VARCHAR(20),
    Direccion VARCHAR(200),
    Telefono VARCHAR(20)
);

-- Tabla Seguro
CREATE TABLE Seguro (
    IdSeguro INT PRIMARY KEY,
    Tipo VARCHAR(100),
    Precio DECIMAL(10, 2),
    Duracion INT
);

-- Relación "Contratar" entre Seguro y Cliente
CREATE TABLE Contratar (
    IdSeguro INT,
    IdCliente INT,
    PRIMARY KEY (IdSeguro, IdCliente),
    FOREIGN KEY (IdSeguro) REFERENCES Seguro(IdSeguro),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

-- Relación "Realiza" entre Cliente y Reserva
CREATE TABLE Reserva (
    IdCliente INT,
    IdCoche INT,
    FechaInicio DATE,
    Duracion INT,
    PrecioAlquiler DECIMAL(10, 2),
    PRIMARY KEY (IdCliente, IdCoche, FechaInicio),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche)
);

-- Tabla CocheAlquiler
CREATE TABLE CocheAlquiler (
    IdCoche INT PRIMARY KEY,
    Matricula VARCHAR(20) UNIQUE,
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche)
);

-- Tabla CocheSegundaMano
CREATE TABLE CocheSegundaMano (
    IdCoche INT PRIMARY KEY,
    Matricula VARCHAR(20) UNIQUE,
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche)
);

-- Tabla CocheNuevo
CREATE TABLE CocheNuevo (
    IdCoche INT PRIMARY KEY,
    Matricula VARCHAR(20) UNIQUE,
    FOREIGN KEY (IdCoche) REFERENCES Coche(IdCoche)
);

-- Relación "Organiza" entre Empleado y Productos
CREATE TABLE Organiza (
    IdEmpleado INT,
    IdProducto INT,
    PRIMARY KEY (IdEmpleado, IdProducto),
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);