-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-06-2025 a las 00:47:42
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_proveedor` (IN `p_id_proveedor` INT, IN `p_razonsocial` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
    UPDATE proveedores
    SET razonsocial = p_razonsocial,
        direccion = p_direccion,
        telefono = p_telefono
    WHERE id_proveedor = p_id_proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_proveedor` (IN `p_razonsocial` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
    INSERT INTO proveedores (razonsocial, direccion, telefono)
    VALUES (p_razonsocial, p_direccion, p_telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_proveedor` (IN `p_id_proveedor` INT)   BEGIN
    DELETE FROM proveedores
    WHERE id_proveedor = p_id_proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_detalle_venta` (IN `p_id_venta` INT, IN `p_id_producto` INT, IN `p_cantidad` INT)   BEGIN
    INSERT INTO ventas_detalle (id_venta, id_producto, cantidad)
    VALUES (p_id_venta, p_id_producto, p_cantidad);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_venta` (IN `p_id_cliente` INT, OUT `p_id_venta` INT)   BEGIN
    INSERT INTO ventas (id_cliente) VALUES (p_id_cliente);
    SET p_id_venta = LAST_INSERT_ID();  -- Obtener el ID generado
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_categorias` ()   BEGIN
    SELECT * FROM categorias;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_proveedores` ()   BEGIN
    SELECT * FROM proveedores;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_cabecera_venta` (IN `p_id_venta` INT)   BEGIN
    SELECT 
        v.id_venta, 
        v.fecha, 
        c.nombres AS nombre_cliente
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE v.id_venta = p_id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_clientes` ()   BEGIN
    SELECT id_cliente, nombres, apellidos FROM clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_cliente_id` (`p_id_cliente` INT)   BEGIN
 
 SELECT nombres, apellidos FROM clientes WHERE id_cliente =p_id_cliente;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_detalle_venta` (IN `p_id_venta` INT)   BEGIN
    SELECT 
        p.id_producto, 
        p.nombre AS nombre_producto, 
        p.precio,        -- Precio desde productos
        vd.cantidad,
        (p.precio * vd.cantidad) AS importe
    FROM ventas_detalle vd
    INNER JOIN productos p ON vd.id_producto = p.id_producto
    WHERE vd.id_venta = p_id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_producto` ()   BEGIN
 SELECT id_producto, nombre, precio, stock FROM productos;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_producto_id` (`p_id_producto` INT)   BEGIN
   SELECT nombre, precio, stock FROM productos WHERE id_producto =p_id_producto;
 
 
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_proveedor_por_id` (IN `p_id` INT)   BEGIN
    SELECT * FROM proveedores WHERE id_proveedor = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_ultima_venta` (OUT `p_id_venta` INT)   BEGIN
    SELECT MAX(id_venta) INTO p_id_venta FROM ventas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_cliente` (IN `p_id_cliente` INT, IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
  UPDATE clientes
  SET nombres = p_nombres,
      apellidos = p_apellidos,
      direccion = p_direccion,
      telefono = p_telefono
  WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_estado_venta` (IN `id_venta` INT, IN `nuevo_estado` VARCHAR(20))   BEGIN
    -- Actualizar el estado de la venta
    UPDATE ventas
    SET estado = nuevo_estado
    WHERE id_venta = id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_producto` (IN `p_id_producto` INT, IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(18,2), IN `p_stock` INT, IN `p_id_categoria` INT, IN `p_id_proveedor` INT)   BEGIN
  UPDATE productos
  SET nombre= p_descripcion,
      precio = p_precio,
      stock = p_stock,
      id_categoria = p_id_categoria,
      id_proveedor = p_id_proveedor
  WHERE id_producto = p_id_producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_cliente_por_id` (IN `p_id_cliente` INT)   BEGIN
    SELECT * FROM clientes WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_producto` (IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(18,2), IN `p_stock` INT, IN `p_id_categoria` INT, IN `p_id_proveedor` INT)   BEGIN
  INSERT INTO productos (nombre, precio, stock, id_categoria, id_proveedor)
  VALUES (p_descripcion, p_precio, p_stock, p_id_categoria, p_id_proveedor);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_cliente` (IN `p_id_cliente` INT)   BEGIN
  DELETE FROM clientes
  WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_producto` (IN `p_id_producto` INT)   BEGIN
  DELETE FROM productos
  WHERE id_producto = p_id_producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_guardar_venta` (IN `p_id_cliente` INT, IN `p_productos_json` JSON, OUT `mensaje` VARCHAR(100))   BEGIN
    DECLARE v_id_venta INT;
    DECLARE v_total_productos INT;
    DECLARE i INT DEFAULT 0;
    DECLARE v_id_producto INT;
    DECLARE v_cantidad INT;

    -- Bloque con etiqueta para usar LEAVE
    proc: BEGIN

        -- Validar cliente
        IF p_id_cliente IS NULL OR p_id_cliente <= 0 THEN
            SET mensaje = '❌ Debes seleccionar un cliente válido.';
            LEAVE proc;
        END IF;

        -- Validar productos
        SET v_total_productos = JSON_LENGTH(p_productos_json);
        IF v_total_productos IS NULL OR v_total_productos = 0 THEN
            SET mensaje = '❌ Debes seleccionar al menos un producto para registrar la venta.';
            LEAVE proc;
        END IF;

        -- Insertar venta
        INSERT INTO ventas(id_cliente, fecha)
        VALUES (p_id_cliente, NOW());
        SET v_id_venta = LAST_INSERT_ID();

        -- Recorrer productos
        WHILE i < v_total_productos DO
            SET v_id_producto = JSON_UNQUOTE(JSON_EXTRACT(p_productos_json, CONCAT('$[', i, '].id_producto')));
            SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_productos_json, CONCAT('$[', i, '].cantidad')));

            -- Validaciones básicas por cada producto
            IF v_id_producto IS NULL OR v_id_producto <= 0 OR v_cantidad IS NULL OR v_cantidad <= 0 THEN
                SET mensaje = CONCAT('❌ Producto inválido en la posición ', i + 1);
                LEAVE proc;
            END IF;

            -- Insertar detalle
            INSERT INTO detalle_venta(id_venta, id_producto, cantidad)
            VALUES (v_id_venta, v_id_producto, v_cantidad);

            SET i = i + 1;
        END WHILE;

        -- Si todo va bien
        SET mensaje = CONCAT('✅ Venta registrada con ID: ', v_id_venta);
        
    END proc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))   BEGIN
    -- Validaciones
    IF p_nombres IS NULL OR CHAR_LENGTH(TRIM(p_nombres)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nombre obligatorio';
    END IF;

    IF CHAR_LENGTH(p_nombres) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nombre excede 50 caracteres';
    END IF;

    IF p_apellidos IS NOT NULL AND CHAR_LENGTH(p_apellidos) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Apellido excede 50 caracteres';
    END IF;

    IF p_direccion IS NOT NULL AND CHAR_LENGTH(p_direccion) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Dirección excede 50 caracteres';
    END IF;

    IF p_telefono IS NOT NULL AND (CHAR_LENGTH(p_telefono) < 6 OR CHAR_LENGTH(p_telefono) > 15) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Teléfono inválido';
    END IF;

    -- Inserción
    INSERT INTO clientes (nombres, apellidos, direccion, telefono)
    VALUES (p_nombres, p_apellidos, p_direccion, p_telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_detalle_venta` (IN `id_venta` INT, IN `id_producto` INT, IN `cantidad` INT, IN `precio` DECIMAL(10,2))   BEGIN
    -- Insertar detalle de la venta
    INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio)
    VALUES (id_venta, id_producto, cantidad, precio);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_usuario` (IN `p_nombre_usuario` VARCHAR(50), IN `p_contrasena` VARCHAR(100), IN `p_correo` VARCHAR(100))   BEGIN
  INSERT INTO usuarios (nombre_usuario, contrasena, correo)
  VALUES (p_nombre_usuario, p_contrasena, p_correo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_venta` (IN `id_cliente` INT, IN `id_usuario` INT, IN `total` DECIMAL(10,2), IN `fecha_compra` DATE)   BEGIN
    DECLARE id_venta INT;
    -- Insertar la venta
    INSERT INTO ventas (id_cliente, id_usuario, total, fechaCompra, estado)
    VALUES (id_cliente, id_usuario, total, fecha_compra, 'pendiente');
    -- Obtener el ID de la venta recién insertada
    SET id_venta = LAST_INSERT_ID();
    -- Devolver el ID de la venta insertada
    SELECT id_venta AS id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_categorias` ()   BEGIN
  SELECT id_categoria, nombre FROM categorias;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_cliente` ()   BEGIN
    SELECT id_cliente, nombres, apellidos FROM clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_clientes` ()   BEGIN
  SELECT * FROM clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_productos` ()   BEGIN
  SELECT 
    p.id_producto, 
    p.nombre, 
    p.precio, 
    p.stock,
    c.descripcion AS categoria,
    pr.razonsocial AS proveedor
  FROM productos p
  JOIN categorias c ON p.id_categoria = c.id_categoria
  JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_proveedores` ()   BEGIN
  SELECT id_proveedor, razonsocial FROM proveedores;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_id_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50))   BEGIN
  SELECT id_cliente
  FROM clientes
  WHERE nombres = p_nombres AND apellidos = p_apellidos
  LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_productos_por_venta` (IN `id_venta` INT)   BEGIN
    -- Obtener todos los productos vendidos en una venta
    SELECT v.id_producto, p.nombre, vd.cantidad, vd.precio
    FROM ventas_detalle vd
    JOIN productos p ON vd.id_producto = p.id_producto
    WHERE vd.id_venta = id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_usuario_por_id` (IN `p_id_usuario` INT)   BEGIN
  SELECT * FROM usuarios WHERE id_usuario = p_id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_usuario` (IN `p_nombre_usuario` VARCHAR(50), IN `p_correo` VARCHAR(100))   BEGIN
  SELECT * FROM usuarios 
  WHERE nombre_usuario = p_nombre_usuario AND correo = p_correo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verificar_stock` (IN `id_producto` INT, IN `cantidad` INT)   BEGIN
    DECLARE stock_actual INT;
    -- Obtener el stock actual del producto
    SELECT stock INTO stock_actual
    FROM productos
    WHERE id_producto = id_producto;
    -- Verificar si hay suficiente stock
    IF stock_actual >= cantidad THEN
        SELECT 'Stock suficiente' AS mensaje;
    ELSE
        SELECT 'Stock insuficiente' AS mensaje;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verificar_login` (IN `p_usuario` VARCHAR(50), IN `p_contrasena` VARCHAR(255))   BEGIN
    SELECT * FROM usuarios 
    WHERE nombre_usuario = p_usuario AND contrasena = p_contrasena;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_actualizar_cliente` (`p_id_cliente` INT, `p_nombres` VARCHAR(50), `p_apellidos` VARCHAR(50), `p_direccion` VARCHAR(100), `p_dni` VARCHAR(8)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_id_cliente IS NULL OR p_id_cliente <= 0
        OR p_nombres IS NULL OR CHAR_LENGTH(TRIM(p_nombres)) < 2
        OR p_apellidos IS NULL OR CHAR_LENGTH(TRIM(p_apellidos)) < 2
        OR p_direccion IS NULL OR CHAR_LENGTH(TRIM(p_direccion)) < 5
        OR p_dni IS NULL OR NOT p_dni REGEXP '^[0-9]{8}$' THEN
        SET msg = '❌ Datos inválidos para actualizar cliente.';
    ELSE
        UPDATE clientes
        SET nombres = p_nombres,
            apellidos = p_apellidos,
            direccion = p_direccion,
            dni = p_dni
        WHERE id_cliente = p_id_cliente;

        SET msg = '✅ Cliente actualizado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_actualizar_producto` (`p_id_producto` INT, `p_nombre` VARCHAR(100), `p_precio` DECIMAL(10,2), `p_stock` INT, `p_id_categoria` INT, `p_id_proveedor` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_id_producto IS NULL OR p_id_producto <= 0
        OR p_nombre IS NULL OR TRIM(p_nombre) = ''
        OR p_precio IS NULL OR p_precio <= 0
        OR p_stock IS NULL OR p_stock < 0
        OR p_id_categoria IS NULL OR p_id_categoria <= 0
        OR p_id_proveedor IS NULL OR p_id_proveedor <= 0 THEN
        SET msg = '❌ Todos los campos deben estar completos y válidos.';

    ELSE
        UPDATE productos
        SET nombre = p_nombre,
            precio = p_precio,
            stock = p_stock,
            id_categoria = p_id_categoria,
            id_proveedor = p_id_proveedor
        WHERE id_producto = p_id_producto;

        SET msg = '✅ Producto actualizado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_actualizar_proveedor` (`p_id_proveedor` INT, `p_rs` VARCHAR(100), `p_direccion` VARCHAR(100), `p_telefono` VARCHAR(20)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_id_proveedor IS NULL OR p_id_proveedor <= 0
        OR p_rs IS NULL OR CHAR_LENGTH(TRIM(p_rs)) < 3
        OR p_direccion IS NULL OR CHAR_LENGTH(TRIM(p_direccion)) < 5
        OR p_telefono IS NULL OR NOT p_telefono REGEXP '^[0-9]{9}$' THEN
        SET msg = '❌ Datos inválidos para actualizar proveedor.';
    ELSE
        UPDATE proveedores
        SET razonsocial = p_rs,
            direccion = p_direccion,
            telefono = p_telefono
        WHERE id_proveedor = p_id_proveedor;

        SET msg = '✅ Proveedor actualizado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_crear_producto` (`p_nombre` VARCHAR(100), `p_descripcion` VARCHAR(255), `p_precio` DECIMAL(10,2), `p_stock` INT, `p_id_categoria` INT, `p_id_proveedor` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_nombre IS NULL OR TRIM(p_nombre) = '' OR
       p_precio <= 0 OR p_stock < 0 OR
       p_id_categoria <= 0 OR p_id_proveedor <= 0 THEN
        SET msg = '❌ Datos inválidos para crear producto.';
    ELSE
        INSERT INTO productos(nombre, descripcion, precio, stock, id_categoria, id_proveedor)
        VALUES (p_nombre, p_descripcion, p_precio, p_stock, p_id_categoria, p_id_proveedor);
        SET msg = '✅ Producto creado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_crear_proveedor` (`p_rs` VARCHAR(100), `p_direccion` VARCHAR(100), `p_telefono` VARCHAR(20)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    -- Validación de campos obligatorios y nulos
    IF p_rs IS NULL OR TRIM(p_rs) = ''
        OR p_direccion IS NULL OR TRIM(p_direccion) = ''
        OR p_telefono IS NULL OR TRIM(p_telefono) = '' THEN
        SET msg = '❌ Todos los campos son obligatorios.';

    -- Validar longitud mínima de razón social (mínimo 3 caracteres)
    ELSEIF CHAR_LENGTH(TRIM(p_rs)) < 3 THEN
        SET msg = '❌ La razón social debe tener al menos 3 caracteres.';

    -- Validar dirección mínima (mínimo 5 caracteres)
    ELSEIF CHAR_LENGTH(TRIM(p_direccion)) < 5 THEN
        SET msg = '❌ La dirección debe tener al menos 5 caracteres.';

    -- Validar formato del teléfono (solo dígitos y exactamente 9 dígitos)
    ELSEIF NOT p_telefono REGEXP '^[0-9]{9}$' THEN
        SET msg = '❌ El teléfono debe tener exactamente 9 dígitos numéricos.';

    -- Si todo está bien, insertar
    ELSE
        INSERT INTO proveedores (razonsocial, direccion, telefono)
        VALUES (p_rs, p_direccion, p_telefono);
        SET msg = '✅ Proveedor creado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_eliminar_producto` (`p_id_producto` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_id_producto IS NULL OR p_id_producto <= 0 THEN
        SET msg = '❌ ID de producto inválido.';
    ELSEIF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = p_id_producto) THEN
        SET msg = '❌ El producto no existe.';
    ELSE
        DELETE FROM productos WHERE id_producto = p_id_producto;
        SET msg = '✅ Producto eliminado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_eliminar_proveedor` (`p_id` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        RETURN '❌ ID inválido';
    END IF;
    CALL eliminar_proveedor(p_id);
    RETURN '✅ Proveedor eliminado';
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_guardar_venta` (`p_id_cliente` INT, `p_productos_json` JSON) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE v_id_venta INT;

    -- Insertar cabecera (columna correcta es 'fecha', no 'fecha_venta')
    INSERT INTO ventas(id_cliente, fecha)
    VALUES (p_id_cliente, NOW());

    SET v_id_venta = LAST_INSERT_ID();

    -- Aquí puedes continuar con insertar los productos desde el JSON...

    RETURN CONCAT('✅ Venta registrada con ID: ', v_id_venta);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_insertar_cliente` (`p_nombres` VARCHAR(50), `p_apellidos` VARCHAR(50), `p_direccion` VARCHAR(100), `p_telefono` VARCHAR(15)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_nombres IS NULL OR TRIM(p_nombres) = ''
        OR p_apellidos IS NULL OR TRIM(p_apellidos) = ''
        OR p_direccion IS NULL OR TRIM(p_direccion) = ''
        OR p_telefono IS NULL OR TRIM(p_telefono) = '' THEN
        SET msg = '❌ Todos los campos son obligatorios.';
    ELSE
        INSERT INTO clientes(nombres, apellidos, direccion, telefono)
        VALUES (p_nombres, p_apellidos, p_direccion, p_telefono);

        SET msg = '✅ Cliente registrado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_insertar_detalle_venta` (`p_id_venta` INT, `p_id_producto` INT, `p_cantidad` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_id_venta IS NULL OR p_id_venta <= 0
        OR p_id_producto IS NULL OR p_id_producto <= 0
        OR p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SET msg = '❌ Datos del detalle inválidos.';

    ELSE
        INSERT INTO detalle_venta(id_venta, id_producto, cantidad)
        VALUES (p_id_venta, p_id_producto, p_cantidad);
        SET msg = '✅ Detalle registrado.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_insertar_usuario` (`p_usuario` VARCHAR(50), `p_clave` VARCHAR(100), `p_rol` VARCHAR(20)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_usuario IS NULL OR CHAR_LENGTH(TRIM(p_usuario)) < 3
        OR p_clave IS NULL OR CHAR_LENGTH(TRIM(p_clave)) < 6
        OR p_rol IS NULL OR (p_rol NOT IN ('admin', 'vendedor')) THEN
        SET msg = '❌ Datos de usuario inválidos.';

    ELSE
        INSERT INTO usuarios(usuario, clave, rol)
        VALUES(p_usuario, p_clave, p_rol);
        SET msg = '✅ Usuario registrado correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_insertar_venta` (`p_id_cliente` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE msg VARCHAR(100);

    IF p_id_cliente IS NULL OR p_id_cliente <= 0 THEN
        SET msg = '❌ Cliente inválido.';
    ELSE
        INSERT INTO ventas(id_cliente, fecha_hora, estado)
        VALUES (p_id_cliente, NOW(), 'registrado');
        SET msg = '✅ Venta registrada correctamente.';
    END IF;

    RETURN msg;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_sp_eliminar_cliente` (`p_id` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        RETURN '❌ ID inválido';
    END IF;
    CALL sp_eliminar_cliente(p_id);
    RETURN '✅ Cliente eliminado';
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_sp_insertar_usuario` (`p_usuario` VARCHAR(50), `p_contra` VARCHAR(50), `p_correo` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    IF p_usuario IS NULL OR CHAR_LENGTH(p_usuario) = 0 OR CHAR_LENGTH(p_contra) < 6 THEN
        RETURN '❌ Datos inválidos';
    END IF;
    CALL sp_insertar_usuario(p_usuario, p_contra, p_correo);
    RETURN '✅ Usuario insertado';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `descripcion`) VALUES
(2, 'menestras'),
(3, 'lacteos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombres`, `apellidos`, `direccion`, `telefono`) VALUES
(8, 'luis', 'utos ceras', 'av. san carlos 2275', '96565656'),
(18, 'erick', 'limache', 'santa rosa', '901710216');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `precio` decimal(18,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `precio`, `stock`, `id_categoria`, `id_proveedor`) VALUES
(3, 'leche gloria', 23.80, 50, 2, 6),
(15, 'Alicate', 14.00, 7, 3, 6),
(17, 'garbanzon', 2.00, 1, 2, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `razonsocial` varchar(50) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `razonsocial`, `direccion`, `telefono`) VALUES
(6, 'alicorp', 'av. los nogales 890', '343545345'),
(10, 'juan', 'av.lossanos', '984567123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `contrasena` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `nombre_usuario`, `contrasena`) VALUES
(1, 'admin', '123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `id_cliente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `fecha`, `id_cliente`) VALUES
(2, '0000-00-00 00:00:00', 8),
(3, '0000-00-00 00:00:00', 8),
(4, '0000-00-00 00:00:00', 8),
(5, '0000-00-00 00:00:00', 8),
(6, '0000-00-00 00:00:00', 8),
(7, '0000-00-00 00:00:00', 8),
(8, '0000-00-00 00:00:00', 8),
(19, '2025-06-12 16:34:01', 8),
(20, '2025-06-12 16:35:25', 8),
(21, '2025-06-12 16:45:50', 8),
(22, '2025-06-12 17:05:43', 8),
(23, '2025-06-12 17:14:39', 8),
(24, '2025-06-12 17:22:32', 18),
(25, '2025-06-12 17:22:42', 18),
(27, '2025-06-12 17:23:40', 8),
(28, '2025-06-12 17:27:07', 8),
(29, '2025-06-12 17:29:36', 8),
(30, '2025-06-12 17:31:04', 8),
(32, '2025-06-12 17:34:09', 18),
(35, '2025-06-12 17:36:14', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_detalle`
--

CREATE TABLE `ventas_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_venta` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas_detalle`
--

INSERT INTO `ventas_detalle` (`id_detalle`, `id_venta`, `id_producto`, `cantidad`) VALUES
(1, 2, 3, 1),
(2, 3, 3, 7),
(3, 3, 15, 10),
(4, 4, 3, 1),
(5, 4, 15, 2),
(6, 5, 3, 1),
(7, 5, 15, 2),
(8, 6, 15, 1),
(9, 6, 3, 20),
(10, 7, 3, 1),
(11, 8, 3, 8),
(12, 9, 3, 7),
(13, 10, 3, 8),
(14, 10, 15, 1),
(15, 11, 3, 1),
(16, 12, 3, 1),
(17, 13, 3, 7),
(18, 14, 3, 1),
(19, 15, 17, 2),
(20, 16, 15, 1),
(21, 17, 3, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `ventas_detalle`
--
ALTER TABLE `ventas_detalle`
  ADD PRIMARY KEY (`id_detalle`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `ventas_detalle`
--
ALTER TABLE `ventas_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
