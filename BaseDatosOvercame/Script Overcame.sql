-- Borrado y creación de la base de datos
Drop database if exists OvercameDB;
Create database OvercameDB
character set utf8mb4 
collate utf8mb4_0900_as_cs;
Use OvercameDB;

-- Tabla Productos
Create table Productos (
    IdProducto int primary key,
    Nombre varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio >= 0)
);

-- Tabla Servicio
Create table Servicio (
    IdServicio int primary key,
    Tipo varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio >= 0),
    Duracion int not null check (Duracion > 0)
);

-- Tabla Empleado
Create table Empleado (
    IdEmpleado int primary key,
    Nombre varchar(100) not null,
    DNI varchar(20) unique not null,
    Direccion varchar(200) not null
);

-- Relación "Contiene" entre Servicio y Empleado
Create table Contiene (
    IdServicio int,
    IdEmpleado int,
    FechaRealizacion date not null,
    primary key (IdServicio, IdEmpleado, FechaRealizacion),
    foreign key (IdServicio) references Servicio(IdServicio) on delete cascade,
    foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete cascade
);

-- Relación "Contrata a" entre Empleado y Servicio
Create table Contrata (
    IdEmpleado int,
    IdServicio int,
    Contrato varchar(100) not null,
    Duracion int not null check (Duracion > 0),
    CostoServicio decimal(10, 2) not null check (CostoServicio >= 0),
    primary key (IdEmpleado, IdServicio),
    foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete cascade,
    foreign key (IdServicio) references Servicio(IdServicio) on delete cascade
);

-- Tabla Overcame (Tienda)
Create table Overcame (
    IdTienda int primary key,
    Direccion varchar(200) not null,
    Telefono varchar(20),
    Email varchar(100) not null
);

-- Tabla Proveedor
Create table Proveedor (
    IdProveedor int primary key,
    Nombre varchar(100) not null,
    Telefono varchar(20) not null,
    Email varchar(100),
    Direccion varchar(200)
);

-- Tabla Taller
Create table Taller (
    IdTaller int primary key,
    Nombre varchar(100) not null,
    Direccion varchar(200) not null
);

-- Relación "Tiene un" entre Proveedor y Taller
Create table TieneUn (
    IdProveedor int,
    IdTaller int,
    primary key (IdProveedor, IdTaller),
    foreign key (IdProveedor) references Proveedor(IdProveedor) on delete cascade,
    foreign key (IdTaller) references Taller(IdTaller) on delete cascade
);

-- Tabla Coche
Create table Coche (
    IdCoche int primary key,
    Modelo varchar(100) not null,
    Marca varchar(100) not null,
    Año int check (Año >= 1886),
    Color varchar(50)
);

-- Relación "Entrega" entre Proveedor, Coche y Productos
Create table Entrega (
    IdProveedor int,
    IdCoche int,
    IdProducto int,
    FechaEntrega date not null,
    Cantidad int not null check (Cantidad > 0),
    primary key (IdProveedor, IdCoche, IdProducto, FechaEntrega),
    foreign key (IdProveedor) references Proveedor(IdProveedor) on delete cascade,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade,
    foreign key (IdProducto) references Productos(IdProducto) on delete cascade
);

-- Relación "Compra en" entre Overcame, Coche y Productos
Create table Compra (
    IdTienda int,
    IdCoche int,
    IdProducto int,
    FechaCompra date not null,
    Cantidad int not null check (Cantidad > 0),
    primary key (IdTienda, IdCoche, IdProducto),
    foreign key (IdTienda) references Overcame(IdTienda) on delete cascade,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade,
    foreign key (IdProducto) references Productos(IdProducto) on delete cascade
);

-- Relación "Vende" entre Overcame y Coche
Create table Venta (
    IdTienda int,
    IdCoche int,
    FechaCompra date not null,
    primary key (IdTienda, IdCoche),
    foreign key (IdTienda) references Overcame(IdTienda) on delete cascade,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Relación "Trabaja con" entre Proveedor y Overcame
Create table TrabajaCon (
    IdProveedor int,
    IdTienda int,
    primary key (IdProveedor, IdTienda),
    foreign key (IdProveedor) references Proveedor(IdProveedor) on delete cascade,
    foreign key (IdTienda) references Overcame(IdTienda) on delete cascade
);

-- Relación "Mantiene" entre Taller y Coche
Create table Mantiene (
    IdTaller int,
    IdCoche int,
    FechaMantenimiento date not null,
    Precio decimal(10, 2) not null check (Precio >= 0),
    primary key (IdTaller, IdCoche, FechaMantenimiento),
    foreign key (IdTaller) references Taller(IdTaller) on delete cascade,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla Cliente
Create table Cliente (
    IdCliente int primary key,
    Nombre varchar(100) not null,
    DNI varchar(20) unique not null,
    Direccion varchar(200),
    Telefono varchar(20)
);

-- Tabla Seguro
Create table Seguro (
    IdSeguro int primary key,
    Tipo varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio >= 0),
    Duracion int not null check (Duracion > 0)
);

-- Relación "Contratar" entre Seguro y Cliente
Create table Contratar (
    IdSeguro int,
    IdCliente int,
    primary key (IdSeguro, IdCliente),
    foreign key (IdSeguro) references Seguro(IdSeguro) on delete cascade,
    foreign key (IdCliente) references Cliente(IdCliente) on delete cascade
);

-- Relación "Realiza" entre Cliente y Reserva
Create table Reserva (
    IdCliente int,
    IdCoche int,
    FechaInicio date not null,
    Duracion int not null check (Duracion > 0),
    PrecioAlquiler decimal(10, 2) not null check (PrecioAlquiler >= 0),
    primary key (IdCliente, IdCoche, FechaInicio),
    foreign key (IdCliente) references Cliente(IdCliente) on delete cascade,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla CocheAlquiler
Create table CocheAlquiler (
    IdCoche int primary key,
    Matricula varchar(20) unique not null,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla CocheSegundaMano
Create table CocheSegundaMano (
    IdCoche int primary key,
    Matricula varchar(20) unique not null,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla CocheNuevo
Create table CocheNuevo (
    IdCoche int primary key,
    Matricula varchar(20) unique not null,
    foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Relación "Organiza" entre Empleado y Productos
Create table Organiza (
    IdEmpleado int,
    IdProducto int,
    primary key (IdEmpleado, IdProducto),
    foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete cascade,
    foreign key (IdProducto) references Productos(IdProducto) on delete cascade
);

-- Ejemplo de datos iniciales
insert into Productos values (1, 'Aceite de Motor', 20.50), (2, 'Filtro de Aire', 15.00);
insert into Servicio values (1, 'Cambio de Aceite', 50.00, 30), (2, 'Revisión General', 150.00, 120);
insert into Empleado values (1, 'Carlos Perez', '12345678A', 'Calle Falsa 123');
insert into Overcame values (1, 'Av. Principal 45', '555-1234', 'info@overcame.com');
insert into Proveedor values (1, 'Proveedor1', '555-5678', 'proveedor1@example.com', 'Calle Industrial 1');
insert into Taller values (1, 'Taller Central', 'Av. Automotriz 123');
insert into Coche values (1, 'Model S', 'Tesla', 2022, 'Negro');