<?php
// Database connection configuration
$host = 'localhost';
$username = 'root';
$password = ''; // Change this if your MySQL has a password
$database = 'smart_parcel_system';

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['error' => 'Connection failed: ' . $conn->connect_error]));
}

// Set charset to UTF-8
$conn->set_charset("utf8");

// Enable error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set JSON header for API responses
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
?>
