<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

// Validar ID de producto
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    echo "<div class='alerta error'>ID de producto no válido.</div>";
    exit();
}

$id_producto = (int) $_GET['id'];

// Obtener datos del producto
$stmt = $conexion->prepare("SELECT * FROM productos WHERE id_producto = ?");
$stmt->bind_param("i", $id_producto);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo "<div class='alerta error'>Producto no encontrado.</div>";
    exit();
}
$producto = $result->fetch_assoc();
$stmt->close();

// Obtener categorías
$categorias = [];
if ($conexion->multi_query("CALL listar_categorias()")) {
    $res = $conexion->store_result();
    while ($row = $res->fetch_assoc()) {
        $categorias[] = $row;
    }
    $res->free();
    while ($conexion->more_results() && $conexion->next_result()) {}
}

// Obtener proveedores
$proveedores = [];
if ($conexion->multi_query("CALL listar_proveedores()")) {
    $res = $conexion->store_result();
    while ($row = $res->fetch_assoc()) {
        $proveedores[] = $row;
    }
    $res->free();
    while ($conexion->more_results() && $conexion->next_result()) {}
}

$mensaje = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Datos del formulario
    $nombre = $_POST['nombre'];
    $precio = $_POST['precio'];
    $stock = $_POST['stock'];
    $id_categoria = (int) $_POST['id_categoria'];
    $id_proveedor = (int) $_POST['id_proveedor'];

    // Llamar a la función con validación
    $stmt = $conexion->prepare("SELECT fn_actualizar_producto(?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("isdiii", $id_producto, $nombre, $precio, $stock, $id_categoria, $id_proveedor);
    $stmt->execute();
    $stmt->bind_result($mensaje);
    $stmt->fetch();
    $stmt->close();

    // Mostrar mensaje si es error o redirigir si es éxito
    if (str_starts_with($mensaje, '✅')) {
        header("Location: productos.php?msg=" . urlencode($mensaje));
        exit();
    }
}
?>
