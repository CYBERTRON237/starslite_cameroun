import 'package:flutter/material.dart';

// Classe pour un bouton personnalisé
class CustomButton extends StatelessWidget {
  final String text;               // Texte à afficher sur le bouton
  final VoidCallback onPressed;     // Action lorsque le bouton est pressé
  final Color? color;               // Couleur du bouton
  final Color? textColor;           // Couleur du texte
  final double? borderRadius;       // Rayon de bordure pour arrondir les coins
  final double? height;             // Hauteur du bouton
  final double? width;              // Largeur du bouton
  final Icon? icon;                 // Icône à afficher sur le bouton (facultatif)
  final EdgeInsetsGeometry? padding; // Padding autour du texte ou de l'icône

  // Constructeur
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius,
    this.height,
    this.width,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,  // Si aucune largeur n'est spécifiée, le bouton prend toute la largeur disponible
      height: height ?? 50.0,           // Hauteur par défaut de 50 si aucune hauteur n'est spécifiée
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,  // Couleur par défaut du bouton
          foregroundColor: textColor ?? Colors.white,  // Couleur du texte
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),  // Arrondi des coins
          ),
        ),
        onPressed: onPressed,  // Action à effectuer lors du clic sur le bouton
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.0), // Padding autour du texte
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[  // Si une icône est fournie, l'ajouter au bouton
                icon!,
                SizedBox(width: 8.0), // Espace entre l'icône et le texte
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.white, // Couleur du texte
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
