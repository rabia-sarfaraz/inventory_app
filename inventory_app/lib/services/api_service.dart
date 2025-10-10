import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  // 🟢 For web or running on same PC as FastAPI:
  static const String baseUrl = "http://127.0.0.1:8000";

  // 🟢 If running on Android Emulator, use this instead:
  // static const String baseUrl = "http://10.0.2.2:8000";

  // 🔹 Fetch all items
  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load items");
    }
  }

  // 🔹 Add new item
  Future<bool> addItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("❌ Failed to add item: ${response.statusCode} ${response.body}");
      return false;
    }
  }

  // 🔹 Update existing item
  Future<bool> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print("❌ Failed to update item: ${response.statusCode} ${response.body}");
      return false;
    }
  }

  // 🔹 Delete item
  Future<bool> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/items/$id'));
    if (response.statusCode == 200) {
      return true;
    } else {
      print("❌ Failed to delete item: ${response.statusCode}");
      return false;
    }
  }
}
