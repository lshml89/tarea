<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

if (isset($_GET['id'])) {
    $id_producto = (int) $_GET['id'];

    // Llamar a la función con validación
    $stmt = $conexion->prepare("SELECT fn_eliminar_producto(?)");
    $stmt->bind_param("i", $id_producto);
    $stmt->execute();
    $stmt->bind_result($mensaje);
    $stmt->fetch();
    $stmt->close();

    // Redirigir con mensaje como parámetro GET (opcional)
    header("Location: productos.php?msg=" . urlencode($mensaje));
    exit();
}
?>
