<?php
header("Content-Type: application/json");

$host = "localhost"; // Sesuaikan dengan host database
$user = "root";      // Sesuaikan dengan username database
$password = "";      // Sesuaikan dengan password database
$dbname = "pustaka_2301083004";

// Membuat koneksi ke database
$conn = new mysqli($host, $user, $password, $dbname);

// Memeriksa koneksi
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Koneksi gagal: " . $conn->connect_error]));
}

// Mendapatkan data dari request (gunakan file_get_contents untuk menangani JSON input)
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['email']) && isset($data['password'])) {
    $email = $data['email'];
    $password = md5($data['password']); // Asumsikan password disimpan dalam hash MD5 di database

    // Query untuk memeriksa email dan password
    $sql = "SELECT * FROM user WHERE email = '$email' AND password = '$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Jika ada user yang cocok
        $user = $result->fetch_assoc();
        echo json_encode(["success" => true, "message" => "Login berhasil", "user" => $user]);
    } else {
        // Jika login gagal
        echo json_encode(["success" => false, "message" => "Email atau password salah"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Data email atau password tidak lengkap"]);
}

// Menutup koneksi
$conn->close();
?>
