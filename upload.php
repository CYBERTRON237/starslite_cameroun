<?php
// Paramètres de connexion à la base de données
$host = 'localhost';
$dbname = 'starslite_cameroune';
$username = 'root';
$password = ''; // Remplacez par votre mot de passe de base de données

// Connexion à la base de données
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(['success' => false, 'message' => 'Erreur de connexion à la base de données: ' . $e->getMessage()]));
}

// Vérifier si l'utilisateur est authentifié (vous pouvez adapter cette logique selon votre système d'authentification)
session_start();
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'message' => 'Utilisateur non authentifié']);
    exit;
}

// ID de l'utilisateur (par exemple, récupéré depuis la session)
$user_id = $_SESSION['user_id'];

// Requête pour récupérer les informations de l'utilisateur
$sql = "SELECT id, name, email, number, role, region, ville, agency_name, profile_picture FROM users WHERE id = :user_id AND status = 'active'";
$stmt = $pdo->prepare($sql);
$stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
$stmt->execute();

// Vérifier si un utilisateur a été trouvé
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    // Renvoyer les données de l'utilisateur sous format JSON
    echo json_encode(['success' => true, 'user' => $user]);
} else {
    // Si l'utilisateur n'existe pas ou est inactif
    echo json_encode(['success' => false, 'message' => 'Utilisateur introuvable ou inactif']);
}
?>
