import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starslite_cameroune/user_management/screens/auth_screen.dart';
import 'package:starslite_cameroune/user_management/screens/profile_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Nouveau package pour vérifier la connexion

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isConnected = true; 
  bool _loading = true; 

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);

    _checkConnectivity();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Vérification de la connexion internet
  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      });
    } on SocketException catch (_) {
      setState(() {
        _isConnected = false;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Affichage de la boîte de dialogue pour l'authentification
  void _showAuthenticationDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AuthScreen(action: action),
    );
  }

  // Affichage de la boîte de dialogue pour l'édition du profil
  void _showProfileDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  // Widget pour afficher un message d'erreur de connexion
  Widget _buildConnectionStatus() {
    if (!_isConnected && !_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          color: Colors.red[100],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aucune connexion Internet. Certaines fonctionnalités peuvent être limitées.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.red),
                onPressed: _checkConnectivity,
              )
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  // AppBar personnalisée
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        color: Color(0xFF1A3D2A),
        child: Center(
          child: Text(
            'STARSLITE CAMEROUNE',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              color: Colors.white,
              fontFamily: 'Roboto',
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.greenAccent,
                  offset: Offset(3.0, 3.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Cartes d'options avec des actions
  Widget _buildOptionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildUserCard(
          context,
          icon: Icons.directions_bus,
          text: "Explorer les voyages",
          onPressed: () {
            // Action pour explorer les voyages
          },
        ),
        _buildUserCard(
          context,
          icon: Icons.book_online,
          text: "Voir mes réservations",
          onPressed: () {
            // Action pour voir les réservations
          },
        ),
      ],
    );
  }

  // Cartes de l'utilisateur pour chaque option
  Widget _buildUserCard(BuildContext context, {required IconData icon, required String text, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF1A3D2A)),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3D2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildWelcomeText(),
              SizedBox(height: 40),
              _buildAppDescription(),
              SizedBox(height: 40),
              _buildOptionsText(),
              SizedBox(height: 20),
              _buildOptionButtons(),
              SizedBox(height: 40),
              _buildConnectionStatus(),
              _buildAuthButtons(),
              SizedBox(height: 40),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // Texte de bienvenue
  Widget _buildWelcomeText() {
    return Center(
      child: Text(
        'Bienvenue sur l\'application de la société\nSTARSLITE CAMEROUNE',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF1A3D2A),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Description de l'application
  Widget _buildAppDescription() {
    return Text(
      'Accédez à vos voyages, gérez vos réservations et consultez les offres de voyages disponibles.',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: Colors.grey[700],
      ),
    );
  }

  // Footer de l'application
  Widget _buildFooter() {
    return Center(
      child: Text(
        '© 2024 StarsLite Cameroune - Tous droits réservés',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
