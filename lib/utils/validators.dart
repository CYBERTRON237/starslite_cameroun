import 'package:flutter/material.dart';

// Validation pour un email
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'L\'email est requis';
  }
  // Expression régulière pour valider l'email
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Veuillez entrer un email valide';
  }
  return null;
}

// Validation pour un mot de passe
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le mot de passe est requis';
  }
  if (value.length < 6) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
  }
  return null;
}

// Validation pour un numéro de téléphone
String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le numéro de téléphone est requis';
  }
  // Expression régulière pour valider le format du numéro de téléphone
  String pattern = r'^\+?[0-9]{10,15}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Veuillez entrer un numéro valide (format international)';
  }
  return null;
}

// Validation pour un champ de texte requis
String? validateRequiredField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ce champ est requis';
  }
  return null;
}

// Validation pour la confirmation du mot de passe
String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'La confirmation du mot de passe est requise';
  }
  if (value != password) {
    return 'Les mots de passe ne correspondent pas';
  }
  return null;
}

// Validation pour les champs de texte à longueur minimale
String? validateMinLength(String? value, int minLength) {
  if (value == null || value.isEmpty) {
    return 'Ce champ est requis';
  }
  if (value.length < minLength) {
    return 'Ce champ doit contenir au moins $minLength caractères';
  }
  return null;
}
