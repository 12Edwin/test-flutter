// lib/repositories/auto_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Auto.dart';

class AutoRepository {
  final String baseUrl = 'https://ljyr4dd446.execute-api.us-east-1.amazonaws.com/Prod/test';

  Future<List<Auto>> getAutos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> autosJson = json.decode(response.body)['data'];
      return autosJson.map((json) => Auto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load autos');
    }
  }

  Future<Auto> createAuto(Auto auto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(auto.toJson()),
    );

    if (response.statusCode == 200) {
      return new Auto(id: 0, marca: auto.marca, modelo: auto.modelo, autonomiaElectrica: auto.autonomiaElectrica, consumoCombustible: auto.consumoCombustible);
    } else {
      throw Exception('Failed to create auto');
    }
  }

  Future<Auto> updateAuto(Auto auto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${auto.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(auto.toJson()),
    );

    if (response.statusCode == 200) {
      return new Auto(id: auto.id, marca: auto.marca, modelo: auto.modelo, autonomiaElectrica: auto.autonomiaElectrica, consumoCombustible: auto.consumoCombustible);
    } else {
      throw Exception('Failed to update auto');
    }
  }

  Future<void> deleteAuto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete auto');
    }
  }
}