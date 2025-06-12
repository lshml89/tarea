<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$mensaje = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $razonsocial = $_POST['razonsocial'];
    $direccion = $_POST['direccion'];
    $telefono = $_POST['telefono'];

    $stmt = $conexion->prepare("SELECT fn_crear_proveedor(?, ?, ?)");
    $stmt->bind_param("sss", $razonsocial, $direccion, $telefono);
    $stmt->execute();
    $stmt->bind_result($respuesta);
    $stmt->fetch();
    $mensaje = $respuesta;
    $stmt->close();
    $conexion->close();
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Proveedor</title>
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
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .alerta.success {
            background-color: #d4edda;
            color: #155724;
        }

        .alerta.error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>

<div class="panel-container">
    <h1>Crear Nuevo Proveedor</h1>

    <?php if (!empty($mensaje)): ?>
        <div class="alerta <?php echo str_starts_with($mensaje, '✅') ? 'success' : 'error'; ?>">
            <?php echo htmlspecialchars($mensaje); ?>
        </div>
    <?php endif; ?>

    <form method="POST" action="crear_proveedor.php">
        <label for="razonsocial">Razón Social:</label><br>
        <input type="text" id="razonsocial" name="razonsocial"><br><br>

        <label for="direccion">Dirección:</label><br>
        <input type="text" id="direccion" name="direccion"><br><br>

        <label for="telefono">Teléfono:</label><br>
        <input type="text" id="telefono" name="telefono"><br><br>

        <button type="submit">Crear Proveedor</button>
    </form>
</div>

</body>
</html>
