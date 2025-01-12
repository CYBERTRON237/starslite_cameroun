import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // URL de base pour l'API
  final String _baseUrl = 'https://votre-api.com'; // Remplacez par l'URL réelle de ton API

  // Méthode pour obtenir les headers, y compris l'authentification
  Future<Map<String, String>> _getHeaders() async {
    String token = '<votre_token>'; // Remplacez par un vrai token d'authentification
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token'; // Si un token est disponible, ajouter l'header Authorization
    }
    return headers;
  }

  // Méthode pour s'inscrire
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
        Uri.parse('$_baseUrl/register'),
        headers: await _getHeaders(),
        body: json.encode({
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
        return jsonDecode(response.body); // Réponse réussie
      } else {
        return _handleError(response); // Gestion des erreurs
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription: ${e.toString()}');
    }
  }

  // Méthode pour se connecter
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: await _getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Réponse réussie
      } else {
        return _handleError(response); // Gestion des erreurs
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion: ${e.toString()}');
    }
  }

  // Méthode pour obtenir le profil utilisateur
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retourne les données du profil
      } else {
        return _handleError(response); // Gestion des erreurs
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du profil: ${e.toString()}');
    }
  }

  // Méthode pour mettre à jour le profil utilisateur
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String region,
    required String ville,
    required String agencyName,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/updateProfile'),
        headers: await _getHeaders(),
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'region': region,
          'ville': ville,
          'agencyName': agencyName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retourne les données mises à jour
      } else {
        return _handleError(response); // Gestion des erreurs
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil: ${e.toString()}');
    }
  }

  // Méthode pour gérer les erreurs HTTP
  Map<String, dynamic> _handleError(http.Response response) {
    String errorMessage = 'Erreur inconnue';
    try {
      final errorResponse = jsonDecode(response.body);
      errorMessage = errorResponse['message'] ?? errorMessage;
    } catch (e) {
      errorMessage = 'Erreur de communication avec le serveur';
    }

    if (response.statusCode == 400) {
      errorMessage = 'Données incorrectes : ${errorMessage}';
    } else if (response.statusCode == 401) {
      errorMessage = 'Non autorisé : ${errorMessage}';
    } else if (response.statusCode == 404) {
      errorMessage = 'Page non trouvée';
    } else if (response.statusCode == 500) {
      errorMessage = 'Erreur interne du serveur';
    }

    throw Exception(errorMessage); // Lancer une exception avec le message d'erreur
  }
}
