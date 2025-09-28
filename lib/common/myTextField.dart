import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType; // New optional property

  const Mytextfield({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType, // Included in constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType, // Applied here
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black), // Styling the hint
        
        // Added content padding for better spacing
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),

        // --- Enabled Border (Not focused) ---
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),

        // --- Focused Border (When active) ---
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // Use a prominent color and slightly thicker border for focus
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor, // Use a theme color or a custom one
            width: 2.0,
          ),
        ),

        // --- Default/Error Border ---
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
    );
  }
}