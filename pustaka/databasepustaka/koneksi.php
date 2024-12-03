<?php
try {
    $conn = new PDO("mysql:host=localhost;dbname=pustaka_2301083004", "root", "");
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Koneksi gagal: " . $e->getMessage();
    exit;
}
?>