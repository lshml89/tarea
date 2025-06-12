<?php
// Datos de conexión a la base de datos
$servidor = "localhost";  // Cambia según tu servidor
$usuario = "root";        // Cambia según tu configuración
$contrasena = "";         // Cambia según tu configuración
$basededatos = "proyecto";      // Asegúrate de que la base de datos existe

// Crear la conexión
$conexion = new mysqli($servidor, $usuario, $contrasena, $basededatos);

// Verificar si la conexión fue exitosa
if ($conexion->connect_error) {
    die("Conexión fallida: " . $conexion->connect_error);
}
?>
