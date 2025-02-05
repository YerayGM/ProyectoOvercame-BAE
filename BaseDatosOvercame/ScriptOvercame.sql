Drop database if exists OvercameDB;
Create database OvercameDB
character set utf8mb4
collate utf8mb4_0900_as_cs;
Use OvercameDB;

-- Tabla Productos
Create table Productos (
    IdProducto int primary key not null auto_increment,
    Nombre varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio between 0 and 100000)
);

-- Tabla Servicio
Create table Servicio (
    IdServicio int primary key not null auto_increment,
    Tipo varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio between 0 and 100000),
    Duracion smallint unsigned not null check (Duracion between 1 and 10000)
);

-- Tabla Empleado
Create table Empleado (
    IdEmpleado int primary key not null auto_increment,
    Nombre varchar(100) not null,
    DNI varchar(20) unique not null,
    Direccion varchar(200) not null
);

-- Relación "Contiene" entre Servicio y Empleado
Create table Contiene (
    IdServicio int,
    IdEmpleado int,
    FechaRealizacion date not null,
    Primary key (IdServicio, IdEmpleado, FechaRealizacion),
    Foreign key (IdServicio) references Servicio(IdServicio) on delete restrict on update cascade,
    Foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete restrict on update cascade
);

-- Relación "Contrata a" entre Empleado y Servicio
Create table Contrata (
    IdEmpleado int,
    IdServicio int,
    Contrato varchar(100) not null,
    Duracion smallint unsigned not null check (Duracion between 1 and 10000),
    CostoServicio decimal(10, 2) not null check (CostoServicio between 0 and 100000),
    Primary key (IdEmpleado, IdServicio),
    Foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete restrict on update cascade,
    Foreign key (IdServicio) references Servicio(IdServicio) on delete restrict on update cascade
);

-- Tabla Overcame (Tienda)
Create table Overcame (
    IdTienda int primary key not null auto_increment,
    Direccion varchar(200) not null,
    Telefono varchar(20) check (Telefono rlike '^[6-9]{1}[0-9]{8}$'),
    Email varchar(100) not null
);

-- Tabla Proveedor
Create table Proveedor (
    IdProveedor int primary key not null auto_increment,
    Nombre varchar(100) not null,
    Telefono varchar(20) check (Telefono rlike '^[6-9]{1}[0-9]{8}$'),
    Email varchar(100),
    Direccion varchar(200)
);

-- Tabla Taller
Create table Taller (
    IdTaller int Primary key not null auto_increment,
    Nombre varchar(100) not null,
    Direccion varchar(200) not null
);

-- Relación "Tiene un" entre Proveedor y Taller
Create table TieneUn (
    IdProveedor int,
    IdTaller int,
    Primary key (IdProveedor, IdTaller),
    Foreign key (IdProveedor) references Proveedor(IdProveedor) on delete restrict on update cascade,
    Foreign key (IdTaller) references Taller(IdTaller) on delete restrict on update cascade
);

-- Tabla Coche
Create table Coche (
    IdCoche int primary key not null auto_increment,
    Modelo varchar(100) not null check (Modelo rlike '^[A-Za-z0-9 ]+$'),
    Marca varchar(100) not null check (Marca rlike '^[A-Za-z ]+$'),
    Año smallint unsigned check (Año between 1886 and 2025),
    Color varchar(50),
    PrecioAlquiler decimal 
);

-- Relación "Entrega" entre Proveedor, Coche y Productos
Create table Entrega (
    IdProveedor int,
    IdCoche int,
    IdProducto int,
    FechaEntrega date not null,
    Cantidad smallint unsigned not null check (Cantidad between 0 and 10000),
    Primary key (IdProveedor, IdCoche, IdProducto, FechaEntrega),
    Foreign key (IdProveedor) references Proveedor(IdProveedor) on delete restrict on update cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete restrict on update cascade,
    Foreign key (IdProducto) references Productos(IdProducto) on delete restrict on update cascade
);

-- Relación "Compra en" entre Overcame, Coche y Productos
Create table Compra (
    IdTienda int,
    IdCoche int,
    IdProducto int,
    FechaCompra date not null,
    Cantidad smallint unsigned not null check (Cantidad between 1 and 10000),
    Primary key (IdTienda, IdCoche, IdProducto),
    Foreign key (IdTienda) references Overcame(IdTienda) on delete restrict on update cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete restrict on update cascade,
    Foreign key (IdProducto) references Productos(IdProducto) on delete restrict on update cascade
);

-- Relación "Vende" entre Overcame y Coche
Create table Venta (
    IdTienda int,
    IdCoche int,
    FechaCompra date not null,
    Primary key (IdTienda, IdCoche),
    Foreign key (IdTienda) references Overcame(IdTienda) on delete restrict on update cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete restrict on update cascade
);

-- Relación "Trabaja con" entre Proveedor y Overcame
Create table TrabajaCon (
    IdProveedor int,
    IdTienda int,
    Primary key (IdProveedor, IdTienda),
    Foreign key (IdProveedor) references Proveedor(IdProveedor) on delete restrict on update cascade,
    Foreign key (IdTienda) references Overcame(IdTienda) on delete restrict on update cascade
);

-- Relación "Mantiene" entre Taller y Coche
Create table Mantiene (
    IdTaller int,
    IdCoche int,
    FechaMantenimiento date not null,
    Precio decimal(10, 2) not null check (Precio between 0 and 100000),
    Primary key (IdTaller, IdCoche, FechaMantenimiento),
    Foreign key (IdTaller) references Taller(IdTaller) on delete restrict on update cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete restrict on update cascade
);

-- Tabla Cliente
Create table Cliente (
    IdCliente int primary key not null auto_increment,
    Nombre varchar(100) not null,
    DNI varchar(20) unique not null,
    Direccion varchar(200),
    Telefono varchar(20) check (Telefono rlike '^[6-9]{1}[0-9]{8}$')
);

-- Tabla Seguro
Create table Seguro (
    IdSeguro int primary key not null auto_increment,
    Tipo varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio between 0 and 100000),
    Duracion smallint unsigned not null check (Duracion between 1 and 365)
);

-- Relación "Contratar" entre Seguro y Cliente
Create table Contratar (
    IdSeguro int,
    IdCliente int,
    Primary key (IdSeguro, IdCliente),
    Foreign key (IdSeguro) references Seguro(IdSeguro) on delete restrict on update cascade,
    Foreign key (IdCliente) references Cliente(IdCliente) on delete restrict on update cascade
);

-- Relación "Realiza" entre Cliente y Reserva
Create table Reserva (
    IdCliente int,
    IdCoche int,
    Fechainicio date not null,
    Duracion smallint unsigned not null check (Duracion between 1 and 10000),
    PrecioAlquiler decimal(10, 2) check (PrecioAlquiler between 0 and 100000),
    Primary key (IdCliente, IdCoche, Fechainicio),
    Foreign key (IdCliente) references Cliente(IdCliente) on delete restrict on update cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete restrict on update cascade
);

-- Crear la tabla Organiza
Create table Organiza (
    IdEmpleado int,
    IdProducto int,
    Primary key (IdEmpleado, IdProducto),
    Foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete restrict on update cascade,
    Foreign key (IdProducto) references Productos(IdProducto) on delete restrict on update cascade
);

-- inserción de productos
Insert into Productos (Nombre, Precio) values
('Aceite de Motor', 25.99),
('Filtro de Aire', 15.50),
('Bujía', 8.75),
('Llantas', 120.00),
('Frenos', 45.00);

Insert into Servicio (Tipo, Precio, Duracion) values 
('Cambio de Aceite', 50.00, 30),
('Alineación de Ruedas', 70.00, 45),
('Revisión General', 120.00, 60),
('Cambio de Ruedas', 100.00, 60);

Insert into Empleado (Nombre, DNI, Direccion) values 
('Juan Pérez', '12345678A', 'Calle 1, Ciudad A'),
('María López', '23456789B', 'Calle 2, Ciudad B');

Insert into Organiza (IdEmpleado, IdProducto) values
(1, 1),
(2, 2);

-- inserción de coches
Insert into Coche (IdCoche, Modelo, Marca, Año, Color, PrecioAlquiler) values
(1, 'Model S', 'Tesla', 2021, 'Negro', 30),
(2, 'Mustang', 'Ford', 2018, 'Rojo', 23),
(3, 'Civic', 'Honda', 2020, 'Azul', 47.54),
(4, 'Corsa', 'Opel', 2019, 'Blanco', 69),
(5, 'astra', 'Vauxhall', year(current_date), 'Verde', 0);

-- inserción de clientes
Insert into Cliente (IdCliente, Nombre, DNI, Direccion, Telefono) values
(1, 'Carlos Sánchez', '11122233C', 'Calle del Sol 44', '622345678'),
(2, 'Ana García', '44455566D', 'Avenida Luna 99', '633567890'),
(3, 'Lucía Martínez', '55566677E', 'Calle Esperanza 88', '644112233');

-- inserción de reservas
Insert into Reserva (IdCliente, IdCoche, Fechainicio, Duracion) values
(1, 1, '2024-01-01', 7),
(1, 1, '2024-04-12', 5),
(2, 2, '2024-01-05', 3);

-- inserción de proveedores
Insert into Proveedor (Nombre, Telefono, Email, Direccion) values
('Proveedor A', '622123456', 'proveedorA@example.com', 'Calle industrial 12'),
('Proveedor B', '633987654', 'proveedorB@example.com', 'Avenida Comercial 34'),
('Proveedor C', '644112233', 'proveedorC@example.com', 'Calle Central 56');

-- inserción de entregas de productos por proveedores
Insert into Entrega (IdProveedor, IdCoche, IdProducto, FechaEntrega, Cantidad) values
(1, 1, 1, '2024-01-10', 5), -- Proveedor A entregó 5 Aceites de Motor para el coche Model S
(1, 2, 2, '2024-01-12', 10), -- Proveedor A entregó 10 Filtros de Aire para el coche Mustang
(2, 3, 3, '2024-02-15', 15), -- Proveedor B entregó 15 Bujías para el coche Civic
(3, 4, 4, '2024-03-20', 7), -- Proveedor C entregó 7 Llantas para el coche Corsa
(2, 5, 1, '2024-03-14', 0); -- Proveedor B no entrego "Aceites de Motor" para el Vauxhall Astra

-- Consultas.
-- inner join: 
-- Ver qué empleados organizaron productos de un precion en especifico.
Select E.Nombre as Empleado, P.Nombre as Producto, P.Precio from Empleado E
inner join Organiza O on E.IdEmpleado = O.IdEmpleado
inner join Productos P on O.IdProducto = P.IdProducto where P.Precio > 20 and P.Precio < 50;

-- Ver los productos entregados por proveedores a coches especificos.
Select P.Nombre as Producto, C.Modelo as Coche, Pr.Nombre as Proveedor, E.FechaEntrega, E.Cantidad from Entrega E
inner join Productos P on E.IdProducto = P.IdProducto
inner join Coche C on E.IdCoche = C.IdCoche
inner join Proveedor Pr on E.IdProveedor = Pr.IdProveedor where E.Cantidad > 0;

-- Left/right join:
-- Cuantas reservas ha tenido cada coche incluidos los que no tienen reserva.
Select COUNT(R.IdCoche), C.IdCoche, C.Modelo, C.Marca from Reserva R
right join Coche C on C.IdCoche = R.IdCoche group by IdCoche;

-- Ver productos organizados por empleados y el total organizados.
Select E.Nombre as Empleado, COUNT(O.IdProducto) as TotalProductos from Empleado E
left join Organiza O on E.IdEmpleado = O.IdEmpleado group by E.Nombre;

-- group by.
-- Ver todas las reservas realizadas por clientes incluido los clientes que no han reservado.
Select C.Nombre as Cliente, COUNT(R.IdCoche) as TotalReservas from Cliente C
left join Reserva R on C.IdCliente = R.IdCliente
group by C.Nombre;

-- Ver el promedio de lo que cuesta los servicios segun su tipo.
Select S.Tipo, avg(S.Precio) as CostoPromedio from Servicio S group by S.Tipo;

-- Subconsulta.
-- Ver que coches han sido alquilados mas de una vez.
Select C.Modelo, C.Marca from Coche C
where (select COUNT(*) from Reserva R where R.IdCoche = C.IdCoche) > 1;

-- Ver proovedores que han entregado mas de 10 productos en total.
Select P.Nombre from Proveedor P
where (select SUM(E.Cantidad) from Entrega E where E.IdProveedor = P.IdProveedor) > 10;

-- insert/Update/Delete.
-- Inserta un cliente culla direccion es la misma de Carlos Sanchez.
Insert into Cliente (Nombre, DNI, Direccion, Telefono)
values ('Roberto Gómez', '66677788G', (select Direccion from Cliente C where Nombre = 'Carlos Sánchez'), '655123456');

-- Update el servicio con el precio promedio con todos los servicio de cambio.
Update Servicio SET Precio = (select avg(Temp.Precio) from (select Precio from Servicio where Tipo like 'Cambio%') as Temp)
where Tipo = 'Alineación de Ruedas';

-- Borra el Producto el cual no ha sido entregado.
Delete from Productos where IdProducto not in (select IdProducto from Entrega);

-- Verificar los datos de las tablas relevantes
Select * from Proveedor;
Select * from Entrega;
Select * from Coche;
Select * from Cliente;
Select * from Reserva;
Select * from Productos;
Select * from Servicio;