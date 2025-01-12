import 'package:flutter/material.dart';

class ManagerDashboardScreen extends StatelessWidget {
  final String userName;
  final String userRole;
  final String userEmail;

  // Constructeur pour recevoir les informations de l'utilisateur
  ManagerDashboardScreen({required this.userName, required this.userRole, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Manager'),
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
              _buildStatsSection(),
              SizedBox(height: 30),
              _buildActionButtons(context),
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
          'Rôle: $userRole',
          style: TextStyle(fontSize: 18, color: Colors.orange[700]),
        ),
        SizedBox(height: 10),
        Text(
          'Email: $userEmail',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ],
    );
  }

  // Section de statistiques de gestion
  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques de gestion',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard('Total Réservations', '250'),
            _buildStatCard('Voyages Programmes', '12'),
            _buildStatCard('Voyages en Cours', '5'),
          ],
        ),
      ],
    );
  }

  // Carte pour afficher les statistiques
  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Boutons d'actions pour les différentes tâches
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/manage_trips');  // Gestion des voyages
          },
          child: Text('Gérer les Voyages'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/manage_bookings');  // Gestion des réservations
          },
          child: Text('Gérer les Réservations'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/manage_customers');  // Gestion des clients
          },
          child: Text('Gérer les Clients'),
        ),
      ],
    );
  }
}
