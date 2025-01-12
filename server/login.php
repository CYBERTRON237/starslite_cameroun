<?php
// Inclure le fichier de configuration pour la connexion à la base de données
include('config.php');

// Démarrer la session PHP
session_start();

// Vérifier si l'utilisateur est déjà connecté, et rediriger vers le tableau de bord
if (isset($_SESSION['user_id'])) {
    header("Location: dashboard.php");
    exit();
}

// Définir les messages d'erreur
$error_message = '';

// Vérifier si le formulaire de connexion a été soumis
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les données du formulaire
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Vérifier si l'email et le mot de passe sont non vides
    if (!empty($email) && !empty($password)) {
        // Préparer la requête SQL pour vérifier l'utilisateur dans la base de données
        $query = $pdo->prepare("SELECT * FROM users WHERE email = :email AND status = 'active'");
        $query->bindParam(':email', $email, PDO::PARAM_STR);
        $query->execute();
        $user = $query->fetch(PDO::FETCH_ASSOC);

        // Vérifier si l'utilisateur existe et si le mot de passe est correct
        if ($user && password_verify($password, $user['password'])) {
            // Si la connexion est réussie, enregistrer l'ID de l'utilisateur dans la session
            $_SESSION['user_id'] = $user['id'];

            // Rediriger l'utilisateur vers le tableau de bord en fonction de son rôle
            switch ($user['role']) {
                case 'super_admin':
                    header("Location: super_admin_dashboard.php");
                    break;
                case 'admin':
                    header("Location: admin_dashboard.php");
                    break;
                case 'DG':
                    header("Location: dg_dashboard.php");
                    break;
                case 'chef_ville':
                    header("Location: chef_ville_dashboard.php");
                    break;
                case 'chef_agence':
                    header("Location: chef_agence_dashboard.php");
                    break;
                case 'user':
                    header("Location: user_dashboard.php");
                    break;
                default:
                    $error_message = "Rôle non reconnu.";
                    break;
            }
            exit();
        } else {
            // Si l'utilisateur n'existe pas ou si le mot de passe est incorrect
            $error_message = "Identifiants invalides.";
        }
    } else {
        // Si l'email ou le mot de passe est vide
        $error_message = "Veuillez remplir tous les champs.";
    }
}

?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="login-container">
        <h2>Connexion à votre compte</h2>

        <?php if ($error_message): ?>
            <div class="error-message">
                <?php echo $error_message; ?>
            </div>
        <?php endif; ?>

        <!-- Formulaire de connexion -->
        <form method="POST" action="login.php">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required>
            </div>
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" name="password" id="password" required>
            </div>
            <div class="form-group">
                <button type="submit">Se connecter</button>
            </div>
        </form>

        <p>Vous n'avez pas de compte ? <a href="register.php">S'inscrire</a></p>
    </div>

</body>
</html>
