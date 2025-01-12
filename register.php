<?php
// Activer l'affichage des erreurs PHP et envoyer les erreurs à stderr
ini_set('display_errors', 1); // Afficher les erreurs dans le navigateur
ini_set('log_errors', 1); // Enregistrer les erreurs dans le log
ini_set('error_log', 'php://stderr'); // Rediriger les erreurs vers stderr (console)

// Rapport d'erreur complet
error_reporting(E_ALL);

// Paramètres de la base de données
$host = '127.0.0.1';  
$dbname = 'starslite_cameroune';
$username = 'root';  
$password = '';  

// Créer une connexion à la base de données
$conn = new mysqli($host, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    error_log("Échec de la connexion à la base de données: " . $conn->connect_error); // Envoie à stderr
    die("Échec de la connexion à la base de données: " . $conn->connect_error); // Termine le script avec une erreur visible
}

// Activer les en-têtes CORS pour permettre les requêtes cross-origin
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Vérifier si la requête est bien une requête POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // Vérifier si les données nécessaires sont présentes
    if (isset($_POST['name'], $_POST['email'], $_POST['number'], $_POST['password'], $_POST['region'])) {

        // Récupérer les données envoyées via le formulaire
        $name = $_POST['name'];
        $email = $_POST['email'];
        $number = $_POST['number'];
        $password = $_POST['password']; 
        $region = $_POST['region'];
        $role = isset($_POST['role']) ? $_POST['role'] : 'user';
        $ville = isset($_POST['ville']) ? $_POST['ville'] : '';     
        $agency_name = isset($_POST['agency_name']) ? $_POST['agency_name'] : '';  
        $status = 'active';  
        $is_verified = 0;  
        $phone_verified = 0;  
        $failed_login_attempts = 0;  
        $account_locked = 0;  
        $notifications_enabled = 1;  
        $is_2fa_enabled = 0;  
        $last_ip_address = '';  

        // Hashage du mot de passe
        $hashed_password = password_hash($password, PASSWORD_BCRYPT);

        // Vérification de l'email ou du numéro
        $stmt = $conn->prepare("SELECT id FROM users WHERE email = ? OR number = ?");
        $stmt->bind_param("ss", $email, $number);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            error_log("L'email ou le numéro de téléphone est déjà utilisé."); // Envoie à stderr
            echo 'L\'email ou le numéro de téléphone est déjà utilisé.';
            $stmt->close();
            $conn->close();
            exit();
        }

        // Gestion de l'image de profil
        $profile_picture = null;
        if (isset($_FILES['profile_picture']) && $_FILES['profile_picture']['error'] == UPLOAD_ERR_OK) {
            $upload_dir = 'uploads/';
            $file_name = basename($_FILES['profile_picture']['name']);
            $file_path = $upload_dir . $file_name;

            if (move_uploaded_file($_FILES['profile_picture']['tmp_name'], $file_path)) {
                $profile_picture = $file_path;
            } else {
                error_log('Erreur lors de l\'upload de l\'image de profil.'); // Envoie à stderr
                echo 'Erreur lors de l\'upload de l\'image de profil.';
                exit();
            }
        }

        // Insertion de l'utilisateur
        $stmt = $conn->prepare("INSERT INTO users (name, email, number, password, role, region, ville, agency_name, status, profile_picture, is_verified, phone_verified, failed_login_attempts, account_locked, notifications_enabled, is_2fa_enabled, last_ip_address) 
                                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssssssssssssss", $name, $email, $number, $hashed_password, $role, $region, $ville, $agency_name, $status, $profile_picture, $is_verified, $phone_verified, $failed_login_attempts, $account_locked, $notifications_enabled, $is_2fa_enabled, $last_ip_address);

        if ($stmt->execute()) {
            echo 'Utilisateur créé avec succès!';
        } else {
            error_log('Erreur lors de la création de l\'utilisateur: ' . $stmt->error); // Envoie à stderr
            echo 'Erreur lors de la création de l\'utilisateur: ' . $stmt->error;
        }

        $stmt->close();
    } else {
        error_log('Toutes les données ne sont pas envoyées!'); // Envoie à stderr
        echo 'Toutes les données ne sont pas envoyées!';
    }
}

$conn->close();
?>
