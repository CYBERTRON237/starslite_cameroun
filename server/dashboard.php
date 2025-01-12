<?php
// Inclure le fichier de configuration pour la connexion à la base de données
include('config.php');

// Démarrer la session PHP
session_start();

// Vérifier si l'utilisateur est connecté
if (!isset($_SESSION['user_id'])) {
    // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
    header("Location: login.php");
    exit();
}

// Récupérer l'ID de l'utilisateur depuis la session
$user_id = $_SESSION['user_id'];

// Récupérer les informations de l'utilisateur depuis la base de données
$query = $pdo->prepare("SELECT * FROM users WHERE id = :user_id");
$query->bindParam(':user_id', $user_id, PDO::PARAM_INT);
$query->execute();
$user = $query->fetch(PDO::FETCH_ASSOC);

// Vérifier si l'utilisateur existe
if (!$user) {
    // Si l'utilisateur n'existe pas, rediriger vers la page de connexion
    header("Location: login.php");
    exit();
}

// Définir un tableau de rôles avec leurs redirections respectives
$role_redirects = [
    'super_admin' => 'super_admin_dashboard.php',
    'admin' => 'admin_dashboard.php',
    'DG' => 'dg_dashboard.php',
    'chef_ville' => 'chef_ville_dashboard.php',
    'chef_agence' => 'chef_agence_dashboard.php',
    'user' => 'user_dashboard.php',
];

// Vérifier si le rôle de l'utilisateur existe dans notre tableau
if (isset($role_redirects[$user['role']])) {
    // Rediriger vers la page spécifique du rôle
    header("Location: " . $role_redirects[$user['role']]);
    exit();
} else {
    // Si aucun rôle valide n'est trouvé, rediriger vers une page d'erreur ou de connexion
    header("Location: login.php");
    exit();
}
?>
