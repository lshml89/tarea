<?php
include 'conexion.php';

$id = $_GET['id'];
$stmt = $pdo->prepare("SELECT * FROM clientes WHERE id_cliente = ?");
$stmt->execute([$id]);

$cliente = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode($cliente);
?>