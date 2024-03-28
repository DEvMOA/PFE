import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextStyle() {
    return const TextStyle(
        fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20.0);
  }

  static TextField searchBar() {
    return const TextField(
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search",
        contentPadding: EdgeInsets.symmetric(vertical: 3),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  static Container cartIcon() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
    );
  }
}
