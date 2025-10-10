import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ApiService api = ApiService();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  int quantity = 0;
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item", style: TextStyle(color: Colors.white)),
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
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter item name" : null,
                onSaved: (val) => name = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await api.addItem(
                      Item(id: 0, name: name, quantity: quantity, price: price),
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Add Item",
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
