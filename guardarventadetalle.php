<?php
session_start();
include 'conexion.php';

// Obtener datos del formulario
$id_cliente = $_POST['id_cliente'];
$json_productos = $_POST['productos']; // JSON string

$mensaje = "❌ Error desconocido.";
$stmt = null;

if ($conexion) {
    $stmt = $conexion->prepare("SELECT fn_guardar_venta(?, ?) AS mensaje");
    if ($stmt) {
        $stmt->bind_param("is", $id_cliente, $json_productos);
        if ($stmt->execute()) {
            $stmt->bind_result($mensaje);
            if (!$stmt->fetch()) {
                $mensaje = "❌ No se recibió ningún mensaje desde la base de datos.";
            }
        } else {
            $mensaje = "❌ Error al ejecutar la consulta: " . $stmt->error;
        }
    } else {
        $mensaje = "❌ Error al preparar la consulta: " . $conexion->error;
    }
}

if ($stmt) {
    $stmt->close(); // Solo se cierra si fue creado correctamente
}
$conexion->close();

echo $mensaje;
?>
