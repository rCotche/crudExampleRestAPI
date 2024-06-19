import 'dart:convert';

import 'package:http/http.dart' as http;

///All todo api call here
class TodoService {
  static Future<bool> deleteById(String id) async {
    //remove from the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    //pas besoin du named argument header car on envoi rien
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    //check avec wether app si il y a pas un meilleur moyen de gerer
    //les liens
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    //pas besoin du named argument header car on envoi rien
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateToDo(String id, Map body) async {
    final editUrl = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(editUrl);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> addToDo(Map body) async {
    const insertUrl = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(insertUrl);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    //Attention le response.statusCode
    return response.statusCode == 201;
  }
}
