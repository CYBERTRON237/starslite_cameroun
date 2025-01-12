import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  // Toggle the theme between dark and light mode
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    // Affichage d'un message indiquant que le mode a changé
    final theme = _isDarkMode ? 'Sombre' : 'Clair';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mode $theme activé')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Paramètres'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paramètres de l\'application',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text(
                  'Mode ${_isDarkMode ? 'Sombre' : 'Clair'}',
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                ),
                value: _isDarkMode,
                onChanged: (bool value) {
                  _toggleTheme();
                },
              ),
              // Vous pouvez ajouter d'autres options de paramètres ici
            ],
          ),
        ),
      ),
    );
  }
}
