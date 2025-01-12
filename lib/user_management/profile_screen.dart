import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  // Fonction pour vérifier si l'email est valide
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  // Fonction pour vérifier si le numéro de téléphone est valide
  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r"^[0-9]{9,15}$");  // Un numéro simple de 9 à 15 chiffres
    return phoneRegex.hasMatch(phone);
  }

  // Fonction pour vérifier la force du mot de passe
  bool _isValidPassword(String password) {
    return password.length >= 6;  // Le mot de passe doit faire au moins 6 caractères
  }

  // Fonction pour enregistrer un utilisateur via l'API
  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Vérification des champs obligatoires
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Tous les champs doivent être remplis';
        _isLoading = false;
      });
      return;
    }

    // Vérification de la validité de l'email
    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _errorMessage = 'Veuillez entrer un email valide';
        _isLoading = false;
      });
      return;
    }

    // Vérification de la validité du numéro de téléphone
    if (!_isValidPhone(_phoneController.text)) {
      setState(() {
        _errorMessage = 'Veuillez entrer un numéro de téléphone valide';
        _isLoading = false;
      });
      return;
    }

    // Vérification de la validité du mot de passe
    if (!_isValidPassword(_passwordController.text)) {
      setState(() {
        _errorMessage = 'Le mot de passe doit contenir au moins 6 caractères';
        _isLoading = false;
      });
      return;
    }

    // URL de l'API (Assurez-vous de mettre l'URL correcte où se trouve votre fichier PHP)
    final url = Uri.parse('http://localhost/starslite_cameroune/register.php');
    print("Envoi des données à l'URL : $url");  // Debug : Affichage de l'URL d'envoi

    // Envoi des données via POST
    try {
      final response = await http.post(
        url,
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'number': _phoneController.text,
          'password': _passwordController.text,
          'region': _regionController.text,  // Facultatif
        },
      );

      print("Réponse du serveur : ${response.body}");  // Debug : Affichage de la réponse brute du serveur

      // Vérification de la réponse de l'API
      final responseData = json.decode(response.body);
      print("Données de la réponse décodées : $responseData");  // Debug : Affichage des données JSON reçues

      setState(() {
        _isLoading = false;
      });

      if (responseData['success']) {
        setState(() {
          _errorMessage = 'Compte créé avec succès!';
        });
        // Naviguer vers une autre page, comme la page de connexion
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Erreur lors de la création du compte.';
        });
      }
    } catch (error) {
      print("Erreur de connexion : $error");  // Debug : Affichage des erreurs dans le bloc catch
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur de connexion. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Champ Nom
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 16),

              // Champ Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 16),

              // Champ Téléphone
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 16),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 16),

              // Champ Région
              TextField(
                controller: _regionController,
                decoration: InputDecoration(
                  labelText: 'Région',
                ),
              ),
              SizedBox(height: 16),

              // Bouton d'inscription
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerUser,
                      child: Text('Créer un compte'),
                    ),
              SizedBox(height: 16),

              // Message d'erreur
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
