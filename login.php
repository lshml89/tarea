<?php
session_start();
include 'conexion.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $usuario = $_POST['usuario'];
    $contrasena = $_POST['contrasena'];

   
    $stmt = $conexion->prepare("CALL verificar_login(?, ?)");
    if (!$stmt) {
        die("Error en la preparación del procedimiento: " . $conexion->error);
    }

    $stmt->bind_param("ss", $usuario, $contrasena);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($resultado && $resultado->num_rows > 0) {
        $usuario = $resultado->fetch_assoc();
        $_SESSION['usuario'] = $usuario;
        header("Location: index.php");
    } else {
        header("Location: login.php?error=true");
    }

    $stmt->close();
    $conexion->close();
}
?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        input[type="text"], input[type="password"] {
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
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            display: none;
        }

        .alerta.success {
            background-color: #d4edda;
            color: #155724;
        }

        .alerta.error {
            background-color: #f8d7da;
            color: #721c24;
        }

        .forgot-password {
            display: block;
            text-align: center;
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

    <div class="login-container">
        <h1>Iniciar sesión</h1>
        <div class="alerta" id="alerta"></div>

        <form method="POST" action="login.php">
            <input type="text" id="usuario" name="usuario" placeholder="Usuario" required>
            <input type="password" id="contrasena" name="contrasena" placeholder="Contraseña" required>
            <button type="submit">Iniciar sesión</button>
        </form>

        <a href="#" class="forgot-password">¿Olvidaste tu contraseña?</a>
    </div>

    <script>
        // Muestra mensaje de alerta si hay error
        <?php if (isset($_GET['error']) && $_GET['error'] == 'true') { ?>
            document.getElementById('alerta').textContent = 'Usuario o contraseña incorrectos';
            document.getElementById('alerta').className = 'alerta error';
            document.getElementById('alerta').style.display = 'block';
        <?php } ?>
    </script>
</body>
</html>
