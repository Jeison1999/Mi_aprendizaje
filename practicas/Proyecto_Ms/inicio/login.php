<?php
session_start();

// Datos de conexión con la base de datos
$servername = "sqlXXX.infinityfree.com"; // Reemplaza con el host correcto de InfinityFree
$username = "if0_38308988"; // Tu usuario de InfinityFree
$password = "tu_contraseña"; // La contraseña de la base de datos
$database = "if0_38308988_usuarios_db"; // Nombre de la base de datos

$conn = new mysqli($servername, $username, $password, $database);

// Verificar conexión
if ($conn->connect_error) {
    die("❌ Conexión fallida: " . $conn->connect_error);
}

// Recibir datos del formulario
$email = $_POST["email"];
$password = $_POST["password"];

// Buscar usuario en la base de datos
$sql = "SELECT * FROM usuarios WHERE email='$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    
    // Comparar contraseñas (Asegúrate de guardar contraseñas encriptadas en la BD)
    if (password_verify($password, $row["password"])) {
        $_SESSION["usuario"] = $email;
        echo "<script>alert('✅ Inicio de sesión exitoso'); window.location.href='dashboard.php';</script>";
    } else {
        echo "<script>alert('❌ Contraseña incorrecta'); window.location.href='index.html';</script>";
    }
} else {
    echo "<script>alert('❌ Usuario no encontrado'); window.location.href='index.html';</script>";
}

$conn->close();
?>
