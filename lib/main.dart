import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/about_screen.dart';
import 'screens/super_admin_dashboard.dart';  // Import pour le dashboard Super Admin
import 'screens/admin_dashboard.dart';       // Import pour le dashboard Admin
import 'screens/dg_dashboard.dart';          // Import pour le dashboard DG
import 'screens/chef_ville_dashboard.dart';  // Import pour le dashboard Chef Ville
import 'screens/chef_agence_dashboard.dart'; // Import pour le dashboard Chef Agence
import 'screens/user_dashboard.dart';       // Assurez-vous que cette classe existe et est correctement importée
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  Locale _locale = Locale('fr', 'CM'); // Par défaut, la langue est le français (Cameroun)

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestionnaire Agence de Voyage Cameroun',
      theme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
        ).copyWith(secondary: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.orange[900]),
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        appBarTheme: AppBarTheme(
          elevation: 4,
          color: Colors.orange[800],
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.orange[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.orange[700]!),
          ),
          labelStyle: TextStyle(color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
        appBarTheme: AppBarTheme(
          elevation: 4,
          color: Colors.orange[800],
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: _locale,
      supportedLocales: [
        Locale('fr', 'CM'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              toggleTheme: _toggleTheme,
              changeLanguage: _changeLanguage,
              locale: _locale,
              isDarkMode: _isDarkMode, // Pass the state here
            ),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/about': (context) => AboutScreen(),
        '/super_admin_dashboard': (context) => SuperAdminDashboard(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/dg_dashboard': (context) => DgDashboard(),
        '/chef_ville_dashboard': (context) => ChefVilleDashboard(),
        '/chef_agence_dashboard': (context) => ChefAgenceDashboard(),
        '/user_dashboard': (context) => UserDashboard(), // Assurez-vous que cette classe est définie et importée correctement
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Function toggleTheme;
  final Function changeLanguage;
  final Locale locale;
  final bool isDarkMode;

  HomeScreen({
    required this.toggleTheme,
    required this.changeLanguage,
    required this.locale,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionnaire de Voyages Cameroun'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildAboutAgencySection(context),
              SizedBox(height: 30),
              _buildSectionTitle(context, 'Gestion des destinations'),
              SizedBox(height: 20),
              _buildAnimatedSection(
                context,
                'Ajouter ou modifier des destinations',
                _buildCitySelection(),
              ),
              SizedBox(height: 40),
              _buildSectionTitle(context, 'Gestion des Services de Bus'),
              SizedBox(height: 20),
              _buildServiceGrid(context),
              SizedBox(height: 40),
              _buildNavigationButtons(context),
              SizedBox(height: 40),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22),
    );
  }

  Widget _buildAboutAgencySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'À propos de l\'Agence',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'L\'Agence de Voyage Cameroun est spécialisée dans la gestion des déplacements entre les villes du Cameroun. Nous vous offrons un service rapide et fiable pour vos voyages en bus.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/about');
          },
          child: Text('En savoir plus sur l\'agence'),
        ),
      ],
    );
  }

  Widget _buildCitySelection() {
    List<String> cities = [
      'Douala', 'Yaoundé', 'Bamenda', 'Dschang', 'Bafoussam', 'Limbe', 'Kribi',
    ];
    return Column(
      children: cities.map((city) {
        return ListTile(
          title: Text(city),
          leading: Icon(Icons.place),
        );
      }).toList(),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.4,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getServiceIcon(index),
                  size: 50,
                  color: Colors.orange[700],
                ),
                SizedBox(height: 12),
                Text(
                  _getServiceTitle(index),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getServiceIcon(int index) {
    switch (index) {
      case 0:
        return Icons.directions_bus;
      case 1:
        return Icons.account_balance;
      case 2:
        return Icons.local_activity;
      case 3:
        return Icons.place;
      default:
        return Icons.help;
    }
  }

  String _getServiceTitle(int index) {
    switch (index) {
      case 0:
        return 'Réservation de billets';
      case 1:
        return 'Voyages en Bus';
      case 2:
        return 'Voyages en Groupe';
      case 3:
        return 'Services à la demande';
      default:
        return 'Service';
    }
  }

  Widget _buildAnimatedSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title),
        SizedBox(height: 10),
        AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 800),
          child: content,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text('Créer un compte Gestionnaire'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text('Se connecter en tant que gestionnaire'),
        ),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Paramètres'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text('Mode Sombre'),
                value: isDarkMode,
                onChanged: (value) {
                  toggleTheme();
                },
              ),
              ListTile(
                title: Text('Changer la langue'),
                trailing: Icon(Icons.language),
                onTap: () {
                  changeLanguage(locale.languageCode == 'fr'
                      ? Locale('en', 'US')
                      : Locale('fr', 'CM'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(
          '© 2025 Agence de Voyage  Cameroun. Tous droits réservés.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}
