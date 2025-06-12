<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: login.php");
    exit;
}

include 'conexion.php';

$productos_para_form = [];
if ($conexion->multi_query("CALL obtener_producto()")) {
    if ($resultado = $conexion->store_result()) {
        while ($fila = $resultado->fetch_assoc()) {
            $productos_para_form[] = $fila;
        }
        $resultado->free();
    }
    while ($conexion->more_results() && $conexion->next_result()) {}
}

$clientes_para_form = [];
if ($conexion->multi_query("CALL obtener_clientes()")) {
    if ($resultado = $conexion->store_result()) {
        while ($fila = $resultado->fetch_assoc()) {
            $clientes_para_form[] = $fila;
        }
        $resultado->free();
    }
    while ($conexion->more_results() && $conexion->next_result()) {}
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Realizar Venta</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .panel-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }
        h1 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }
        select, input[type=number] {
            width: 100%;
            padding: 8px 12px;
            margin-bottom: 18px;
            border: 1.8px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.2s;
        }
        select:focus, input[type=number]:focus {
            border-color: #007bff;
            outline: none;
        }
        .product-row {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        .product-row select,
        .product-row input[type=number] {
            flex: 1;
            margin-bottom: 0;
        }
        .product-row button.remove-product-button {
            background-color: #dc3545;
            border: none;
            color: white;
            border-radius: 6px;
            padding: 0 14px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1.2rem;
            line-height: 1;
            height: 38px;
            transition: background-color 0.3s ease;
        }
        .product-row button.remove-product-button:hover {
            background-color: #b02a37;
        }
        #add-product-button {
            display: inline-block;
            background-color: #28a745;
            border: none;
            color: white;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        #add-product-button:hover {
            background-color: #218838;
        }
        button[type="submit"] {
            display: block;
            width: 100%;
            background-color: #007bff;
            color: white;
            padding: 12px 0;
            font-size: 1.1rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }
        button[type="submit"]:hover {
            background-color: #0056b3;
        }
        .secondary-button {
            display: block;
            text-align: center;
            margin-top: 12px;
            color: #555;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }
        .secondary-button:hover {
            color: #000;
        }
        .alerta {
            display: none;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 6px;
            font-weight: bold;
        }
        .alerta.success {
            background-color: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }
        .alerta.error {
            background-color: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }
    </style>
</head>
<body>
    <div class="panel-container">
        <h1>Realizar Venta</h1>

        <div id="mensaje-respuesta" class="alerta"></div>

        <form id="venta-form">
            <label for="id_cliente">Selecciona el Cliente:</label>
            <select name="id_cliente" id="id_cliente">
                <option value="">Selecciona un cliente</option>
                <?php foreach ($clientes_para_form as $cliente): ?>
                    <option value="<?php echo $cliente['id_cliente']; ?>">
                        <?php echo htmlspecialchars($cliente['nombres'] . ' ' . $cliente['apellidos']); ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label>Productos:</label>
            <div id="productos-container">
                <div class="product-row">
                    <select name="productos[0][id_producto]">
                        <option value="">Selecciona un producto</option>
                        <?php foreach ($productos_para_form as $p): ?>
                            <option value="<?php echo $p['id_producto']; ?>"><?php echo htmlspecialchars($p['nombre']); ?></option>
                        <?php endforeach; ?>
                    </select>
                    <input type="number" name="productos[0][cantidad]" placeholder="Cantidad" min="1">
                    <button type="button" class="remove-product-button">−</button>
                </div>
            </div>

            <button type="button" id="add-product-button">Añadir Otro Producto</button>
            <button type="submit">Realizar Venta</button>
            <a href="index.php" class="secondary-button">Volver al Panel Principal</a>
        </form>
    </div>

    <script>
        const form = document.getElementById('venta-form');
        const mensaje = document.getElementById('mensaje-respuesta');

        form.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData();
            const id_cliente = document.getElementById('id_cliente').value;
            const productos = [];

            document.querySelectorAll('.product-row').forEach((row) => {
                const id = row.querySelector('select').value;
                const cantidad = row.querySelector('input').value;
                productos.push({ id_producto: id, cantidad: cantidad });
            });

            formData.append('id_cliente', id_cliente);
            formData.append('productos', JSON.stringify(productos));

            fetch('guardarventadetalle.php', {
                method: 'POST',
                body: formData
            })
            .then(res => res.text())
            .then(data => {
                mensaje.textContent = data;
                mensaje.style.display = 'block';
                mensaje.className = 'alerta ' + (data.startsWith('✅') ? 'success' : 'error');
            })
            .catch(err => {
                mensaje.textContent = '❌ Error de red o del servidor.';
                mensaje.style.display = 'block';
                mensaje.className = 'alerta error';
            });
        });

        const addButton = document.getElementById('add-product-button');
        const productosContainer = document.getElementById('productos-container');

        addButton.addEventListener('click', () => {
            const index = productosContainer.children.length;
            const div = document.createElement('div');
            div.className = 'product-row';
            div.innerHTML = `
                <select name="productos[${index}][id_producto]">
                    <option value="">Selecciona un producto</option>
                    <?php foreach ($productos_para_form as $p): ?>
                        <option value="<?php echo $p['id_producto']; ?>"><?php echo htmlspecialchars($p['nombre']); ?></option>
                    <?php endforeach; ?>
                </select>
                <input type="number" name="productos[${index}][cantidad]" placeholder="Cantidad" min="1">
                <button type="button" class="remove-product-button">−</button>
            `;
            productosContainer.appendChild(div);
            attachRemoveHandler(div.querySelector('.remove-product-button'));
        });

        function attachRemoveHandler(button) {
            button.addEventListener('click', () => {
                button.parentElement.remove();
                Array.from(productosContainer.children).forEach((div, i) => {
                    div.querySelector('select').name = `productos[${i}][id_producto]`;
                    div.querySelector('input').name = `productos[${i}][cantidad]`;
                });
            });
        }

        document.querySelectorAll('.remove-product-button').forEach(btn => attachRemoveHandler(btn));
    </script>
</body>
</html>

