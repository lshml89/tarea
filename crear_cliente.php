<?php
session_start();

if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$mensaje = "";

// Enviar datos al procedimiento o función de la base de datos
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombres   = $_POST['nombres'];
    $apellidos = $_POST['apellidos'];
    $direccion = $_POST['direccion'];
    $telefono  = $_POST['telefono'];

    // Llamar a la función que valida e inserta
    $stmt = $conexion->prepare("SELECT fn_insertar_cliente(?, ?, ?, ?) AS resultado");
    $stmt->bind_param("ssss", $nombres, $apellidos, $direccion, $telefono);
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
    <title>Crear Cliente</title>
    <link rel="stylesheet" href="style.css">
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
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #0056b3;
        }

        .alerta {
            padding: 12px;
            margin-bottom: 15px;
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

        .secondary-button {
            background-color: #6c757d;
            color: white;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            display: inline-block;
            text-decoration: none;
        }

        .secondary-button:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<div class="panel-container">
    <h1>Crear Nuevo Cliente</h1>

    <?php if (!empty($mensaje)): ?>
        <div class="alerta <?php echo str_starts_with($mensaje, '✅') ? 'success' : 'error'; ?>">
            <?php echo htmlspecialchars($mensaje); ?>
        </div>
    <?php endif; ?>

    <form method="POST">
        <label for="nombres">Nombres:</label>
        <input type="text" id="nombres" name="nombres">

        <label for="apellidos">Apellidos:</label>
        <input type="text" id="apellidos" name="apellidos">

        <label for="direccion">Dirección:</label>
        <input type="text" id="direccion" name="direccion">

        <label for="telefono">Teléfono:</label>
        <input type="text" id="telefono" name="telefono">

        <button type="submit">Crear Cliente</button>
    </form>

    <a href="clientes.php" class="secondary-button">Volver al Panel de Clientes</a>
</div>

</body>
</html>
