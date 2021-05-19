<?php
$servername = "localhost";
$username   = "hubbuddi_271221myshopadmin";
$password   = "DdKH3Ph&![sV";
$dbname     = "hubbuddi_271221_myshopdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
?>