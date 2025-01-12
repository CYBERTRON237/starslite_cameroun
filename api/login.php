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

// Traitement de la requête POST pour la connexion
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les données du formulaire
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';

    // Vérification des champs obligatoires
    if (empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Email et mot de passe sont requis.']);
        exit;
    }

    // Validation de l'email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(['success' => false, 'message' => 'L\'email n\'est pas valide.']);
        exit;
    }

    // Vérification si l'email existe dans la base de données
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
    if (!$stmt) {
        // Log l'erreur de préparation de la requête
        error_log("Erreur de préparation de la requête: " . $conn->error);
        echo json_encode(['success' => false, 'message' => 'Erreur de préparation de la requête.']);
        exit;
    }

    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Vérification du mot de passe
        if (password_verify($password, $user['password'])) {
            echo json_encode(['success' => true, 'message' => 'Connexion réussie.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Mot de passe incorrect.']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Aucun utilisateur trouvé avec cet email.']);
    }

    $stmt->close();
}

// Fermer la connexion à la base de données
$conn->close();
?>
