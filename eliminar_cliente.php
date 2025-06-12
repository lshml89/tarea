
<?php
session_start();

if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$id_cliente = $_GET['id'];

$query = "CALL sp_eliminar_cliente(?)";
$stmt = $conexion->prepare($query);
$stmt->bind_param("i", $id_cliente);
$stmt->execute();


header("Location: clientes.php");
exit();
?>


<?php if (isset($_GET['success'])): ?>
    <div class="alerta success">Cliente eliminado correctamente.</div>
<?php endif; ?>