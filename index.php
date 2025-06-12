<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .panel-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 100%;
            max-width: 600px;
        }

        h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 30px;
        }

        .button {
            display: inline-block;
            background-color: #007bff;
            color: white;
            padding: 12px 25px;
            margin: 10px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .button:hover {
            background-color: #0056b3;
        }

        .logout-button {
            background-color: #dc3545;
        }

        .logout-button:hover {
            background-color: #c82333;
        }

        .forgot-password {
            display: block;
            margin-top: 10px;
            color: #007bff;
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="panel-container">
        <h1>Bienvenido al Panel de Administración</h1>
        
        <a href="proveedores.php" class="button">Ver Proveedores</a>
        <a href="clientes.php" class="button">Ver Clientes</a>
        <a href="facturas.php" class="button">Generar Factura</a>
        <a href="productos.php" class="button">Gestionar Productos</a>
        <a href="vender.php" class="button">Vender Producto</a> <!-- Nuevo botón para vender productos -->
        <a href="logout.php" class="button logout-button">Cerrar Sesión</a>
    </div>

</body>
</html>
