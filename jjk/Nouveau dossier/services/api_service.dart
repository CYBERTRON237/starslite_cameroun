import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Remplace cette URL par l'URL de ton API backend
  static const String apiUrl = 'http://localhost/starslite_cameroune/api'; // Pour émulateur Android ou remplace par ton IP locale

  // Fonction pour envoyer les données de connexion (login)
  Future<Map<String, dynamic>> login(String email, String password) async {
    var url = Uri.parse('$apiUrl/login.php');
    print("Tentative de connexion avec l'email: $email");

    try {
      var response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      print("Réponse du serveur pour login: ${response.statusCode}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la connexion (StatusCode: ${response.statusCode})'
        };
      }
    } catch (e) {
      print("Erreur lors de la requête HTTP: $e");
      return {
        'success': false,
        'message': 'Erreur lors de la connexion : $e',
      };
    }
  }

  // Fonction pour envoyer les données d'inscription (register)
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
    var url = Uri.parse('$apiUrl/register.php');
    print("Tentative d'inscription avec l'email: $email");

    try {
      var response = await http.post(url, body: {
        'name': name,
        'email': email,
        'password': password,
        'number': number,
        'role': role,
        'region': region,
        'ville': ville,
        'agency_name': agencyName,
      });

      print("Réponse du serveur pour register: ${response.statusCode}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'inscription (StatusCode: ${response.statusCode})'
        };
      }
    } catch (e) {
      print("Erreur lors de la requête HTTP: $e");
      return {
        'success': false,
        'message': 'Erreur lors de l\'inscription : $e',
      };
    }
  }
}
