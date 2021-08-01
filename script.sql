--Elimino base de datos si existiese.
DROP DATABASE clientes;

--Creo base de datos clientes.
CREATE DATABASE clientes;

--Conectarse a la DB clientes.
\c clientes;

--1. Cargar el respaldo de la base de datos unidad2.sql.
--psql -U ramiro clientes<unidad2.sql

\set AUTOCOMMIT off

--2.El cliente usuario01 ha realizado la siguiente compra
--producto: producto9
--cantidad: 5
--fecha: fecha del sistema

BEGIN TRANSACTION;

    --Se inserta una nueva compra.
    INSERT INTO compra(id, cliente_id, fecha)
    VALUES(33, 2, '2021-07-30');

    --Se inserta un nuevo detalle_compra
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(43, 9, 33, 5);

    --Se actualiza el stcok porque se venderían 5 productos.
    UPDATE producto SET stock = stock -5 WHERE id = 9;
    
COMMIT;
--La transaction anterior devuelve Rollback:



--3.El cliente usuario02 ha realizado la siguiente compra:
--producto: producto1, producto 2, producto 8
--cantidad: 3 de cada producto
--fecha: fecha del sistema

BEGIN TRANSACTION;

    --Se inserta una nueva compra.
    INSERT INTO compra(id, cliente_id, fecha)
    VALUES(34, 8, '2021-07-31');


    --Se inserta 3 nuevos detalle_compra
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(44, 1, 34, 3);
    
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(45, 2, 34, 3);

    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(46, 8, 34, 3);


    --Se actualizan los stocks.
    UPDATE producto SET stock = stock - 3 WHERE id = 1;

    UPDATE producto SET stock = stock - 3 WHERE id = 2;

    UPDATE producto SET stock = stock - 3 WHERE id = 8;
    
COMMIT;
-- Esta transaction devulve un Rollback



--4a. Deshabilitar el AUTOCOMMIT
\set AUTOCOMMIT off

--4b. Insertar un nuevo cliente
BEGIN TRANSACTION;
    SAVEPOINT antes_nuevo_cliente;

    INSERT INTO cliente(id, nombre, email)
    VALUES(11, 'usuario011', 'usuario011@hotmail.com');

    SAVEPOINT despues_nuevo_cliente;

--4c. Confirmar que fue agregado en la tabla cliente
    SELECT *
    FROM cliente
    ORDER BY id DESC;

--4d. Realizar un ROLLBACK
    ROLLBACK TO antes_nuevo_cliente;

--e. Confirmar que se restauró la información, sin considerar la inserción del punto b
    SELECT *
    FROM cliente
    ORDER BY id DESC;

COMMIT;

--f. Habilitar de nuevo el AUTOCOMMIT
\set AUTOCOMMIT ON




