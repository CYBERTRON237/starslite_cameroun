<?php
// Permettre les requêtes CORS depuis une origine spécifique (remplace par l'URL de ton application Flutter)
header("Access-Control-Allow-Origin: *");  // Utiliser * pour permettre toutes les origines (ou spécifier une origine exacte)
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With, Authorization");

// Répondre aux requêtes OPTIONS (pré-vol) pour les vérifications CORS
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    // Si la requête est de type OPTIONS, on répond avec un statut 200 et on arrête le script
    http_response_code(200);
    exit;
}

// Détails de connexion à la base de données
$host = "localhost";
$user = "root";
$password = "";
$dbname = "starslite_cameroune";

// Connexion à la base de données MySQL avec mysqli
$conn = new mysqli($host, $user, $password, $dbname);

// Vérification de la connexion
if ($conn->connect_error) {
    // Log l'erreur de connexion et renvoie un message d'erreur générique
    error_log("Erreur de connexion à la base de données: " . $conn->connect_error);
    echo json_encode(['success' => false, 'message' => 'Erreur de connexion à la base de données.']);
    exit;
}

// Traitement de la requête POST pour l'inscription
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les données du formulaire
    $name = isset($_POST['name']) ? $_POST['name'] : '';
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';
    $number = isset($_POST['number']) ? $_POST['number'] : '';
    $role = isset($_POST['role']) ? $_POST['role'] : 'user'; // Valeur par défaut
    $region = isset($_POST['region']) ? $_POST['region'] : '';
    $ville = isset($_POST['ville']) ? $_POST['ville'] : '';
    $agency_name = isset($_POST['agency_name']) ? $_POST['agency_name'] : '';

    // Vérification des champs obligatoires
    if (empty($name) || empty($email) || empty($password) || empty($number)) {
        echo json_encode(['success' => false, 'message' => 'Tous les champs sont obligatoires.']);
        exit;
    }

    // Validation de l'email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(['success' => false, 'message' => 'L\'email n\'est pas valide.']);
        exit;
    }

    // Vérifier si l'email ou le numéro existe déjà dans la base de données
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? OR number = ?");
    if (!$stmt) {
        // Log l'erreur de préparation de la requête
        error_log("Erreur de préparation de la requête: " . $conn->error);
        echo json_encode(['success' => false, 'message' => 'Erreur de préparation de la requête.']);
        exit;
    }

    $stmt->bind_param("ss", $email, $number);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(['success' => false, 'message' => 'L\'email ou le numéro est déjà utilisé.']);
        exit;
    }

    // Hacher le mot de passe avant de l'enregistrer
    $hashed_password = password_hash($password, PASSWORD_BCRYPT);

    // Insérer l'utilisateur dans la base de données
    $stmt = $conn->prepare("INSERT INTO users (name, email, password, number, role, region, ville, agency_name, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')");
    if (!$stmt) {
        // Log l'erreur d'insertion
        error_log("Erreur de préparation d'insertion: " . $conn->error);
        echo json_encode(['success' => false, 'message' => 'Erreur lors de l\'inscription.']);
        exit;
    }

    $stmt->bind_param("ssssssss", $name, $email, $hashed_password, $number, $role, $region, $ville, $agency_name);

    // Exécuter l'insertion et répondre en fonction du succès
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Inscription réussie.']);
    } else {
        // Log l'erreur d'insertion dans la base de données
        error_log("Erreur d'insertion dans la base de données: " . $stmt->error);
        echo json_encode(['success' => false, 'message' => 'Erreur lors de l\'inscription.']);
    }

    $stmt->close();
}

// Fermer la connexion à la base de données
$conn->close();
?>
