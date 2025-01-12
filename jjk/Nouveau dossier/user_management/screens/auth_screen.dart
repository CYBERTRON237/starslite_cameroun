import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour gérer les erreurs et la validation
import 'dart:io'; // Pour gérer les exceptions liées à la connexion Internet

class AuthScreen extends StatefulWidget {
  final String action; // Action 'login' ou 'register'

  // Constructeur de la classe AuthScreen
  AuthScreen({required this.action});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Déclaration des contrôleurs pour les champs de saisie
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables pour gérer les erreurs et l'état du chargement
  bool _isLoading = false;
  String _errorMessage = '';

  // Fonction pour effectuer l'authentification ou l'inscription
  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Réinitialiser les erreurs
    });

    try {
      // Vérification de la connexion Internet
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw SocketException('Pas de connexion Internet');
      }

      // Simuler une demande d'authentification ou d'inscription
      if (widget.action == 'login') {
        // Simuler la logique de connexion
        await Future.delayed(Duration(seconds: 2)); // Simulation de délai
        setState(() {
          _isLoading = false;
        });
        // Ajouter la logique réelle de connexion ici (API, etc.)
        Navigator.pop(context); // Ferme l'écran de connexion une fois authentifié
      } else if (widget.action == 'register') {
        // Simuler la logique d'inscription
        await Future.delayed(Duration(seconds: 2)); // Simulation de délai
        setState(() {
          _isLoading = false;
        });
        // Ajouter la logique réelle d'inscription ici (API, etc.)
        Navigator.pop(context); // Ferme l'écran une fois inscrit
      }
    } on SocketException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.action == 'login' ? 'Se connecter' : 'S\'inscrire'),
        backgroundColor: Color(0xFF1A3D2A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                widget.action == 'login' ? 'Connexion' : 'Inscription',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3D2A),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Email', _emailController),
              SizedBox(height: 20),
              _buildTextField('Mot de passe', _passwordController, obscureText: true),
              SizedBox(height: 30),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A3D2A), // Couleur de fond
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        widget.action == 'login' ? 'Se connecter' : 'S\'inscrire',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour construire un champ de texte générique
  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF1A3D2A)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1A3D2A), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      ),
    );
  }
}
