-- Seleccionar la base de datos
Use OvercameDB;

-- Creación de roles y usuarios
-- Crear el rol de administrador
Drop role if exists Administrador;
Create role if not exists Administrador;
Grant all privileges on OvercameDB.* to Administrador;

-- Crear el rol de gestor de servicios
Drop role if exists GestorServicios;
Create role if not exists GestorServicios;
Grant select, insert, update on OvercameDB.Servicio to GestorServicios;
Grant select, insert on OvercameDB.Empleado to GestorServicios;
Grant select on OvercameDB.Productos to GestorServicios;

-- Crear el rol de proveedor
Drop role if exists Proveedor;
Create role if not exists Proveedor;
Grant select, insert, update on OvercameDB.Proveedor to Proveedor;
Grant select, insert, update on OvercameDB.Entrega to Proveedor;

-- Crear el rol de cliente
Drop role if exists Cliente;
Create role if not exists Cliente;
Grant select, insert on OvercameDB.Reserva to Cliente;
Grant select on OvercameDB.Cliente to Cliente;

-- Creación de usuarios y asignación de roles
-- Usuario administrador
Create user if not exists 'admin_user'@'localhost' identified by 'AdminPass123';
Grant Administrador to 'admin_user'@'localhost';
Set default role Administrador to 'admin_user'@'localhost';

-- Usuario gestor de servicios
Create user if not exists 'gestor_user'@'localhost' identified by 'GestorPass123';
Grant GestorServicios to 'gestor_user'@'localhost';
Set default role GestorServicios to 'gestor_user'@'localhost';

-- Usuario proveedor
Create user if not exists 'proveedor_user'@'localhost' identified by 'ProveedorPass123';
Grant Proveedor to 'proveedor_user'@'localhost';
Set default role Proveedor to 'proveedor_user'@'localhost';

-- Usuario cliente
Create user if not exists 'cliente_user'@'localhost' identified by 'ClientePass123';
Grant Cliente to 'cliente_user'@'localhost';
Set default role Cliente to 'cliente_user'@'localhost';

-- Configuración de caducidad de contraseñas
Alter user 'admin_user'@'localhost' password expire interval 90 day;
Alter user 'gestor_user'@'localhost' password expire interval 90 day;
Alter user 'proveedor_user'@'localhost' password expire interval 90 day;
Alter user 'cliente_user'@'localhost' password expire interval 90 day;

-- Revisión de permisos
Show grants for 'admin_user'@'localhost';
Show grants for 'gestor_user'@'localhost';
Show grants for 'proveedor_user'@'localhost';
Show grants for 'cliente_user'@'localhost';

-- Eliminación de cuentas obsoletas
Drop user if exists 'old_user'@'localhost';