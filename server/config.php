<?php
// Configuration de la base de données
define('DB_HOST', 'localhost');       // Hôte de la base de données
define('DB_USER', 'root');            // Nom d'utilisateur de la base de données
define('DB_PASSWORD', '');            // Mot de passe de la base de données (mettre le mot de passe ici si nécessaire)
define('DB_NAME', 'starslite_cameroune'); // Nom de la base de données

// Créer une connexion à la base de données MySQL
try {
    // Connexion à MySQL avec PDO
    $pdo = new PDO('mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8', DB_USER, DB_PASSWORD);
    // Définir le mode d'erreur de PDO sur exception
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    // Si la connexion échoue, afficher un message d'erreur
    die("Erreur de connexion à la base de données : " . $e->getMessage());
}
?>
