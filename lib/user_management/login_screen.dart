import 'package:flutter/material.dart';
import 'package:starslite_cameroune/services/auth_service.dart'; // Assurez-vous que le chemin est correct
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Contrôleurs pour les champs de texte (email et mot de passe)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable pour indiquer si la requête est en cours (pour le spinner de chargement)
  bool _isLoading = false;

  // Fonction pour gérer la soumission du formulaire de connexion
  _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final loginData = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final response = await AuthService().login(loginData);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      // Rediriger vers l'écran principal ou dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Afficher un message d'erreur
      Fluttertoast.showToast(msg: response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true, // Masquer le mot de passe
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            _isLoading
                ? CircularProgressIndicator() // Affiche un loader si la requête est en cours
                : ElevatedButton(
                    onPressed: _loginUser,
                    child: Text('Se connecter'),
                  ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Redirige l'utilisateur vers la page d'inscription
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
