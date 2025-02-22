<?php
session_start();

// Inicializar el juego si no existe una sesión activa
if (!isset($_SESSION['numero_secreto'])) {
    $_SESSION['numero_secreto'] = rand(1, 100);
    $_SESSION['intentos'] = 0;
    $_SESSION['mensaje'] = "¡Adivina un número entre 1 y 100!";
}

// Manejar el intento del jugador
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['reiniciar'])) {
        session_destroy();
        header("Location: " . $_SERVER['PHP_SELF']);
        exit();
    }

    $numero_usuario = (int)$_POST['numero'];
    $_SESSION['intentos']++;

    if ($numero_usuario < $_SESSION['numero_secreto']) {
        $_SESSION['mensaje'] = "El número es mayor. Intentos: " . $_SESSION['intentos'];
    } elseif ($numero_usuario > $_SESSION['numero_secreto']) {
        $_SESSION['mensaje'] = "El número es menor. Intentos: " . $_SESSION['intentos'];
    } else {
        $_SESSION['mensaje'] = "¡Felicidades! Adivinaste el número en " . $_SESSION['intentos'] . " intentos.";
        session_destroy();
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Juego de Adivinanza</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
        }
        .container {
            max-width: 400px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.1);
        }
        input, button {
            margin-top: 10px;
            padding: 10px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Juego de Adivinanza</h2>
        <p><?php echo $_SESSION['mensaje']; ?></p>
        <form method="post">
            <input type="number" name="numero" min="1" max="100" required>
            <button type="submit">Adivinar</button>
        </form>
        <form method="post">
            <button type="submit" name="reiniciar">Reiniciar Juego</button>
        </form>
    </div>
</body>
</html>
