<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$mensaje = "";

// Cargar categorías
$categorias = [];
$res = $conexion->query("CALL listar_categorias()");
if ($res) {
    while ($row = $res->fetch_assoc()) $categorias[] = $row;
    $res->free(); while ($conexion->more_results() && $conexion->next_result()) {}
}

// Cargar proveedores
$proveedores = [];
$res = $conexion->query("CALL listar_proveedores()");
if ($res) {
    while ($row = $res->fetch_assoc()) $proveedores[] = $row;
    $res->free(); while ($conexion->more_results() && $conexion->next_result()) {}
}

// Enviar datos a la función MySQL
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombre       = $_POST['nombre'];
    $descripcion  = $nombre; // Usamos el mismo nombre como descripción
    $precio       = $_POST['precio'];
    $stock        = $_POST['stock'];
    $id_categoria = $_POST['id_categoria'];
    $id_proveedor = $_POST['id_proveedor'];

    $stmt = $conexion->prepare("SELECT fn_crear_producto(?, ?, ?, ?, ?, ?) AS resultado");
    $stmt->bind_param("ssdiii", $nombre, $descripcion, $precio, $stock, $id_categoria, $id_proveedor);
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
    <title>Crear Producto</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: #f4f6f8;
            margin: 0; padding: 0;
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh;
        }
        .panel-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 100%; max-width: 800px;
            text-align: center;
        }
        h1 { margin-bottom: 20px; color: #333; }
        label { text-align: left; display: block; font-weight: bold; color: #555; margin-bottom: 5px; }
        input, select {
            width: 100%; padding: 12px; margin-bottom: 15px;
            border-radius: 5px; border: 1px solid #ccc; font-size: 16px;
        }
        button {
            width: 100%; padding: 12px;
            background-color: #007bff; color: white;
            border: none; border-radius: 5px;
            font-size: 16px; cursor: pointer;
        }
        button:hover { background-color: #0056b3; }
        .secondary-button {
            display: inline-block; margin-top: 15px;
            padding: 12px; background-color: #6c757d;
            color: white; text-decoration: none; border-radius: 5px;
        }
        .secondary-button:hover { background-color: #5a6268; }
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
    <h1>Crear Nuevo Producto</h1>

    <?php if ($mensaje): ?>
        <div class="alerta <?php echo str_starts_with($mensaje, '✅') ? 'success' : 'error'; ?>">
            <?php echo htmlspecialchars($mensaje); ?>
        </div>
    <?php endif; ?>

    <form method="POST">
        <label for="nombre">Nombre del producto:</label>
        <input type="text" name="nombre" id="nombre">

        <label for="precio">Precio:</label>
        <input type="text" name="precio" id="precio">

        <label for="stock">Stock:</label>
        <input type="text" name="stock" id="stock">

        <label for="id_categoria">Categoría:</label>
        <select name="id_categoria" id="id_categoria">
            <option value="">Selecciona</option>
            <?php foreach ($categorias as $cat): ?>
                <option value="<?php echo $cat['id_categoria']; ?>">
                    <?php echo htmlspecialchars($cat['nombre']); ?>
                </option>
            <?php endforeach; ?>
        </select>

        <label for="id_proveedor">Proveedor:</label>
        <select name="id_proveedor" id="id_proveedor">
            <option value="">Selecciona</option>
            <?php foreach ($proveedores as $prov): ?>
                <option value="<?php echo $prov['id_proveedor']; ?>">
                    <?php echo htmlspecialchars($prov['razonsocial']); ?>
                </option>
            <?php endforeach; ?>
        </select>

        <button type="submit">Crear Producto</button>
    </form>

    <a href="productos.php" class="secondary-button">← Volver al Panel de Productos</a>
</div>
</body>
</html>
