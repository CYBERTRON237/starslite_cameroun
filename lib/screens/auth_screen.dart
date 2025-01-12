import 'package:flutter/material.dart';
import 'package:starslite_cameroune/services/auth_service.dart'; // Service d'authentification pour gérer l'authentification
import 'package:starslite_cameroune/widgets/loading_button.dart'; // Pour afficher un bouton avec chargement

class AuthScreen extends StatefulWidget {
  final String action; // 'login' ou 'register'

  const AuthScreen({required this.action});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String _errorMessage = '';
  bool _isLoading = false;

  // Fonction d'authentification
  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Réinitialiser les erreurs
    });

    if (widget.action == 'login') {
      // Appel à la fonction de connexion
      Map<String, dynamic> response = await AuthService().login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        // Redirection vers le tableau de bord après la connexion réussie
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Affichage de l'erreur
        setState(() {
          _errorMessage = response['message'] ?? 'Échec de la connexion. Veuillez vérifier vos informations.';
        });
      }
    } else if (widget.action == 'register') {
      // Appel à la fonction d'inscription
      Map<String, dynamic> response = await AuthService().register(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        // Après l'inscription réussie, redirection vers ProfileScreen.dart
        Navigator.pushReplacementNamed(context, '/profile');  // Redirection vers ProfileScreen
      } else {
        // Affichage de l'erreur
        setState(() {
          _errorMessage = response['message'] ?? 'Échec de l\'inscription. Veuillez vérifier vos informations.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.action == 'login' ? 'Se connecter' : 'S\'inscrire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Champ pour le nom, affiché uniquement lors de l'inscription
              if (widget.action == 'register') ...[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    hintText: 'Entrez votre nom complet',
                    errorText: _errorMessage.isEmpty ? null : _errorMessage,
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Champ Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Entrez votre email',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 16),

              // Champ Téléphone, affiché uniquement lors de l'inscription
              if (widget.action == 'register') ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    hintText: 'Entrez votre numéro de téléphone',
                    errorText: _errorMessage.isEmpty ? null : _errorMessage,
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: 'Entrez votre mot de passe',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 16),

              // Affichage du bouton d'action avec un chargement en cours
              _isLoading
                  ? LoadingButton(
                      text: widget.action == 'login' ? 'Se connecter' : 'S\'inscrire',
                      isLoading: _isLoading,
                      onPressed: () {}, // Empêcher l'action durant le chargement
                    )
                  : ElevatedButton(
                      onPressed: _authenticate,
                      child: Text(widget.action == 'login' ? 'Se connecter' : 'S\'inscrire'),
                    ),
              SizedBox(height: 16),

              // Affichage du bouton pour changer l'action (login/signup)
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/auth',
                    arguments: widget.action == 'login' ? 'register' : 'login',
                  );
                },
                child: Text(
                  widget.action == 'login' 
                    ? 'Pas encore de compte? S\'inscrire' 
                    : 'Déjà un compte? Se connecter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
