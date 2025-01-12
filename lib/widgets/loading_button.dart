import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String text;           // Texte à afficher sur le bouton
  final bool isLoading;        // Indicateur de chargement
  final VoidCallback onPressed; // Action à effectuer lors du clic

  // Constructeur pour initialiser le texte, l'état de chargement et l'action du bouton
  const LoadingButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Désactive le bouton pendant le chargement
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.blue, // Couleur personnalisée du bouton (peut être modifiée)
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Animation de chargement
            )
          : Text(
              text,
              style: TextStyle(
                color: Colors.white, // Couleur du texte
                fontSize: 16,
              ),
            ),
    );
  }
}
