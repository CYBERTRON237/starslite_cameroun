import 'package:flutter/material.dart';

class UserDashboardScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  // Constructeur pour recevoir les informations de l'utilisateur
  UserDashboardScreen({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Utilisateur'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Logique pour se déconnecter
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWelcomeSection(),
              SizedBox(height: 30),
              _buildUserActions(context),
              SizedBox(height: 30),
              _buildUserInfo(),
            ],
          ),
        ),
      ),
    );
  }

  // Section de bienvenue avec les informations de l'utilisateur
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenue, $userName',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Email: $userEmail',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ],
    );
  }

  // Section des actions utilisateur
  Widget _buildUserActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions disponibles',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/view_bookings');  // Voir les réservations
          },
          child: Text('Voir mes Réservations'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/manage_profile');  // Gérer le profil
          },
          child: Text('Gérer mon Profil'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/search_trips');  // Chercher des voyages
          },
          child: Text('Chercher des Voyages'),
        ),
      ],
    );
  }

  // Afficher des informations de l'utilisateur
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations personnelles',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildUserInfoCard('Nom:', userName),
        _buildUserInfoCard('Email:', userEmail),
      ],
    );
  }

  // Carte pour afficher les informations utilisateur
  Widget _buildUserInfoCard(String title, String value) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
