<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$id_proveedor = $_GET['id'] ?? null;
$mensaje = "";

// Obtener datos del proveedor
$proveedor = [];
if ($id_proveedor) {
    $stmt = $conexion->prepare("CALL obtener_proveedor_por_id(?)");
    $stmt->bind_param("i", $id_proveedor);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($resultado->num_rows > 0) {
        $proveedor = $resultado->fetch_assoc();
    } else {
        $mensaje = "❌ Proveedor no encontrado.";
    }
    $stmt->close();
    $conexion->next_result();
} else {
    $mensaje = "❌ ID de proveedor inválido.";
}

// Procesar envío del formulario
if ($_SERVER["REQUEST_METHOD"] == "POST" && $id_proveedor) {
    $razonsocial = $_POST['razonsocial'];
    $direccion = $_POST['direccion'];
    $telefono = $_POST['telefono'];

    $stmt = $conexion->prepare("SELECT fn_actualizar_proveedor(?, ?, ?, ?)");
    $stmt->bind_param("isss", $id_proveedor, $razonsocial, $direccion, $telefono);
    $stmt->execute();
    $stmt->bind_result($respuesta);
    $stmt->fetch();
    $mensaje = $respuesta;
    $stmt->close();
    $conexion->next_result();

    // Actualizar los datos en el array para que aparezcan actualizados en el formulario
    $proveedor['razonsocial'] = $razonsocial;
    $proveedor['direccion'] = $direccion;
    $proveedor['telefono'] = $telefono;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Editar Proveedor</title>
    <link rel="stylesheet" href="style.css" />
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

        input[type="text"], input[type="number"] {
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

        .alerta.error {
            background-color: #f8d7da;
            color: #721c24;
        }

        .alerta.success {
            background-color: #d4edda;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="panel-container">
        <h1>Editar Proveedor</h1>

        <?php if (!empty($mensaje)): ?>
            <div class="alerta <?php echo str_starts_with($mensaje, '✅') ? 'success' : 'error'; ?>">
                <?php echo htmlspecialchars($mensaje); ?>
            </div>
        <?php endif; ?>

        <?php if (!empty($proveedor)): ?>
        <form method="POST">
            <label for="razonsocial">Razón Social:</label><br />
            <input type="text" id="razonsocial" name="razonsocial" value="<?php echo htmlspecialchars($proveedor['razonsocial']); ?>" /><br /><br />

            <label for="direccion">Dirección:</label><br />
            <input type="text" id="direccion" name="direccion" value="<?php echo htmlspecialchars($proveedor['direccion']); ?>" /><br /><br />

            <label for="telefono">Teléfono:</label><br />
            <input type="text" id="telefono" name="telefono" value="<?php echo htmlspecialchars($proveedor['telefono']); ?>" /><br /><br />

            <button type="submit">Actualizar Proveedor</button>
        </form>
        <?php endif; ?>
    </div>
</body>
</html>
