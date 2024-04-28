import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemsNumber extends ChangeNotifier {
  int _items = 0;
  int total = 0;
  int get items => _items;

  Future<void> getProductsNumber() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Commands')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('panier', isEqualTo: "true")
          .get();

      for (final doc in snapshot.docs) {
        final productsSnapshot = await FirebaseFirestore.instance
            .collection('Commands')
            .doc(doc.id)
            .collection('Products')
            .get();

        for (final productDoc in productsSnapshot.docs) {
          final data = productDoc.data();
          final count = data['count'] as int;
          total += count;
        }
      }
      _items = total;
      total = 0;
      notifyListeners();
    } catch (error) {
      //print('Error fetching products number: $error');
    }
  }
}
