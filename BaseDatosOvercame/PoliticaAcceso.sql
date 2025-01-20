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

-- Procedimiento Almacenado: Resumen de reservas por cliente
DELIMITER $$
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

-- Función Almacenada: Calcular el total de reservas para un coche
DELIMITER $$
create function totalReservasCoche(cocheId int) returns int
deterministic
begin
  declare total int;
  set total = (select COUNT(*) from Reserva where IdCoche = cocheId);
  return total;
end $$
DELIMITER ;

-- Trigger: Validar precios antes de insertar en la tabla Productos
DELIMITER $$
create trigger ValidarPrecioProducto
before insert on Productos
for each row
begin
  if new.Precio <= 0 then
    signal sqlstate '45000' set MESSAGE_TEXT = 'El precio del producto debe ser mayor a 0.';
  end if;
end $$
DELIMITER ;

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

-- Verificación de usuarios y privilegios
show grants for 'admin'@'localhost';
show grants for 'empleado'@'localhost';
show grants for 'cliente'@'localhost';