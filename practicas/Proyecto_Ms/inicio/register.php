<?php
$servername = "sqlXXX.infinityfree.com";
$username = "if0_38308988";
$password = "tu_contraseña";
$database = "if0_38308988_usuarios_db";

$conn = new mysqli($servername, $username, $password, $database);
if ($conn->connect_error) {
    die("❌ Conexión fallida: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST["email"];
    $password = password_hash($_POST["password"], PASSWORD_BCRYPT); // Encripta la contraseña

    $sql = "INSERT INTO usuarios (email, password) VALUES ('$email', '$password')";

    if ($conn->query($sql) === TRUE) {
        echo "<script>alert('✅ Registro exitoso'); window.location.href='index.html';</script>";
    } else {
        echo "<script>alert('❌ Error al registrar usuario'); window.location.href='register.html';</script>";
    }
}

$conn->close();
?>
