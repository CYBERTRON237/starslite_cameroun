<?php
// Démarrer la session pour vérifier l'authentification
session_start();

// Vérifier si l'utilisateur est connecté
if (!isset($_SESSION['user_id'])) {
    // Si l'utilisateur n'est pas connecté, rediriger vers la page de connexion
    header('Location: login.php');
    exit();
}

// Connexion à la base de données
include('config.php');

// Récupérer les informations de l'utilisateur à partir de la session
$user_id = $_SESSION['user_id'];

// Requête pour récupérer les informations de l'utilisateur, y compris son rôle
$query = $pdo->prepare("SELECT id, name, email, role FROM users WHERE id = :user_id");
$query->bindParam(':user_id', $user_id, PDO::PARAM_INT);
$query->execute();
$user = $query->fetch(PDO::FETCH_ASSOC);

// Si l'utilisateur n'est pas trouvé dans la base de données, rediriger vers la page de connexion
if (!$user) {
    session_destroy();  // Détruire la session en cas d'erreur
    header('Location: login.php');
    exit();
}

// L'utilisateur existe, vérifier son rôle
$role = $user['role'];

// Redirection en fonction du rôle
switch ($role) {
    case 'super_admin':
        header('Location: super_admin_dashboard.php');
        break;
    case 'admin':
        header('Location: admin_dashboard.php');
        break;
    case 'DG':
        header('Location: dg_dashboard.php');
        break;
    case 'chef_ville':
        header('Location: chef_ville_dashboard.php');
        break;
    case 'chef_agence':
        header('Location: chef_agence_dashboard.php');
        break;
    case 'user':
        header('Location: user_dashboard.php');
        break;
    default:
        // Si le rôle n'est pas reconnu, déconnecter l'utilisateur et rediriger vers la page de connexion
        session_destroy();
        header('Location: login.php');
        break;
}

// Terminer l'exécution du script après la redirection
exit();
?>
