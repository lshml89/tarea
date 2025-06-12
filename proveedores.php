<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$proveedores = [];
if ($conexion->multi_query("CALL listar_proveedores()")) {
    if ($resultado = $conexion->store_result()) {
        while ($fila = $resultado->fetch_assoc()) {
            $proveedores[] = $fila;
        }
        $resultado->free();
    }
    while ($conexion->more_results() && $conexion->next_result()) {}
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proveedores</title>
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            margin: 10px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
        }

        .button:hover {
            background-color: #0056b3;
        }

        .add-button {
            background-color: #28a745;
        }

        .add-button:hover {
            background-color: #218838;
        }

        .back-button {
            background-color: #28a745;
            color: white;
            border-radius: 5px;
            padding: 12px;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
            width: 100%;
            font-size: 16px;
            cursor: pointer;
            text-align: center;
        }

        .back-button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

    <div class="panel-container">
        <h1>Lista de Proveedores</h1>

        <a href="crear_proveedor.php" class="button add-button">Agregar Proveedor</a>

        <table>
            <tr>
                <th>ID</th>
                <th>Razón Social</th>
                <th>Dirección</th>
                <th>Teléfono</th>
                <th>Acciones</th>
            </tr>
            <?php foreach ($proveedores as $proveedor): ?>
                <tr>
                    <td><?php echo $proveedor['id_proveedor']; ?></td>
                    <td><?php echo $proveedor['razonsocial']; ?></td>
                    <td><?php echo $proveedor['direccion']; ?></td>
                    <td><?php echo $proveedor['telefono']; ?></td>
                    <td>
                        <a href="editar_proveedor.php?id=<?php echo $proveedor['id_proveedor']; ?>" class="button">Editar</a>
                        <a href="eliminar_proveedor.php?id=<?php echo $proveedor['id_proveedor']; ?>" class="button" style="background-color: #dc3545;">Eliminar</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        </table>

        <a href="index.php" class="back-button">Volver al Panel Principal</a>
    </div>

</body>
</html>
