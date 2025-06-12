<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$mensaje = "";
$id_cliente = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id_cliente <= 0) {
    echo "<div class='alerta error'>ID de cliente inválido.</div>";
    exit;
}

// Cargar datos del cliente
$stmt = $conexion->prepare("CALL sp_buscar_cliente_por_id(?)");
$stmt->bind_param("i", $id_cliente);
$stmt->execute();
$resultado = $stmt->get_result();
$cliente = $resultado->fetch_assoc();
$stmt->close();
while ($conexion->more_results() && $conexion->next_result()) {}

// Procesar actualización (POST)
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombres   = $_POST['nombres'];
    $apellidos = $_POST['apellidos'];
    $direccion = $_POST['direccion'];
    $telefono  = $_POST['telefono'];

    // Ejecutar la función que valida y actualiza
    $stmt = $conexion->prepare("SELECT fn_actualizar_cliente(?, ?, ?, ?, ?) AS mensaje");
    $stmt->bind_param("issss", $id_cliente, $nombres, $apellidos, $direccion, $telefono);
    $stmt->execute();
    $stmt->bind_result($mensaje);
    $stmt->fetch();
    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Editar Cliente</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .panel-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 800px;
            text-align: center;
        }
        h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        input[type="text"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .alerta {
            margin-bottom: 15px;
            padding: 12px;
            border-radius: 5px;
            font-weight: bold;
            border: 1px solid;
        }
        .alerta.success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
        .alerta.error {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }
    </style>
</head>
<body>
<div class="panel-container">
    <h1>Editar Cliente</h1>

    <?php if ($mensaje): ?>
        <div class="alerta <?php echo str_starts_with($mensaje, '✅') ? 'success' : 'error'; ?>">
            <?php echo htmlspecialchars($mensaje); ?>
        </div>
    <?php endif; ?>

    <form method="POST">
        <input type="text" name="nombres" placeholder="Nombres" value="<?php echo htmlspecialchars($cliente['nombres']); ?>">
        <input type="text" name="apellidos" placeholder="Apellidos" value="<?php echo htmlspecialchars($cliente['apellidos']); ?>">
        <input type="text" name="direccion" placeholder="Dirección" value="<?php echo htmlspecialchars($cliente['direccion']); ?>">
        <input type="text" name="telefono" placeholder="Teléfono" value="<?php echo htmlspecialchars($cliente['telefono']); ?>">
        <button type="submit">Actualizar Cliente</button>
    </form>

    <a href="clientes.php" style="display:inline-block; margin-top:15px; text-decoration:none; color:#007bff;">← Volver a Clientes</a>
</div>
</body>
</html>
