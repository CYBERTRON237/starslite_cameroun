import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour manipuler les données JSON

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _emailError = ''; // Stockage des erreurs spécifiquement pour l'email
  String _passwordError = ''; // Stockage des erreurs spécifiquement pour le mot de passe

  // Fonction de connexion
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _emailError = ''; // Réinitialiser l'erreur sur l'email
      _passwordError = ''; // Réinitialiser l'erreur sur le mot de passe
    });

    // Vérification des champs de formulaire
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        if (_emailController.text.isEmpty) {
          _emailError = 'Veuillez entrer votre email';
        }
        if (_passwordController.text.isEmpty) {
          _passwordError = 'Veuillez entrer votre mot de passe';
        }
        _isLoading = false;
      });
      return;
    }

    // Vérification du format de l'email avec une meilleure regex
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      setState(() {
        _emailError = 'Veuillez entrer un email valide';
        _isLoading = false;
      });
      return;
    }

    // L'URL de votre API PHP (pour l'environnement local)
    final String apiUrl = 'http://localhost/starslite_cameroune/login.php';

    // Données envoyées à l'API
    Map<String, String> loginData = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      // Appel HTTP POST
      final response = await http.post(Uri.parse(apiUrl), body: loginData);

      setState(() {
        _isLoading = false;
      });

      // Vérifier la réponse de l'API
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Si la connexion réussit
        if (responseBody['success']) {
          // Récupérer le rôle de l'utilisateur depuis la réponse
          String userRole = responseBody['user']['role'] ?? '';
          String userName = responseBody['user']['name'] ?? '';
          String userEmail = responseBody['user']['email'] ?? '';
          String userRegion = responseBody['user']['region'] ?? '';
          String userCity = responseBody['user']['ville'] ?? '';
          String userAgency = responseBody['user']['agency_name'] ?? '';
          String userProfilePicture = responseBody['user']['profile_picture'] ?? 'https://via.placeholder.com/150';

          // Rediriger vers la page spécifique en fonction du rôle
          String dashboardRoute = _getDashboardRoute(userRole);

          if (dashboardRoute.isNotEmpty) {
            // Redirection vers la page spécifique avec les informations de l'utilisateur
            Navigator.pushReplacementNamed(
              context,
              dashboardRoute,
              arguments: {
                'name': userName,
                'role': userRole,
                'email': userEmail,
                'region': userRegion,
                'city': userCity,
                'agency': userAgency,
                'profilePicture': userProfilePicture,
              },
            );
          } else {
            // Si le rôle est inconnu ou non spécifié
            setState(() {
              _emailError = 'Rôle d\'utilisateur inconnu';
            });
          }
        } else {
          // Gestion des erreurs de l'API de manière plus générale
          String errorMessage = responseBody['message'] ?? 'Erreur de connexion, veuillez réessayer.';
          setState(() {
            _emailError = errorMessage;
            _passwordError = '';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _emailError = '';
          _passwordError = 'Erreur de connexion avec le serveur. Code: ${response.statusCode}';
        });
        print('Erreur HTTP : ${response.statusCode}'); // Afficher l'erreur HTTP dans la console
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _emailError = '';
        _passwordError = 'Erreur lors de la requête: $e';
      });
      print('Erreur lors de la requête : $e'); // Afficher l'erreur dans la console
    }
  }

  // Fonction pour déterminer la route du tableau de bord en fonction du rôle
  String _getDashboardRoute(String role) {
    switch (role) {
      case 'super_admin':
        return '/super_admin_dashboard'; // Page spécifique pour Super Admin
      case 'admin':
        return '/admin_dashboard'; // Page spécifique pour Admin
      case 'DG':
        return '/dg_dashboard'; // Page spécifique pour DG
      case 'chef_ville':
        return '/chef_ville_dashboard'; // Page spécifique pour Chef Ville
      case 'chef_agence':
        return '/chef_agence_dashboard'; // Page spécifique pour Chef Agence
      case 'user':
        return '/user_dashboard'; // Page spécifique pour User
      default:
        return ''; // Retourne une chaîne vide si le rôle est inconnu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Champ Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Entrez votre email',
                  errorText: _emailError.isEmpty ? null : _emailError, // Affiche l'erreur sur l'email
                ),
              ),
              SizedBox(height: 16),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: 'Entrez votre mot de passe',
                  errorText: _passwordError.isEmpty ? null : _passwordError, // Affiche l'erreur sur le mot de passe
                ),
              ),
              SizedBox(height: 16),

              // Affichage du bouton d'action avec un chargement en cours
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Se connecter'),
                    ),
              SizedBox(height: 16),

              // Affichage du bouton pour changer vers l'inscription
              TextButton(
                onPressed: () {
                  // Redirection vers RegisterScreen pour l'inscription
                  Navigator.pushReplacementNamed(
                    context,
                    '/register',  // Assurez-vous que la route '/register' est correctement définie dans le main.dart
                  );
                },
                child: Text('Pas encore de compte? Créez un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
