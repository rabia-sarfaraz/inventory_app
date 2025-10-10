import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;
  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final ApiService api = ApiService();
  final _formKey = GlobalKey<FormState>();

  late String name;
  late int quantity;
  late double price;

  @override
  void initState() {
    super.initState();
    name = widget.item.name;
    quantity = widget.item.quantity;
    price = widget.item.price;
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedItem = Item(
        id: widget.item.id,
        name: name,
        quantity: quantity,
        price: price,
      );

      final success = await api.updateItem(updatedItem);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Item updated successfully!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Failed to update item.")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4169E1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => name = val!,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter item name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: quantity.toString(),
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty
                    ? "Enter quantity"
                    : int.tryParse(val) == null
                    ? "Enter valid number"
                    : null,
                onSaved: (val) => quantity = int.parse(val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty
                    ? "Enter price"
                    : double.tryParse(val) == null
                    ? "Enter valid price"
                    : null,
                onSaved: (val) => price = double.parse(val!),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4169E1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: _updateItem,
                child: const Text(
                  "Update Item",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
