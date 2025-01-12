import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Pour stocker de manière sécurisée

class AuthService {
  // URL de base pour l'API d'authentification
  static const String _baseUrl = "https://localhost/starslite_cameroune/";

  // Le stockage sécurisé pour garder les informations sensibles comme le token
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Méthode pour l'authentification des utilisateurs (login)
  Future<Map<String, dynamic>> login(Map<String, String> loginData) async {
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
        final data = jsonDecode(response.body);

        if (data['success']) {
          await _storage.write(key: 'auth_token', value: data['token']);
          return {'success': true, 'message': 'Connexion réussie'};
        } else {
          return {'success': false, 'message': data['message'] ?? 'Erreur de connexion'};
        }
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Erreur de connexion : ${data['message'] ?? 'Code : ${response.statusCode}'}'
        };
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Méthode pour l'inscription de l'utilisateur (register)
  Future<Map<String, dynamic>> register(Map<String, String> registerData) async {
    final String url = '$_baseUrl/register.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(registerData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        await _storage.write(key: 'auth_token', value: data['token']);
        return {'success': true, 'message': 'Inscription réussie'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Erreur lors de l\'inscription : ${data['message'] ?? 'Code : ${response.statusCode}'}'
        };
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Méthode pour vérifier si l'utilisateur est authentifié (vérification du token)
  Future<bool> isAuthenticated() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return false;
    }

    final String url = '$_baseUrl/validate_token.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Erreur lors de la validation du token: $e");
      return false;
    }
  }

  // Méthode pour se déconnecter (logout)
  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // Méthode pour récupérer le token d'authentification
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Méthode pour récupérer les informations de l'utilisateur authentifié
  Future<Map<String, dynamic>> getUserData() async {
    String? token = await getToken();

    if (token == null) {
      return {'success': false, 'message': 'Utilisateur non authentifié'};
    }

    final String url = '$_baseUrl/user_info.php';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des informations : ${data['message'] ?? 'Code : ${response.statusCode}'}'
        };
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }

  // Méthode pour mettre à jour les informations de l'utilisateur
  Future<Map<String, dynamic>> updateUserData(Map<String, String> updatedData) async {
    String? token = await getToken();

    if (token == null) {
      return {'success': false, 'message': 'Utilisateur non authentifié'};
    }

    final String url = '$_baseUrl/update_user_info.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour des informations : ${data['message'] ?? 'Code : ${response.statusCode}'}'
        };
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      return {
        'success': false,
        'message': 'Erreur de connexion. Veuillez vérifier votre connexion internet.'
      };
    }
  }
}
