<?php
// Inclure le fichier de configuration pour la connexion à la base de données
include('config.php');

// Démarrer la session PHP
session_start();

// Définir les messages d'erreur
$error_message = '';
$success_message = '';

// Vérifier si le formulaire d'enregistrement a été soumis
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les données du formulaire
    $name = $_POST['name'];
    $email = $_POST['email'];
    $number = $_POST['number'];
    $password = $_POST['password'];
    $confirm_password = $_POST['confirm_password'];
    $role = $_POST['role'];  // Vous pouvez définir par défaut un rôle comme 'user' ou laisser un choix pour les rôles administratifs
    $region = $_POST['region'];
    $ville = $_POST['ville'] ?? '';  // Ville peut être optionnelle
    $agency_name = $_POST['agency_name'] ?? '';  // Nom d'agence peut être optionnel

    // Vérifier si tous les champs sont remplis
    if (empty($name) || empty($email) || empty($number) || empty($password) || empty($confirm_password) || empty($role) || empty($region)) {
        $error_message = "Veuillez remplir tous les champs.";
    }

    // Vérifier que les mots de passe correspondent
    elseif ($password !== $confirm_password) {
        $error_message = "Les mots de passe ne correspondent pas.";
    }

    // Vérifier si l'email est valide
    elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error_message = "L'email n'est pas valide.";
    }

    // Vérifier si l'email existe déjà dans la base de données
    else {
        $query = $pdo->prepare("SELECT * FROM users WHERE email = :email OR number = :number");
        $query->bindParam(':email', $email, PDO::PARAM_STR);
        $query->bindParam(':number', $number, PDO::PARAM_STR);
        $query->execute();
        $existing_user = $query->fetch(PDO::FETCH_ASSOC);

        if ($existing_user) {
            $error_message = "Un utilisateur avec cet email ou ce numéro existe déjà.";
        } else {
            // Hasher le mot de passe
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);

            // Préparer la requête pour insérer l'utilisateur dans la base de données
            $insert_query = $pdo->prepare("
                INSERT INTO users (name, email, number, password, role, region, ville, agency_name, status)
                VALUES (:name, :email, :number, :password, :role, :region, :ville, :agency_name, 'active')
            ");

            $insert_query->bindParam(':name', $name, PDO::PARAM_STR);
            $insert_query->bindParam(':email', $email, PDO::PARAM_STR);
            $insert_query->bindParam(':number', $number, PDO::PARAM_STR);
            $insert_query->bindParam(':password', $hashed_password, PDO::PARAM_STR);
            $insert_query->bindParam(':role', $role, PDO::PARAM_STR);
            $insert_query->bindParam(':region', $region, PDO::PARAM_STR);
            $insert_query->bindParam(':ville', $ville, PDO::PARAM_STR);
            $insert_query->bindParam(':agency_name', $agency_name, PDO::PARAM_STR);

            // Exécuter la requête d'insertion
            if ($insert_query->execute()) {
                $success_message = "Inscription réussie ! Vous pouvez maintenant vous connecter.";
                // Optionnellement, vous pouvez rediriger l'utilisateur vers la page de connexion
                // header("Location: login.php");
                // exit();
            } else {
                $error_message = "Une erreur est survenue. Veuillez réessayer.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="register-container">
        <h2>Créer un nouveau compte</h2>

        <!-- Affichage des messages d'erreur ou de succès -->
        <?php if ($error_message): ?>
            <div class="error-message">
                <?php echo $error_message; ?>
            </div>
        <?php endif; ?>
        
        <?php if ($success_message): ?>
            <div class="success-message">
                <?php echo $success_message; ?>
            </div>
        <?php endif; ?>

        <!-- Formulaire d'enregistrement -->
        <form method="POST" action="register.php">
            <div class="form-group">
                <label for="name">Nom complet</label>
                <input type="text" name="name" id="name" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required>
            </div>
            <div class="form-group">
                <label for="number">Numéro de téléphone</label>
                <input type="text" name="number" id="number" required>
            </div>
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" name="password" id="password" required>
            </div>
            <div class="form-group">
                <label for="confirm_password">Confirmer le mot de passe</label>
                <input type="password" name="confirm_password" id="confirm_password" required>
            </div>
            <div class="form-group">
                <label for="role">Rôle</label>
                <select name="role" id="role" required>
                    <option value="user">Utilisateur</option>
                    <option value="admin">Administrateur</option>
                    <option value="super_admin">Super Administrateur</option>
                    <!-- Vous pouvez ajouter d'autres rôles en fonction des besoins -->
                </select>
            </div>
            <div class="form-group">
                <label for="region">Région</label>
                <input type="text" name="region" id="region" required>
            </div>
            <div class="form-group">
                <label for="ville">Ville</label>
                <input type="text" name="ville" id="ville">
            </div>
            <div class="form-group">
                <label for="agency_name">Nom de l'agence</label>
                <input type="text" name="agency_name" id="agency_name">
            </div>
            <div class="form-group">
                <button type="submit">S'inscrire</button>
            </div>
        </form>

        <p>Vous avez déjà un compte ? <a href="login.php">Se connecter</a></p>
    </div>

</body>
</html>
