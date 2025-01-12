import 'package:flutter/material.dart';
import 'package:starslite_cameroune/services/auth_service.dart'; // Service d'authentification pour récupérer les infos de l'utilisateur
import 'package:starslite_cameroune/screens/profile_screen.dart'; // Import du fichier profile_screen.dart

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  String _userProfilePic = ''; // Image de profil
  String _role = ''; // Rôle de l'utilisateur
  Map<String, dynamic> _userData = {}; // Stockage des données de l'utilisateur

  @override
  void initState() {
    super.initState();
    // Charger les données de l'utilisateur, comme l'image de profil et le rôle, via le service d'authentification
    _loadUserData();
  }

  // Fonction pour récupérer les données de l'utilisateur (image de profil et rôle)
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les informations de l'utilisateur via le service d'authentification
      var user = await AuthService().getUserData(); // Appel de la méthode sur une instance d'AuthService
      setState(() {
        _userData = user; // Stocker les données de l'utilisateur
        _userProfilePic = user['profile_picture'] ?? ''; // Si l'image de profil est disponible
        _role = user['role'] ?? ''; // Récupérer le rôle de l'utilisateur
      });
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour déconnecter l'utilisateur
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Logique de déconnexion ici
      await AuthService.logout();  // Appel du service de déconnexion
      Navigator.pushReplacementNamed(context, '/login'); // Redirection vers la page de connexion après la déconnexion
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour afficher l'interface en fonction du rôle
  Widget _getDashboardForRole(String role) {
    switch (role) {
      case 'super_admin':
        return _buildSuperAdminDashboard();
      case 'admin':
        return _buildAdminDashboard();
      case 'DG':
        return _buildDGDashboard();
      case 'chef_ville':
        return _buildChefVilleDashboard();
      case 'chef_agence':
        return _buildChefAgenceDashboard();
      case 'user':
        return _buildUserDashboard();
      default:
        return _buildUnknownRoleDashboard();
    }
  }

  // Dashboard pour Super Admin
  Widget _buildSuperAdminDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.supervised_user_circle, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Bienvenue Super Admin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Dashboard pour Admin
  Widget _buildAdminDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Bienvenue Admin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Dashboard pour Directeur Général (DG)
  Widget _buildDGDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 100, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'Bienvenue Directeur Général',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Dashboard pour Chef Ville
  Widget _buildChefVilleDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_city, size: 100, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            'Bienvenue Chef Ville',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Dashboard pour Chef Agence
  Widget _buildChefAgenceDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 100, color: Colors.teal),
          SizedBox(height: 20),
          Text(
            'Bienvenue Chef Agence',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Dashboard pour utilisateur classique
  Widget _buildUserDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Bienvenue Utilisateur',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Si le rôle est inconnu ou non défini
  Widget _buildUnknownRoleDashboard() {
    return Center(
      child: Text(
        'Rôle non reconnu',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        actions: [
          // Icône de déconnexion
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Contenu de la page : fond blanc avec un texte minimal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator() // Afficher un indicateur de chargement si les données sont en cours de récupération
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Afficher le rôle en grand et en haut
                        Text(
                          _role.toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Affichage des informations de l'utilisateur
                        CircleAvatar(
                          radius: 40, // Taille moyenne pour la photo de profil
                          backgroundImage: NetworkImage(
                            _userProfilePic.isEmpty
                                ? 'https://via.placeholder.com/150'
                                : _userProfilePic, // Utiliser l'image de profil ou une image par défaut
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Nom: ${_userData['name'] ?? 'Inconnu'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Email: ${_userData['email'] ?? 'Inconnu'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Région: ${_userData['region'] ?? 'Inconnue'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Ville: ${_userData['ville'] ?? 'Inconnue'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Agence: ${_userData['agency_name'] ?? 'Inconnue'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        // Affichage de l'interface spécifique au rôle
                        Expanded(child: _getDashboardForRole(_role)),
                      ],
                    ),
            ),
          ),

          // Cercle avec l'image de profil positionné en haut à droite
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Vous pouvez ajouter une action ici si l'utilisateur souhaite changer l'image
                // L'image est statique ici mais vous pouvez ajouter une logique pour changer l'image
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40, // Taille moyenne pour la photo de profil
                    backgroundImage: NetworkImage(
                      _userProfilePic.isEmpty
                          ? 'https://via.placeholder.com/150'
                          : _userProfilePic, // Utiliser l'image de profil ou une image par défaut
                    ),
                  ),
                  SizedBox(height: 8),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Rediriger vers la page de gestion du profil
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
