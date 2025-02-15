<?php
// Datos de conexión
$servername = "sql102.infinityfree.com"; // Cambia por el servidor correcto
$username = "if0_38296934"; // Tu usuario de InfinityFree
$password = "Yosoyel10"; // La contraseña de tu cuenta
$database = "if0_38296934_the_trubiuz_db"; // Tu base de datos

// Crear conexión con MySQL
$conn = new mysqli($servername, $username, $password, $database);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
} else {
    echo "✅ Conexión exitosa a la base de datos.";
}
?>
