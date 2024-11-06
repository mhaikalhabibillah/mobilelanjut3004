<?php
header('Content-Type: application/json');
include 'config.php';

try {
    // Ambil raw data dari request body
    $json = file_get_contents('php://input');
    
    // Decode JSON ke array PHP
    $data = json_decode($json, true);

    // Cek apakah data ada
    if ($data === null) {
        throw new Exception('Invalid JSON data');
    }

    $nama = mysqli_real_escape_string($conn, $data['nama']);
    $email = mysqli_real_escape_string($conn, $data['email']);
    $password = mysqli_real_escape_string($conn, $data['password']);
    $hashed_password = md5($password);
    $tingkat = 1;

    $check_query = "SELECT * FROM user WHERE email='$email'";
    $check_result = mysqli_query($conn, $check_query);

    if ($check_result && mysqli_num_rows($check_result) > 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Email sudah terdaftar'
        ]);
    } else {
        $query = "INSERT INTO user (nama, email, password, tingkat) VALUES ('$nama', '$email', '$hashed_password', $tingkat)";
        if (mysqli_query($conn, $query)) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Registrasi berhasil'
            ]);
        } else {
            throw new Exception(mysqli_error($conn));
        }
    }
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error: ' . $e->getMessage()
    ]);
}

mysqli_close($conn);
?> 