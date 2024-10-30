<?php
require 'config.php';

// Set headers for API accessibility
header(header: "Content-Type: application/json");
header(header:"Access-Control-Allow-Origin: *");
header(header:"Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header(header:"Access-Control-Allow-Headers: Content-Type");

$method = $_SERVER["REQUEST_METHOD"];
$Path_Info = isset($_SERVER['PATH_INFO']) ? $_SERVER["PATH_INFO"] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER["ORIG_PATH_INFO"] : "");
$request = explode('/', trim($Path_Info, '/'));
$id = isset($request[1]) ? (int)$request[1] : null;
switch ($method) {
    case 'GET':
        if ($id) {
            // GET Student by ID
            $stmt = $pdo->prepare("SELECT * FROM student WHERE id = ?");
            $stmt->execute([$id]);
            $student = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($student) {
                echo json_encode($student);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Student not found"]);
            }
        } else {
            // GET All Students
            $stmt = $pdo->query("SELECT * FROM student");
            $student = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($student);
        }
        break;
        case 'POST':
            // Create new student
            $data = json_decode(file_get_contents("php://input"), true);
            if (!empty($data['name']) && !empty($data['age']) && !empty($data['major'])) {
                $stmt = $pdo->prepare("INSERT INTO student (name, age, major) VALUES (?, ?, ?)");
                $stmt->execute([$data['name'], $data['age'], $data['major']]);
                echo json_encode(["message" => "Student created", "id" => $pdo->lastInsertId()]);
            } else {
                http_response_code(400);
                echo json_encode(["message" => "Invalid data"]);
            }
            break;
            case 'PUT':
                // Update student by ID
                if ($id) {
                    $data = json_decode(file_get_contents("php://input"), true);
                    $stmt = $pdo->prepare("SELECT * FROM student WHERE id = ?");
                    $stmt->execute([$id]);
                    $student = $stmt->fetch(PDO::FETCH_ASSOC);
                    if ($student) {
                        $name = $data['name'] ?? $student['name'];
                        $age = $data['age'] ?? $student['age'];
                        $major = $data['major'] ?? $student['major'];
                        $stmt = $pdo->prepare("UPDATE student SET name = ?, age = ?, major = ? WHERE id = ?");
                        $stmt->execute([$name, $age, $major, $id]);
                        echo json_encode(["message" => "Student updated"]);
                    } else {
                        http_response_code(404);
                        echo json_encode(["message" => "Student not found"]);
                    }
                } else {
                    http_response_code(400);
                    echo json_encode(["message" => "ID not provided"]);
                }
                break;
                case 'DELETE':
                    // Delete student by ID
                    if ($id) {
                        $stmt = $pdo->prepare("SELECT * FROM student WHERE id = ?");
                        $stmt->execute([$id]);
                        $student = $stmt->fetch(PDO::FETCH_ASSOC);
                        if ($student) {
                            $stmt = $pdo->prepare("DELETE FROM student WHERE id = ?");
                            $stmt->execute([$id]);
                            echo json_encode(["message" => "Student deleted"]);
                        } else {
                            http_response_code(404);
                            echo json_encode(["message" => "Student not found"]);
                        }
                    } else {
                        http_response_code(400);
                        echo json_encode(["message" => "ID not provided"]);
                    }
                    break;
                
                default:
                    http_response_code(405);
                    echo json_encode(["message" => "Method not allowed"]);
                    break;
            }
            ?>