import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, dynamic>? _userData;

  // Fonction pour récupérer les informations de l'utilisateur depuis l'API PHP
  Future<void> _getUserProfile() async {
    final url = Uri.parse('http://localhost/starslite_cameroune/upload.php'); // Remplace par ton URL de l'API
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          setState(() {
            _userData = data['user'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Utilisateur introuvable';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Erreur de serveur. Veuillez réessayer plus tard.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur est survenue. Vérifiez votre connexion.';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Utilisateur'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Affichage du message de bienvenue
                        Text(
                          'Bienvenue, ${_userData?['name']}!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Informations utilisateur
                        _buildInfoTile('Nom:', _userData?['name']),
                        _buildInfoTile('Email:', _userData?['email']),
                        _buildInfoTile('Numéro de téléphone:', _userData?['number']),
                        _buildInfoTile('Rôle:', _userData?['role']),
                        _buildInfoTile('Région:', _userData?['region']),
                        _buildInfoTile('Ville:', _userData?['ville'] ?? 'Non renseignée'),
                        _buildInfoTile('Nom de l\'agence:', _userData?['agency_name'] ?? 'Non renseigné'),
                        SizedBox(height: 20),

                        // Affichage de la photo de profil (si disponible)
                        _userData?['profile_picture'] != null
                            ? Image.network(_userData!['profile_picture'])
                            : CircleAvatar(radius: 50, child: Icon(Icons.person)),
                      ],
                    ),
                  ),
      ),
    );
  }

  // Méthode pour afficher une ligne avec une information
  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'Non renseigné'),
        ],
      ),
    );
  }
}
