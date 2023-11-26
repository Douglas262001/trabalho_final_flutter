import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class APIService {
  final String baseUrl = 'http://10.0.2.2:8080/users';

   Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<User> users = data.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Falhou para carregar usuário');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falhou para criar usuário');
    }
  }

  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falhou para atualizar o usuário');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Falhou para deletar usuário');
    }
  }
}
