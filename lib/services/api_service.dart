import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Base URL de votre API (à adapter en fonction de votre backend)
  static const String _baseUrl = "http://localhost/starslite_cameroune/"; // Remplacez ceci par votre URL réelle

  // Le stockage sécurisé pour récupérer le token
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Méthode pour mettre à jour le profil utilisateur
  static Future<Map<String, dynamic>> updateProfile(Map<String, String> updatedData, String token) async {
    // L'URL de la route de mise à jour du profil
    final String url = '$_baseUrl/update_profile.php';

    try {
      // Envoi de la requête HTTP de type POST pour mettre à jour le profil
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Spécifier que le contenu est en JSON
          'Authorization': 'Bearer $token', // Ajouter un token d'autorisation dans les headers
        },
        body: jsonEncode(updatedData), // Envoi des données en format JSON
      );

      // Si la requête a réussi (status code 200)
      if (response.statusCode == 200) {
        // Si la mise à jour est réussie, on retourne les données de la réponse
        return jsonDecode(response.body); // La réponse de l'API, souvent un JSON
      } else {
        // Si la requête échoue, on retourne un message d'erreur
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour du profil: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Gestion des erreurs (par exemple, perte de connexion)
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Exemple de méthode pour récupérer les informations du profil
  static Future<Map<String, dynamic>> getProfile(String token) async {
    final String url = '$_baseUrl/get_profile.php';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Utilisation du token pour l'autorisation
        },
      );

      if (response.statusCode == 200) {
        // Retourner les données de l'utilisateur depuis la réponse
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des informations du profil: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Gestion des erreurs
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Exemple de méthode pour s'authentifier (login)
  static Future<Map<String, dynamic>> login(Map<String, String> loginData) async {
    final String url = '$_baseUrl/login.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retourne les données de l'API (ex: token d'authentification)
      } else {
        return {
          'success': false,
          'message': 'Erreur de connexion: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Gestion des erreurs
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Méthode pour se déconnecter (logout)
  static Future<Map<String, dynamic>> logout(String token) async {
    final String url = '$_baseUrl/logout.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Utilisation du token pour l'autorisation
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retourne une réponse indiquant la réussite de la déconnexion
      } else {
        return {
          'success': false,
          'message': 'Erreur de déconnexion: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Gestion des erreurs
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Méthode pour récupérer le token d'authentification
  Future<String?> getToken() async {
    // Retourne le token actuellement stocké dans le stockage sécurisé
    return await _storage.read(key: 'auth_token');
  }

  // Méthode pour stocker un token d'authentification
  Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Méthode pour supprimer un token d'authentification
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
