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
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
          style: TextStyle(fontFamily: 'Cursive', fontSize: 24),
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
            if (isMenuVisible)
              _buildSettingsMenu(),
            _buildSection(
              title: "Gérer les Directeurs",
              description: "Gérez les directeurs de l'organisation.",
              onTap: () {
                // Navigate to "Gérer les Directeurs" page
              },
            ),
            _buildSection(
              title: "Gérer les Chefs de Ville",
              description: "Gérez les chefs de ville de l'organisation.",
              onTap: () {
                // Navigate to "Gérer les Chefs de Ville" page
              },
            ),
            _buildSection(
              title: "Gérer les Chefs d'Agences",
              description: "Gérez les chefs d'agences de l'organisation.",
              onTap: () {
                // Navigate to "Gérer les Chefs d'Agences" page
              },
            ),
            _buildSection(
              title: "Gérer les Utilisateurs",
              description: "Gérez les utilisateurs et leurs permissions.",
              onTap: () {
                // Navigate to "Gérer les Utilisateurs" page
              },
            ),
            _buildSection(
              title: "Liste des Agences",
              description: "Voir la liste des agences disponibles.",
              onTap: () {
                // Navigate to "Liste des Agences" page
              },
            ),
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

  Widget _buildSection({required String title, required String description, required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
