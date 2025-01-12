import 'package:flutter/material.dart';
import 'package:starslite_cameroune/user_management/services/api_service.dart'; // Assurez-vous d'avoir votre service API correctement configuré

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isUpdating = false;
  Map<String, dynamic> _userData = {};
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Appel pour récupérer les données utilisateur
  }

  // Fonction pour récupérer les données de l'utilisateur
  Future<void> _fetchUserData() async {
    try {
      final response = await _apiService.getProfile();
      if (response != null && response['success']) {
        setState(() {
          _userData = response['data'];
        });
      } else {
        _setErrorState(response['message']);
      }
    } catch (e) {
      _setErrorState('Erreur lors de la récupération des données : $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour mettre à jour les informations de l'utilisateur
  Future<void> _updateProfile(Map<String, dynamic> updatedData) async {
    if (_isUpdating) return; // Eviter les mises à jour multiples en même temps

    setState(() {
      _isUpdating = true;
      _statusMessage = '';
    });

    try {
      final response = await _apiService.updateProfile(updatedData);
      if (response != null && response['success']) {
        setState(() {
          _statusMessage = 'Profil mis à jour avec succès!';
          _userData = response['data']; // Mettre à jour les données utilisateur
        });
      } else {
        _setErrorState(response['message']);
      }
    } catch (e) {
      _setErrorState('Erreur lors de la mise à jour du profil : $e');
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  // Fonction pour gérer les erreurs et afficher un message d'erreur
  void _setErrorState(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Color(0xFF006400), // Vert émeraude foncé
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (_statusMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _statusMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    _buildProfileField('Nom', _userData['name'] ?? 'Non défini', (value) {
                      _userData['name'] = value;
                    }),
                    _buildProfileField('Email', _userData['email'] ?? 'Non défini', (value) {
                      _userData['email'] = value;
                    }),
                    _buildProfileField('Numéro', _userData['number'] ?? 'Non défini', (value) {
                      _userData['number'] = value;
                    }),
                    _buildProfileField('Région', _userData['region'] ?? 'Non défini', (value) {
                      _userData['region'] = value;
                    }),
                    _buildProfileField('Ville', _userData['ville'] ?? 'Non défini', (value) {
                      _userData['ville'] = value;
                    }),
                    _buildProfileField('Nom de l\'agence', _userData['agencyName'] ?? 'Non défini', (value) {
                      _userData['agencyName'] = value;
                    }),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isUpdating ? null : () {
                        _updateProfile(_userData); // Appel pour mettre à jour le profil
                      },
                      child: _isUpdating
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Mettre à jour le profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFA500), // Couleur orange
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Méthode pour construire un champ de profil avec un label et une valeur initiale
  Widget _buildProfileField(String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged, // Mise à jour de la valeur dans _userData
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
