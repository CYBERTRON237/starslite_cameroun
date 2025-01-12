import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STARSLITE CAMEROUN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DgDashboard(),
    );
  }
}

class DgDashboard extends StatefulWidget {
  @override
  _DgDashboardState createState() => _DgDashboardState();
}

class _DgDashboardState extends State<DgDashboard> {
  bool isDarkMode = false;
  bool isMenuVisible = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleMenu() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'STARSLITE CAMEROUN',
          style: TextStyle(
            fontFamily: 'Cursive',
            fontSize: 24,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: toggleMenu,
          ),
        ],
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMenuVisible) _buildSettingsMenu(),
            _buildWelcomeSection(),
            _buildNavigationLinks(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleTheme,
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem('Mode Sombre', toggleTheme),
          _buildMenuItem('Changer de langue', () {}),
          _buildMenuItem('Gestion des notifications', () {}),
          _buildMenuItem('Profil', () {}),
          _buildMenuItem('Déconnexion', () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text, VoidCallback onTap) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue dans la page D\'administration du Directeur Général',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '😊 Explorez les meilleures destinations, réservez vos voyages et créez des souvenirs inoubliables.',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Nous sommes là pour vous aider à chaque étape de votre aventure.',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationLinks() {
    return Expanded(
      child: ListView(
        children: [
          _buildNavigationLink(
            'Gérer les Chefs d\'Agence',
            'http://localhost/starslite_cameroune/administrateurs/chefs_agence/manage_chef_agence.php',
          ),
          _buildNavigationLink(
            'Gérer les Utilisateurs',
            'http://localhost/starslite_cameroune/administrateurs/users/manage_users.php',
          ),
          _buildNavigationLink(
            'Gérer les Agences de la région de l\'ouest',
            'http://localhost/starslite_cameroune/stars_lite_agence_ouest/module0_starslite_ouest_management%20c/accuiel.php',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationLink(String text, String url) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        onTap: () {
          // Navigate to the respective link (you can use a webview or browser package in Flutter)
          print("Navigating to $url");
        },
      ),
    );
  }
}
