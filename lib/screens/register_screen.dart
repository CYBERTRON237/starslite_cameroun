import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _agencyNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  File? _profileImage;

  List<String> _roles = ['super_admin', 'admin', 'DG', 'chef_ville', 'chef_agence', 'user'];
  String _selectedRole = 'user';

  List<String> _regions = [
    'Adamaoua', 'Centre', 'Est', 'Littoral', 'Nord', 'Nord-Ouest', 'Ouest', 'Sud', 'Sud-Ouest', 'Extreme-Nord'
  ];
  String? _selectedRegion;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r"^[0-9]{9,15}$");
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    var uri = Uri.parse('http://localhost/starslite_cameroune/register.php');
    var request = http.MultipartRequest('POST', uri);

    // Ajout des champs de formulaire
    request.fields['name'] = _nameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['number'] = _phoneController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['role'] = _selectedRole;
    request.fields['region'] = _selectedRegion!;
    request.fields['ville'] = _villeController.text;
    request.fields['agency_name'] = _agencyNameController.text;
    request.fields['status'] = 'active';
    request.fields['is_verified'] = '0';
    request.fields['phone_verified'] = '0';
    request.fields['failed_login_attempts'] = '0';
    request.fields['account_locked'] = '0';
    request.fields['notifications_enabled'] = '1';
    request.fields['is_2fa_enabled'] = '0';
    request.fields['last_ip_address'] = '';  // Placeholder

    // Ajout de l'image si présente
    if (_profileImage != null) {
      var mimeType = lookupMimeType(_profileImage!.path);
      var file = await http.MultipartFile.fromPath(
        'profile_picture', _profileImage!.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );
      request.files.add(file);
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        setState(() {
          _isLoading = false;
        });

        // Afficher le message brut du serveur sans JSON
        setState(() {
          _errorMessage = responseBody;  // Le message brut de succès ou d'erreur
        });

        if (responseBody.contains('succès')) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur de connexion avec le serveur';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors de la requête: $e';
      });
      print("Erreur lors de la requête: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un compte'), backgroundColor: Colors.orange[600]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image de profil
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange[100],
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null ? Icon(Icons.add_a_photo, color: Colors.orange[800]) : null,
                  ),
                ),
                SizedBox(height: 16),

                // Champ Nom
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  validator: (value) => value!.isEmpty ? 'Le nom est requis' : null,
                ),
                SizedBox(height: 16),

                // Champ Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'L\'email est requis';
                    if (!_isValidEmail(value)) return 'Email invalide';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Champ Téléphone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Le numéro est requis';
                    if (!_isValidPhone(value)) return 'Numéro invalide';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Le mot de passe est requis';
                    if (!_isValidPassword(value)) return 'Le mot de passe doit avoir au moins 6 caractères';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Dropdown Région
                DropdownButtonFormField<String>(
                  value: _selectedRegion,
                  hint: Text("Sélectionner une région"),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRegion = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'La région est requise' : null,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  items: _regions.map<DropdownMenuItem<String>>((String region) {
                    return DropdownMenuItem<String>(
                      value: region,
                      child: Text(region),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Champ Ville
                TextFormField(
                  controller: _villeController,
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 16),

                // Champ Nom de l'agence
                TextFormField(
                  controller: _agencyNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom de l\'agence',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 16),

                // Dropdown Rôle
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: _roles.map<DropdownMenuItem<String>>((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 16),

                // Bouton d'enregistrement
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _createAccount,
                        child: Text('Créer un compte'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                        ),
                      ),
                SizedBox(height: 16),

                // Message d'erreur si nécessaire
                if (_errorMessage.isNotEmpty)
                  Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
