<?php
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING); // Oculta warnings/notices temporales

require('fpdf.php');
include 'conexion.php';  // Conexión MySQLi en $conexion

// Comprobar conexión
if ($conexion->connect_errno) {
    die("Error en la conexión: " . $conexion->connect_error);
}

// Obtener el último id_venta registrado
$result = $conexion->query("SELECT MAX(id_venta) AS ultima_venta FROM ventas");
if (!$result) {
    die("Error en la consulta: " . $conexion->error);
}






$row = $result->fetch_assoc();

if ($row && $row['ultima_venta']) {
    $id_venta = (int)$row['ultima_venta'];

    // Obtener cabecera de la venta mediante procedimiento almacenado
    $stmt_venta = $conexion->prepare("CALL obtener_cabecera_venta(?)");
    if (!$stmt_venta) {
        die("Error en la preparación de la consulta: " . $conexion->error);
    }
    $stmt_venta->bind_param("i", $id_venta);
    $stmt_venta->execute();
    $result_venta = $stmt_venta->get_result();
    if (!$result_venta) {
        die("Error en la ejecución del procedimiento obtener_cabecera_venta: " . $conexion->error);
    }
    $venta = $result_venta->fetch_assoc();
    $stmt_venta->close();

    // Liberar resultados pendientes para ejecutar siguiente procedimiento
    $conexion->next_result();

    if ($venta) {
        // Obtener detalle de productos vendidos mediante procedimiento almacenado
        $stmt_detalles = $conexion->prepare("CALL obtener_detalle_venta(?)");
        if (!$stmt_detalles) {
            die("Error en la preparación de la consulta detalles: " . $conexion->error);
        }
        $stmt_detalles->bind_param("i", $id_venta);
        $stmt_detalles->execute();
        $detalles = $stmt_detalles->get_result();
        if (!$detalles) {
            die("Error en la ejecución del procedimiento obtener_detalle_venta: " . $conexion->error);
        }
        $stmt_detalles->close();

        // Crear PDF
        $pdf = new FPDF();
        $pdf->AddPage();
        $pdf->SetFont('Arial', 'B', 16);
        $pdf->Cell(190, 10, 'FACTURA DE VENTA ', 0, 1, 'C');
        $pdf->Ln(5);

        // Cabecera de la venta
        $pdf->SetFont('Arial', '', 12);
        $pdf->Cell(100, 8, 'ID Venta: ' . $venta['id_venta']);
        $pdf->Ln(8);
        $pdf->Cell(100, 8, 'Cliente: ' . $venta['nombre_cliente']);
        $pdf->Ln(8);
        $pdf->Cell(100, 8, 'Fecha: ' . date('d/m/Y', strtotime($venta['fecha'])));
        $pdf->Ln(12);

        // Encabezado de la tabla de detalles
        $pdf->SetFont('Arial', 'B', 11);
        $pdf->Cell(30, 8, 'Cod. Prod.', 1);
        $pdf->Cell(60, 8, 'Producto', 1);
        $pdf->Cell(25, 8, 'Precio', 1, 0, 'R');
        $pdf->Cell(25, 8, 'Cantidad', 1, 0, 'R');
        $pdf->Cell(30, 8, 'Importe', 1, 1, 'R');

        // Detalles
        $pdf->SetFont('Arial', '', 11);
        $total = 0;
        while ($detalle = $detalles->fetch_assoc()) {
            $importe = $detalle['precio'] * $detalle['cantidad'];
            $total += $importe;

            $pdf->Cell(30, 8, $detalle['id_producto'], 1);
            $pdf->Cell(60, 8, $detalle['nombre_producto'], 1);
            $pdf->Cell(25, 8, '$' . number_format($detalle['precio'], 2), 1, 0, 'R');
            $pdf->Cell(25, 8, $detalle['cantidad'], 1, 0, 'R');
            $pdf->Cell(30, 8, '$' . number_format($importe, 2), 1, 1, 'R');
        }

        // Total final
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(140, 10, 'TOTAL A PAGAR', 1);
        $pdf->Cell(30, 10, '$' . number_format($total, 2), 1, 1, 'R');

        // Salida PDF al navegador (sin enviar nada antes)
        $pdf->Output('I', 'Factura_UltimaVenta_' . $id_venta . '.pdf');
        exit; // Termina el script aquí para evitar enviar más texto
    } else {
        echo "No se encontró la última venta.";
    }
} else {
    echo "No hay ventas registradas.";
}
?>