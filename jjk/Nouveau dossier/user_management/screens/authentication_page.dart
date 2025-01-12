import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Assurez-vous que ApiService est bien défini

class AuthenticationPage extends StatefulWidget {
  final String action; // "register" ou "login"

  AuthenticationPage({required this.action});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _number = '';
  String _role = 'user'; // Valeur par défaut
  String _region = '';
  String _ville = '';
  String _agencyName = '';
  bool _isLoading = false;
  String _statusMessage = ''; // Message de statut pour afficher les erreurs ou succès

  final ApiService _apiService = ApiService();

  // Fonction pour envoyer le formulaire
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      Map<String, dynamic> response;

      // Si action est "register"
      if (widget.action == 'register') {
        response = await _apiService.register(
          name: _name,
          email: _email,
          password: _password,
          number: _number,
          role: _role,
          region: _region,
          ville: _ville,
          agencyName: _agencyName,
        );
      } else {
        response = await _apiService.login(_email, _password);
      }

      if (response['success']) {
        setState(() {
          _statusMessage = widget.action == 'register'
              ? 'Inscription réussie!'
              : 'Connexion réussie!';
        });
        Navigator.pushReplacementNamed(context, '/home'); // Redirection après connexion
      } else {
        setState(() {
          _statusMessage = 'Erreur: ${response['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Erreur de communication avec le serveur : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF006400), // Vert émeraude foncé
        title: Text(
          widget.action == 'register' ? 'Inscription' : 'Connexion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.action == 'register' ? 'Créez votre compte' : 'Bienvenue Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006400),
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (widget.action == 'register')
                      _buildTextField(
                        label: 'Nom complet',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Le nom est obligatoire';
                          }
                          return null;
                        },
                        onChanged: (value) => _name = value,
                      ),
                    _buildTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'L\'email est obligatoire';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'L\'email est invalide';
                        }
                        return null;
                      },
                      onChanged: (value) => _email = value,
                    ),
                    _buildTextField(
                      label: 'Mot de passe',
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Le mot de passe est obligatoire';
                        }
                        return null;
                      },
                      onChanged: (value) => _password = value,
                    ),
                    if (widget.action == 'register') ...[
                      _buildTextField(
                        label: 'Numéro',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Le numéro est obligatoire';
                          }
                          return null;
                        },
                        onChanged: (value) => _number = value,
                      ),
                      _buildTextField(
                        label: 'Région',
                        onChanged: (value) => _region = value,
                      ),
                      _buildTextField(
                        label: 'Ville',
                        onChanged: (value) => _ville = value,
                      ),
                      _buildTextField(
                        label: 'Nom de l\'agence',
                        onChanged: (value) => _agencyName = value,
                      ),
                    ],
                    if (_statusMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _statusMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submitForm,
                            child: Text(
                              widget.action == 'register' ? 'S\'inscrire' : 'Se connecter',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFA500), // Remplacé 'primary' par 'backgroundColor'
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour construire un champ de texte avec les propriétés nécessaires
  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF006400),
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA500), width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        ),
      ),
    );
  }
}
