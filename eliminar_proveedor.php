<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$id_proveedor = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id_proveedor > 0) {
    $stmt = $conexion->prepare("SELECT fn_eliminar_proveedor(?)");
    $stmt->bind_param("i", $id_proveedor);
    $stmt->execute();
    $stmt->bind_result($mensaje);
    $stmt->fetch();
    $stmt->close();
    $conexion->close();

    // Redireccionar con el mensaje como parámetro GET
    header("Location: proveedores.php?msg=" . urlencode($mensaje));
    exit;
} else {
    // Redireccionar con error si el ID no es válido
    header("Location: proveedores.php?msg=" . urlencode("❌ ID de proveedor inválido"));
    exit;
}
?>
