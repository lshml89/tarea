-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 31-05-2025 a las 06:56:51
-- Versión del servidor: 10.4.20-MariaDB
-- Versión de PHP: 8.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_proveedor` (IN `p_id_proveedor` INT, IN `p_razonsocial` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))  BEGIN
    UPDATE proveedores
    SET razonsocial = p_razonsocial,
        direccion = p_direccion,
        telefono = p_telefono
    WHERE id_proveedor = p_id_proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_proveedor` (IN `p_razonsocial` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))  BEGIN
    INSERT INTO proveedores (razonsocial, direccion, telefono)
    VALUES (p_razonsocial, p_direccion, p_telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_proveedor` (IN `p_id_proveedor` INT)  BEGIN
    DELETE FROM proveedores
    WHERE id_proveedor = p_id_proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_detalle_venta` (IN `p_id_venta` INT, IN `p_id_producto` INT, IN `p_cantidad` INT)  BEGIN
    INSERT INTO ventas_detalle (id_venta, id_producto, cantidad)
    VALUES (p_id_venta, p_id_producto, p_cantidad);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_venta` (IN `p_id_cliente` INT, OUT `p_id_venta` INT)  BEGIN
    INSERT INTO ventas (id_cliente) VALUES (p_id_cliente);
    SET p_id_venta = LAST_INSERT_ID();  -- Obtener el ID generado
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_categorias` ()  BEGIN
    SELECT * FROM categorias;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_proveedores` ()  BEGIN
    SELECT * FROM proveedores;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_cabecera_venta` (IN `p_id_venta` INT)  BEGIN
    SELECT 
        v.id_venta, 
        v.fecha, 
        c.nombres AS nombre_cliente
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE v.id_venta = p_id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_clientes` ()  BEGIN
    SELECT id_cliente, nombres, apellidos FROM clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_cliente_id` (`p_id_cliente` INT)  BEGIN
 
 SELECT nombres, apellidos FROM clientes WHERE id_cliente =p_id_cliente;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_detalle_venta` (IN `p_id_venta` INT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_producto` ()  BEGIN
 SELECT id_producto, nombre, precio, stock FROM productos;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_producto_id` (`p_id_producto` INT)  BEGIN
   SELECT nombre, precio, stock FROM productos WHERE id_producto =p_id_producto;
 
 
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_proveedor_por_id` (IN `p_id` INT)  BEGIN
    SELECT * FROM proveedores WHERE id_proveedor = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_ultima_venta` (OUT `p_id_venta` INT)  BEGIN
    SELECT MAX(id_venta) INTO p_id_venta FROM ventas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_cliente` (IN `p_id_cliente` INT, IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))  BEGIN
  UPDATE clientes
  SET nombres = p_nombres,
      apellidos = p_apellidos,
      direccion = p_direccion,
      telefono = p_telefono
  WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_estado_venta` (IN `id_venta` INT, IN `nuevo_estado` VARCHAR(20))  BEGIN
    -- Actualizar el estado de la venta
    UPDATE ventas
    SET estado = nuevo_estado
    WHERE id_venta = id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_producto` (IN `p_id_producto` INT, IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(18,2), IN `p_stock` INT, IN `p_id_categoria` INT, IN `p_id_proveedor` INT)  BEGIN
  UPDATE productos
  SET nombre= p_descripcion,
      precio = p_precio,
      stock = p_stock,
      id_categoria = p_id_categoria,
      id_proveedor = p_id_proveedor
  WHERE id_producto = p_id_producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_cliente_por_id` (IN `p_id_cliente` INT)  BEGIN
    SELECT * FROM clientes WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_producto` (IN `p_descripcion` VARCHAR(50), IN `p_precio` DECIMAL(18,2), IN `p_stock` INT, IN `p_id_categoria` INT, IN `p_id_proveedor` INT)  BEGIN
  INSERT INTO productos (nombre, precio, stock, id_categoria, id_proveedor)
  VALUES (p_descripcion, p_precio, p_stock, p_id_categoria, p_id_proveedor);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_cliente` (IN `p_id_cliente` INT)  BEGIN
  DELETE FROM clientes
  WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_producto` (IN `p_id_producto` INT)  BEGIN
  DELETE FROM productos
  WHERE id_producto = p_id_producto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_guardar_venta` (IN `p_id_cliente` INT, IN `p_productos` JSON)  BEGIN
    DECLARE v_id_venta INT DEFAULT 0;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_nombre VARCHAR(255);
    DECLARE v_precio DECIMAL(10,2);
    DECLARE i INT DEFAULT 0;
    DECLARE n INT;
    -- Insertar la venta
    INSERT INTO ventas(fecha, id_cliente) VALUES (NOW(), p_id_cliente);
    SET v_id_venta = LAST_INSERT_ID();
    SET n = JSON_LENGTH(p_productos);
    -- Recorrer los productos JSON
    WHILE i < n DO
        SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', i, '].id_producto')));
        SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', i, '].cantidad')));
        -- Obtener el nombre y precio del producto actual
        SELECT nombre, precio INTO v_nombre, v_precio FROM productos WHERE id_producto = v_producto_id;
        -- Insertar detalle
        INSERT INTO ventas_detalle(id_venta, id_producto, nombre_producto, cantidad, precio)
        VALUES (v_id_venta, v_producto_id, v_nombre, v_cantidad, v_precio);
        -- Actualizar stock restando la cantidad vendida
        UPDATE productos SET stock = stock - v_cantidad WHERE id_producto = v_producto_id;
        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50), IN `p_direccion` VARCHAR(50), IN `p_telefono` VARCHAR(50))  BEGIN
  INSERT INTO clientes (nombres, apellidos, direccion, telefono)
  VALUES (p_nombres, p_apellidos, p_direccion, p_telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_detalle_venta` (IN `id_venta` INT, IN `id_producto` INT, IN `cantidad` INT, IN `precio` DECIMAL(10,2))  BEGIN
    -- Insertar detalle de la venta
    INSERT INTO ventas_detalle (id_venta, id_producto, cantidad, precio)
    VALUES (id_venta, id_producto, cantidad, precio);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_usuario` (IN `p_nombre_usuario` VARCHAR(50), IN `p_contrasena` VARCHAR(100), IN `p_correo` VARCHAR(100))  BEGIN
  INSERT INTO usuarios (nombre_usuario, contrasena, correo)
  VALUES (p_nombre_usuario, p_contrasena, p_correo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_venta` (IN `id_cliente` INT, IN `id_usuario` INT, IN `total` DECIMAL(10,2), IN `fecha_compra` DATE)  BEGIN
    DECLARE id_venta INT;
    -- Insertar la venta
    INSERT INTO ventas (id_cliente, id_usuario, total, fechaCompra, estado)
    VALUES (id_cliente, id_usuario, total, fecha_compra, 'pendiente');
    -- Obtener el ID de la venta recién insertada
    SET id_venta = LAST_INSERT_ID();
    -- Devolver el ID de la venta insertada
    SELECT id_venta AS id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_categorias` ()  BEGIN
  SELECT id_categoria, nombre FROM categorias;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_cliente` ()  BEGIN
    SELECT id_cliente, nombres, apellidos FROM clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_clientes` ()  BEGIN
  SELECT * FROM clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_productos` ()  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_proveedores` ()  BEGIN
  SELECT id_proveedor, razonsocial FROM proveedores;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_id_cliente` (IN `p_nombres` VARCHAR(50), IN `p_apellidos` VARCHAR(50))  BEGIN
  SELECT id_cliente
  FROM clientes
  WHERE nombres = p_nombres AND apellidos = p_apellidos
  LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_productos_por_venta` (IN `id_venta` INT)  BEGIN
    -- Obtener todos los productos vendidos en una venta
    SELECT v.id_producto, p.nombre, vd.cantidad, vd.precio
    FROM ventas_detalle vd
    JOIN productos p ON vd.id_producto = p.id_producto
    WHERE vd.id_venta = id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_usuario_por_id` (IN `p_id_usuario` INT)  BEGIN
  SELECT * FROM usuarios WHERE id_usuario = p_id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_usuario` (IN `p_nombre_usuario` VARCHAR(50), IN `p_correo` VARCHAR(100))  BEGIN
  SELECT * FROM usuarios 
  WHERE nombre_usuario = p_nombre_usuario AND correo = p_correo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verificar_stock` (IN `id_producto` INT, IN `cantidad` INT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `verificar_login` (IN `p_usuario` VARCHAR(50), IN `p_contrasena` VARCHAR(255))  BEGIN
    SELECT * FROM usuarios 
    WHERE nombre_usuario = p_usuario AND contrasena = p_contrasena;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `descripcion` varchar(100) COLLATE utf8_bin DEFAULT NULL
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
  `nombres` varchar(50) COLLATE utf8_bin NOT NULL,
  `apellidos` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `direccion` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombres`, `apellidos`, `direccion`, `telefono`) VALUES
(8, 'luis', 'utos ceras', 'av. san carlos 2275', '96565656');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_bin NOT NULL,
  `precio` decimal(18,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `precio`, `stock`, `id_categoria`, `id_proveedor`) VALUES
(3, 'leche gloria', '23.80', 50, 2, 6),
(15, 'Alicate', '14.00', 7, 3, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `razonsocial` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `direccion` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `razonsocial`, `direccion`, `telefono`) VALUES
(6, 'alicorp', 'av. los nogales 890', '343545345');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `contrasena` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(9, '0000-00-00 00:00:00', 8),
(10, '0000-00-00 00:00:00', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_detalle`
--

CREATE TABLE `ventas_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_venta` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(14, 10, 15, 1);

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
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `ventas_detalle`
--
ALTER TABLE `ventas_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
