import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  // 🟢 LOCAL BASE URL (For PC)
  static const String baseUrl = "http://127.0.0.1:8080";
  // 📱 If using Android Emulator, uncomment this instead:
  // static const String baseUrl = "http://10.0.2.2:8000";
  // 📱 If using physical device, use your PC IP like:
  // static const String baseUrl = "http://192.168.x.x:8000";

  // 🔹 Fetch all items
  Future<List<Item>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/items'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        print("❌ Fetch failed: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("⚠️ Error fetching items: $e");
      return [];
    }
  }

  // 🔹 Add a new item
  Future<bool> addItem(Item item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("❌ Failed to add item: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error adding item: $e");
      return false;
    }
  }

  // 🔹 Update an existing item
  Future<bool> updateItem(Item item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/items/${item.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
          "❌ Failed to update item: ${response.statusCode} ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("⚠️ Error updating item: $e");
      return false;
    }
  }

  // 🔹 Delete an item
  Future<bool> deleteItem(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/items/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
          "❌ Failed to delete item: ${response.statusCode} ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("⚠️ Error deleting item: $e");
      return false;
    }
  }
}
