use OvercameDB;
/*
-- Clasificación de Usuarios y Privilegios
-- Usuario Administrador: Acceso completo.
create user 'admin'@'localhost' identified by 'admin123';
grant all privileges on OvercameDB.* to 'admin'@'localhost';

-- Usuario Empleado: Lectura y gestión de productos y reservas.
create user 'empleado'@'localhost' identified by 'empleado123';
grant select, insert, update on OvercameDB.Productos to 'empleado'@'localhost';
grant select, insert, update on OvercameDB.Reserva to 'empleado'@'localhost';

-- Usuario Cliente: Lectura de productos y creación de reservas.
create user 'cliente'@'localhost' identified by 'cliente123';
grant select on OvercameDB.Productos to 'cliente'@'localhost';
grant select, insert on OvercameDB.Reserva to 'cliente'@'localhost';

*/
-- Procedimiento Almacenado: Resumen de reservas por cliente
DELIMITER $$
drop procedure if exists ResumenReservasPorCliente$$
create procedure ResumenReservasPorCliente()
begin
  declare done int default 0;
  declare clienteId int;
  declare nombreCliente varchar(100);
  declare totalReservas int;
  declare cursorClientes cursor for select IdCliente, Nombre from Cliente;
  declare continue handler for not found set done = 1;

  open cursorClientes;
  read_loop: loop
    fetch cursorClientes into clienteId, nombreCliente;
    if done then
      leave read_loop;
    end if;
    set totalReservas = (select COUNT(*) from Reserva where IdCliente = clienteId);
    select CONCAT('Cliente: ', nombreCliente, ' - total Reservas: ', totalReservas) as Resumen;
  end loop;
  close cursorClientes;
end $$
DELIMITER ;

-- call ResumenReservasPorCliente();

-- Función Almacenada: Calcular el total de reservas para un coche
/*DELIMITER $$
drop function if exists totalReservasCoche$$
create function totalReservasCoche(cocheId int) returns int
deterministic
begin
  declare total int;
  set total = (select COUNT(*) from Reserva where IdCoche = cocheId);
  return total;
end $$
DELIMITER ;

select totalReservasCoche(4);
*/
-- Trigger: Validar precios antes de insertar en la tabla Productos
DELIMITER $$
drop trigger if exists ValidarPrecioProducto$$
create trigger ValidarPrecioProducto
before insert on Productos
for each row
begin
  if new.Precio <= 0 then
    signal sqlstate '45000' set MESSAGE_TEXT = 'El precio del producto debe ser mayor a 0.';
  end if;
end $$
DELIMITER ;

-- Calcular precio alquiler total de una reserva:
DELIMITER $$
drop trigger if exists CalcularPrecioReserva$$
create trigger CalcularPrecioReserva
before insert on reserva
for each row
begin
declare precio decimal;
	set precio = (select PrecioAlquiler from Coche where IdCoche = new.IdCoche);
	set new.PrecioAlquiler = precio * new.Duracion;
end $$
DELIMITER ;
 insert into Reserva(idCliente, idCoche, FechaInicio, Duracion) values (1, 2, current_date, 3);
 
-- Evento: Actualizar precios promedio de servicios cada semana
DELIMITER $$
create event ActualizarPromedioServicios
on schedule every 1 week
do
begin
  update Servicio
  set Precio = (select avg(Temp.Precio) from (select Precio from Servicio) as Temp);
end $$
DELIMITER ;

-- Crear
create table Resultados (
	Año year, 
    Mes tinyint unsigned check(mes between 1 and 12),
    TotalGanaciasAlquileres decimal
); 

SET GLOBAL event_scheduler=ON;

delimiter $$
drop event if exists GananciasAlquiler$$
create event GananciasAlquiler
on schedule every 1 month
do
begin
declare total decimal;
	set total = (select SUM(PrecioAlquiler) from Reserva where FechaInicio >= DATE_SUB(current_date, INTERVAL 1 month) and FechaInicio <= current_date());
    insert into Resultados values (year(current_date), month(current_date), total);
end$$
delimiter $$

event schedule 
-- Verificación de usuarios y privilegios
show grants for 'admin'@'localhost';
show grants for 'empleado'@'localhost';
show grants for 'cliente'@'localhost';