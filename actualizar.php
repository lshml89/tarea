<?php
include 'conexion.php';

$id = $_POST['id_cliente'];
$nombres = $_POST['nombres'];
$apellidos = $_POST['apellidos'];
$direccion = $_POST['direccion'];
$telefono = $_POST['telefono'];

$stmt = $pdo->prepare("CALL sp_actualizar_cliente(?, ?, ?, ?, ?)");
$stmt->execute([$id, $nombres, $apellidos, $direccion, $telefono]);

echo "Cliente actualizado correctamente.";
?>