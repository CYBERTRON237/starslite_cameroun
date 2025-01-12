<?php
// Connexion à la base de données MySQL
$servername = "localhost";
$username = "root"; // Votre nom d'utilisateur MySQL
$password = ""; // Votre mot de passe MySQL (par défaut pour WAMP c'est vide)
$dbname = "your_database_name"; // Le nom de votre base de données

// Créer une connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Vérifier si l'utilisateur est authentifié et récupérer son ID ou email (par exemple)
$userId = $_GET['user_id']; // Vous pouvez envoyer l'ID de l'utilisateur via la requête GET

// Requête SQL pour récupérer les données utilisateur
$sql = "SELECT id, name, email, role, profile_picture FROM users WHERE id = '$userId'"; 
$result = $conn->query($sql);

// Vérifier si des résultats ont été trouvés
if ($result->num_rows > 0) {
    // Récupérer la ligne de données
    $user = $result->fetch_assoc();
    // Renvoi des données en format JSON
    echo json_encode([
        'success' => true,
        'data' => $user
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Utilisateur non trouvé'
    ]);
}

$conn->close();
?>
