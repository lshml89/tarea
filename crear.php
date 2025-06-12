<?php
include 'conexion.php';

$nombres = $_POST['nombres'];
$apellidos = $_POST['apellidos'];
$direccion = $_POST['direccion'];
$telefono = $_POST['telefono'];

$stmt = $pdo->prepare("CALL sp_insertar_cliente(?, ?, ?, ?)");
$stmt->execute([$nombres, $apellidos, $direccion, $telefono]);

echo "Cliente creado correctamente.";
?>