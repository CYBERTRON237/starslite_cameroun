import 'dart:convert';
import 'dart:io'; // Pour la gestion des erreurs de type SocketException
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Remplacez par l'URL de votre API
const String apiUrl = 'https://votre-api.com/api';

class AuthService {
  // Fonction pour l'inscription
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String number,
    required String role,
    required String region,
    required String ville,
    required String agencyName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'), // L'URL de votre endpoint d'inscription
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'number': number,
          'role': role,
          'region': region,
          'ville': ville,
          'agencyName': agencyName,
        }),
      );

      if (response.statusCode == 200) {
        // Réponse de succès
        return {'success': true, 'message': 'Inscription réussie!'};
      } else {
        return _handleApiError(response); // Gestion des erreurs HTTP
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // Fonction pour la connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'), // L'URL de votre endpoint de connexion
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Sauvegarder le token d'authentification dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return {'success': true, 'message': 'Connexion réussie!'};
      } else {
        return _handleApiError(response); // Gestion des erreurs HTTP
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // Fonction pour récupérer le profil de l'utilisateur
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // Récupérer le token

      if (token == null) {
        return {'success': false, 'message': 'Utilisateur non authentifié'};
      }

      final response = await http.get(
        Uri.parse('$apiUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token', // Ajouter le token dans l'en-tête
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retourne les données du profil
      } else {
        return _handleApiError(response); // Gestion des erreurs HTTP
      }
    } catch (e) {
      if (e is SocketException) {
        return {'success': false, 'message': 'Erreur de connexion au serveur, veuillez vérifier votre connexion Internet'};
      }
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // Fonction pour se déconnecter
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token'); // Supprimer le token de l'authentification
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  // Méthode pour gérer les erreurs de l'API
  Map<String, dynamic> _handleApiError(http.Response response) {
    String errorMessage = 'Erreur inconnue';
    try {
      final errorResponse = jsonDecode(response.body);
      errorMessage = errorResponse['message'] ?? errorMessage;
    } catch (e) {
      errorMessage = 'Erreur de communication avec le serveur';
    }

    // Gestion des erreurs en fonction du code HTTP
    if (response.statusCode == 400) {
      errorMessage = 'Données incorrectes : $errorMessage';
    } else if (response.statusCode == 401) {
      errorMessage = 'Non autorisé : $errorMessage';
    } else if (response.statusCode == 404) {
      errorMessage = 'Page non trouvée';
    } else if (response.statusCode == 500) {
      errorMessage = 'Erreur interne du serveur';
    }

    return {'success': false, 'message': errorMessage};
  }

  // Fonction pour vérifier si un utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  // Fonction pour récupérer un token valide
  Future<String?> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return null;
    }

    // Ajoutez une logique pour valider le token ici si nécessaire (par exemple, vérification d'expiration)
    return token;
  }
}
