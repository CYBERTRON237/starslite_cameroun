import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos de l\'Agence'),
        backgroundColor: Colors.orange[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'À propos de l\'Agence',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'L\'Agence de Voyage Cameroun est spécialisée dans la gestion des déplacements entre les villes du Cameroun. Nous vous offrons un service rapide et fiable pour vos voyages en bus, que ce soit pour des trajets réguliers ou pour des voyages en groupe.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Nos Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1. Réservation de billets de bus.\n'
              '2. Organisation de voyages en groupe.\n'
              '3. Service de transport à la demande.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 40),
            _buildContactSection(),
            SizedBox(height: 40),
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  // Section de contact
  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contactez-nous',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange[700],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Adresse: Yaoundé, Cameroun\n'
          'Email: contact@voyage-cm.com\n'
          'Téléphone: +237 656 123 456',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Boutons de navigation
  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Retour à l'écran précédent
          },
          child: Text('Retour'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700], // Utilisation de backgroundColor au lieu de 'primary'
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
