import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Import du fichier profile_screen.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STARSLITE CAMEROUN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Configuration du thème pour l'application
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent, // Couleur de la barre d'applications
          iconTheme: IconThemeData(color: Colors.white), // Icônes de la barre d'applications en blanc
        ),
        scaffoldBackgroundColor: Colors.white, // Fond général de l'application
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
          titleMedium: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        cardColor: Colors.grey[100], // Couleur des cartes dans l'application
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        cardColor: Colors.grey[800],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: SuperAdminDashboard(),
    );
  }
}

class SuperAdminDashboard extends StatefulWidget {
  @override
  _SuperAdminDashboardState createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  bool isMenuVisible = false;

  // Toggle pour ouvrir ou fermer le menu
  void toggleMenu() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  // Fonction de déconnexion
  void logout() {
    // Logique de déconnexion
    print('Utilisateur déconnecté');
    // Retour à l'écran de connexion
    Navigator.of(context).pushReplacementNamed('/login');
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
            icon: Icon(Icons.settings),
            onPressed: toggleMenu,
          ),
        ],
      ),
      body: SingleChildScrollView(  // Utilisation de SingleChildScrollView pour éviter le débordement
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMenuVisible) _buildSettingsMenu(),
              _buildProfileHeader(),
              _buildSection(
                title: "Gestion des Agences",
                description: "Gérez toutes les agences et leurs informations.",
                onTap: () {},
              ),
              _buildSection(
                title: "Gestion des Administrateurs",
                description: "Gérez les administrateurs de l'organisation.",
                onTap: () {},
              ),
              _buildSection(
                title: "Gérer les Directeurs",
                description: "Gérez les directeurs de l'organisation.",
                onTap: () {},
              ),
              _buildSection(
                title: "Gérer les Chefs de Ville",
                description: "Gérez les chefs de ville de l'organisation.",
                onTap: () {},
              ),
              _buildSection(
                title: "Gérer les Chefs d'Agences",
                description: "Gérez les chefs d'agences de l'organisation.",
                onTap: () {},
              ),
              _buildSection(
                title: "Accès des Agences",
                description: "Accédez aux agences disponibles.",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menu des paramètres
  Widget _buildSettingsMenu() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem('Profil', () {
            // Navigation vers la page Profil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }),
          _buildMenuItem('Déconnexion', logout),
        ],
      ),
    );
  }

  // Fonction pour construire chaque élément du menu
  Widget _buildMenuItem(String text, VoidCallback onTap) {
    return ListTile(
      title: Text(text, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      onTap: onTap,
    );
  }

  // Header de profil avec l'image de profil
  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Image du profil (cercle)
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://example.com/user-profile.jpg'), // Remplacez par l'URL réelle de l'image
        ),
        SizedBox(width: 15),
        // Informations de l'utilisateur
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom de l\'Utilisateur', // Remplacez par le nom réel
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              'Utilisateur StarSLite',
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ],
        ),
      ],
    );
  }

  // Fonction pour construire une section de la page d'accueil
  Widget _buildSection({required String title, required String description, required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(description, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        trailing: Icon(Icons.arrow_forward, color: Theme.of(context).iconTheme.color),
        onTap: onTap,
      ),
    );
  }
}
