-- Borrado y creación de la base de datos
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
    Duracion int not null check (Duracion between 1 and 10000)
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
    Foreign key (IdServicio) references Servicio(IdServicio) on delete cascade,
    Foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete cascade
);

-- Relación "Contrata a" entre Empleado y Servicio
Create table Contrata (
    IdEmpleado int,
    IdServicio int,
    Contrato varchar(100) not null,
    Duracion int not null check (Duracion between 1 and 10000),
    CostoServicio decimal(10, 2) not null check (CostoServicio between 0 and 100000),
    Primary key (IdEmpleado, IdServicio),
    Foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete cascade,
    Foreign key (IdServicio) references Servicio(IdServicio) on delete cascade
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
    IdTaller int primary key not null auto_increment,
    Nombre varchar(100) not null,
    Direccion varchar(200) not null
);

-- Relación "Tiene un" entre Proveedor y Taller
Create table TieneUn (
    IdProveedor int,
    IdTaller int,
    Primary key (IdProveedor, IdTaller),
    Foreign key (IdProveedor) references Proveedor(IdProveedor) on delete cascade,
    Foreign key (IdTaller) references Taller(IdTaller) on delete cascade
);

-- Tabla Coche
Create table Coche (
    IdCoche int primary key not null auto_increment,
    Modelo varchar(100) not null check (Modelo rlike '^[A-Za-z0-9 ]+$'),
    Marca varchar(100) not null check (Marca rlike '^[A-Za-z0-9 ]+$'),
    Año int check (Año between 1886 and 2024),
    Color varchar(50)
);

-- Relación "Entrega" entre Proveedor, Coche y Productos
Create table Entrega (
    IdProveedor int,
    IdCoche int,
    IdProducto int,
    FechaEntrega date not null,
    Cantidad int not null check (Cantidad between 1 and 10000),
    Primary key (IdProveedor, IdCoche, IdProducto, FechaEntrega),
    Foreign key (IdProveedor) references Proveedor(IdProveedor) on delete cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade,
    Foreign key (IdProducto) references Productos(IdProducto) on delete cascade
);

-- Relación "Compra en" entre Overcame, Coche y Productos
Create table Compra (
    IdTienda int,
    IdCoche int,
    IdProducto int,
    FechaCompra date not null,
    Cantidad int not null check (Cantidad between 1 and 10000),
    Primary key (IdTienda, IdCoche, IdProducto),
    Foreign key (IdTienda) references Overcame(IdTienda) on delete cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade,
    Foreign key (IdProducto) references Productos(IdProducto) on delete cascade
);

-- Relación "Vende" entre Overcame y Coche
Create table Venta (
    IdTienda int,
    IdCoche int,
    FechaCompra date not null,
    Primary key (IdTienda, IdCoche),
    Foreign key (IdTienda) references Overcame(IdTienda) on delete cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Relación "Trabaja con" entre Proveedor y Overcame
Create table TrabajaCon (
    IdProveedor int,
    IdTienda int,
    Primary key (IdProveedor, IdTienda),
    Foreign key (IdProveedor) references Proveedor(IdProveedor) on delete cascade,
    Foreign key (IdTienda) references Overcame(IdTienda) on delete cascade
);

-- Relación "Mantiene" entre Taller y Coche
Create table Mantiene (
    IdTaller int,
    IdCoche int,
    FechaMantenimiento date not null,
    Precio decimal(10, 2) not null check (Precio between 0 and 100000),
    Primary key (IdTaller, IdCoche, FechaMantenimiento),
    Foreign key (IdTaller) references Taller(IdTaller) on delete cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade
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
    Duracion int not null check (Duracion between 1 and 10000)
);

-- Relación "Contratar" entre Seguro y Cliente
Create table Contratar (
    IdSeguro int,
    IdCliente int,
    Primary key (IdSeguro, IdCliente),
    Foreign key (IdSeguro) references Seguro(IdSeguro) on delete cascade,
    Foreign key (IdCliente) references Cliente(IdCliente) on delete cascade
);

-- Relación "Realiza" entre Cliente y Reserva
Create table Reserva (
    IdCliente int,
    IdCoche int,
    FechaInicio date not null,
    Duracion int not null check (Duracion between 1 and 10000),
    PrecioAlquiler decimal(10, 2) not null check (PrecioAlquiler between 0 and 100000),
    Primary key (IdCliente, IdCoche, FechaInicio),
    Foreign key (IdCliente) references Cliente(IdCliente) on delete cascade,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla CocheAlquiler
Create table CocheAlquiler (
    IdCoche int primary key not null auto_increment,
    Matricula varchar(20) unique not null,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla CocheSegundaMano
Create table CocheSegundaMano (
    IdCoche int primary key not null auto_increment,
    Matricula varchar(20) unique not null,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Tabla CocheNuevo
Create table CocheNuevo (
    IdCoche int primary key not null auto_increment,
    Matricula varchar(20) unique not null,
    Foreign key (IdCoche) references Coche(IdCoche) on delete cascade
);

-- Relación "Organiza" entre Empleado y Productos
Create table Organiza (
    IdEmpleado int,
    IdProducto int,
    Primary key (IdEmpleado, IdProducto),
    Foreign key (IdEmpleado) references Empleado(IdEmpleado) on delete cascade,
    Foreign key (IdProducto) references Productos(IdProducto) on delete cascade
);


-- Inserción de datos de ejemplo
Insert into Cliente (IdCliente, Nombre, DNI, Direccion, Telefono) values 
    (1, 'Carlos Lopez', '12345678A', 'Calle Falsa 123', '654321987'),
    (2, 'María Perez', '87654321B', 'Calle Verdadera 456', '643219876'),
    (3, 'Luis Gonzalez', '13579246C', 'Avenida Real 789', '632198765');

Insert into Productos values 
    (1, 'Aceite de Motor', 20.50), 
    (2, 'Filtro de Aire', 15.00), 
    (3, 'Bujías', 10.00);

Insert into Servicio values 
    (1, 'Cambio de Aceite', 50.00, 30), 
    (2, 'Revisión General', 150.00, 120), 
    (3, 'Cambio de Filtro', 30.00, 20);

Insert into Empleado values 
    (1, 'Carlos Perez', '12345678A', 'Calle Falsa 123'), 
    (2, 'Maria Lopez', '87654321B', 'Calle Verdadera 456'), 
    (3, 'Luis Gonzalez', '13579246C', 'Avenida Real 789');

Insert into Overcame values 
    (1, 'Av. Principal 45', '655512634', 'info@overcame.com'),
    (2, 'Calle Secundaria 78', '611223344', 'contact@overcame2.com');

Insert into Proveedor values 
    (1, 'Proveedor1', '655556678', 'proveedor1@example.com', 'Calle Industrial 1'),
    (2, 'Proveedor2', '677889900', 'proveedor2@example.com', 'Calle Comercial 22');

Insert into Taller values 
    (1, 'Taller Central', 'Av. Automotriz 123'),
    (2, 'Taller Norte', 'Calle del Motor 45');

Insert into Coche values 
    (1, 'Model S', 'Tesla', 2022, 'Negro'), 
    (2, 'Model X', 'Tesla', 2023, 'Blanco'), 
    (3, 'Mustang', 'Ford', 2021, 'Rojo'),
    (4, 'Civic', 'Honda', 2020, 'Azul');

Insert into Reserva values 
    (1, 1, '2024-01-01', 7, 100.00),
    (2, 3, '2024-01-05', 3, 50.00);

-- Consultas
-- INNER JOIN: Consulta productos organizados por empleados
-- Descripción: Muestra qué empleados están organizando qué productos.
Select E.Nombre as Empleado, P.Nombre as Producto
from Empleado E
inner join Organiza O on E.IdEmpleado = O.IdEmpleado
inner join Productos P on O.IdProducto = P.IdProducto;

-- LEFT JOIN: Ver todos los coches y los proveedores que los entregaron
-- Descripción: Muestra todos los coches, incluso los que no tienen proveedor asignado.
Select C.Modelo, C.Marca, P.Nombre as Proveedor
from Coche C
left join Entrega E on C.IdCoche = E.IdCoche
left join Proveedor P on E.IdProveedor = P.IdProveedor;

-- RIGHT JOIN: Ver todos los proveedores y los coches que entregaron
-- Descripción: Muestra todos los proveedores, incluso los que no han entregado coches.
Select P.Nombre as Proveedor, C.Modelo as Coche
from Proveedor P
right join Entrega E on P.IdProveedor = E.IdProveedor
right join Coche C on E.IdCoche = C.IdCoche;

-- GROUP BY: Calcular el total de productos entregados por cada proveedor
-- Descripción: Agrupa las entregas por proveedor y calcula el total de productos entregados.
Select P.Nombre as Proveedor, SUM(E.Cantidad) as TotalProductos
from Proveedor P
inner join Entrega E on P.IdProveedor = E.IdProveedor
group by P.Nombre;

-- Funciones agregadas: Máximo y promedio de precios en productos
-- Descripción: Calcula el precio máximo y promedio de los productos.
Select MAX(Precio) as PrecioMaximo, AVG(Precio) as PrecioPromedio
from Productos;

-- SUBCONSULTA: Encontrar los empleados que organizaron más de un producto
-- Descripción: Busca empleados que están organizando múltiples productos.
Select E.Nombre
from Empleado E
where (Select COUNT(*) from Organiza O where O.IdEmpleado = E.IdEmpleado) > 1;

-- SUBCONSULTA CORRELACIONADA: Proveedores que entregaron coches en 2023
-- Descripción: Lista proveedores que hayan realizado entregas en 2023.
Select distinct P.Nombre
from Proveedor P
where exists (
    Select 1
    from Entrega E
    where E.IdProveedor = P.IdProveedor and YEAR(E.FechaEntrega) = 2023
);

-- INSERT: Agregar un nuevo cliente
-- Descripción: Añade un nuevo cliente a la base de datos.
Insert into Cliente (IdCliente, Nombre, DNI, Direccion, Telefono) 
values (4, 'Ana García', '98765432D', 'Calle de la Paz 10', '645332211');

-- UPDATE: Actualizar el precio de un producto
-- Descripción: Modifica el precio del producto con IdProducto = 2.
Update Productos set Precio = 18.00 where IdProducto = 2;

-- DELETE: Eliminar un servicio específico
-- Descripción: Elimina un servicio con IdServicio = 3.
Delete from Servicio where IdServicio = 3;