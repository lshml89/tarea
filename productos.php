<?php
session_start();

if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

// Llamar al procedimiento almacenado
$query = "CALL sp_listar_productos()";
$resultado_productos = $conexion->query($query);

if (!$resultado_productos) {
    die("<div class='panel-container'><p>Error al obtener productos: " . $conexion->error . "</p></div>");
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Productos</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f8;
            margin: 0; padding: 0;
            display: flex; justify-content: center; align-items: center;
            height: 100vh;
        }
        .panel-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 900px;
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
        .mensaje {
            color: #888;
            margin: 20px 0;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="panel-container">
        <h1>Lista de Productos</h1>

        <a href="crear_producto.php" class="button add-button">Agregar Producto</a>

        <?php if ($resultado_productos->num_rows > 0): ?>
            <table>
                <thead>
                    <tr>
                        <th>ID Producto</th>
                        <th>Descripción</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Categoría</th>
                        <th>Proveedor</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <?php while ($producto = $resultado_productos->fetch_assoc()): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($producto['id_producto']); ?></td>
                            <td><?php echo htmlspecialchars($producto['nombre']); ?></td>
                            <td><?php echo htmlspecialchars(number_format($producto['precio'], 2)); ?></td>
                            <td><?php echo htmlspecialchars($producto['stock']); ?></td>
                            <td><?php echo htmlspecialchars($producto['categoria']); ?></td>
                            <td><?php echo htmlspecialchars($producto['proveedor']); ?></td>
                            <td>
                                <a href="editar_producto.php?id=<?php echo urlencode($producto['id_producto']); ?>" class="button">Editar</a>
                                <a href="eliminar_producto.php?id=<?php echo urlencode($producto['id_producto']); ?>" class="button" style="background-color: #dc3545;">Eliminar</a>
                            </td>
                        </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        <?php else: ?>
            <p class="mensaje">No hay productos registrados aún.</p>
        <?php endif; ?>

        <a href="index.php" class="back-button">Volver al Panel Principal</a>
    </div>
</body>
</html>

<?php
$resultado_productos->free();
$conexion->next_result();
?>
