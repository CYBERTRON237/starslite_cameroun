<?php
// Paramètres de la base de données
$host = '127.0.0.1';  // L'hôte de la base de données (peut-être localhost ou IP)
$dbname = 'starslite_cameroune';  // Nom de la base de données
$username = 'root';  // Nom d'utilisateur
$password = '';  // Mot de passe de la base de données (par défaut vide sur localhost)

// Créer une connexion à la base de données
$conn = new mysqli($host, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Échec de la connexion à la base de données: " . $conn->connect_error);
}

// Activer les en-têtes CORS pour permettre les requêtes cross-origin
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Vérifier si la requête est bien une requête POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // Vérifier si les données nécessaires sont présentes
    if (isset($_POST['email']) || isset($_POST['number']) && isset($_POST['password'])) {

        // Récupérer les données envoyées via le formulaire
        $email = isset($_POST['email']) ? $_POST['email'] : '';
        $number = isset($_POST['number']) ? $_POST['number'] : '';
        $password = $_POST['password'];  // Le mot de passe envoyé par l'utilisateur

        // Vérification de l'existence de l'utilisateur dans la base de données
        if (!empty($email)) {
            $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? AND status = 'active'");
            $stmt->bind_param("s", $email);
        } elseif (!empty($number)) {
            $stmt = $conn->prepare("SELECT * FROM users WHERE number = ? AND status = 'active'");
            $stmt->bind_param("s", $number);
        } else {
            echo json_encode(['success' => false, 'message' => 'Email ou numéro de téléphone requis.']);
            exit();
        }

        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            // Récupérer l'utilisateur
            $user = $result->fetch_assoc();

            // Vérifier si le mot de passe est correct
            if (password_verify($password, $user['password'])) {
                
                // Vérifier si le compte est verrouillé
                if ($user['account_locked'] == 1) {
                    echo json_encode(['success' => false, 'message' => 'Compte verrouillé.']);
                    exit();
                }

                // Mettre à jour la date et l'adresse IP de la dernière connexion
                $last_ip_address = $_SERVER['REMOTE_ADDR'];
                $last_login = date('Y-m-d H:i:s');
                $stmt_update = $conn->prepare("UPDATE users SET last_login = ?, last_ip_address = ? WHERE id = ?");
                $stmt_update->bind_param("ssi", $last_login, $last_ip_address, $user['id']);
                $stmt_update->execute();

                // Générer un token d'authentification (facultatif selon votre besoin)
                $auth_token = bin2hex(random_bytes(16));

                // Enregistrer le token dans la base de données (si vous souhaitez l'utiliser pour l'authentification)
                $stmt_token = $conn->prepare("UPDATE users SET auth_token = ? WHERE id = ?");
                $stmt_token->bind_param("si", $auth_token, $user['id']);
                $stmt_token->execute();

                // Retourner la réponse de succès avec les informations de l'utilisateur
                echo json_encode([
                    'success' => true,
                    'message' => 'Connexion réussie.',
                    'user' => [
                        'id' => $user['id'],
                        'name' => $user['name'],
                        'email' => $user['email'],
                        'role' => $user['role'],
                        'region' => $user['region'],
                        'ville' => $user['ville'],
                        'profile_picture' => $user['profile_picture'],
                        'auth_token' => $auth_token
                    ]
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Mot de passe incorrect.']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Utilisateur non trouvé ou inactif.']);
        }

        $stmt->close();
    } else {
        echo json_encode(['success' => false, 'message' => 'Les champs email/numéro de téléphone et mot de passe sont requis.']);
    }
} elseif ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    // Requête OPTIONS (pré-vol CORS) - Si nécessaire
    exit();
}

// Fermer la connexion à la base de données
$conn->close();
?>
