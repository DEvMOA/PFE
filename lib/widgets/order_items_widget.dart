import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  final String name;
  final String image;
  final String price;
  int count;
  String commandId;
  String productId;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.count,
    required this.commandId,
    required this.productId,
  });

  void increment() {
    count++;
  }

  void decrement() {
    if (count > 1) {
      count--;
    }
  }
}

class OrderItemsWidget extends StatefulWidget {
  const OrderItemsWidget({super.key});

  @override
  State<OrderItemsWidget> createState() => _OrderItemsWidgetState();
}

class _OrderItemsWidgetState extends State<OrderItemsWidget> {
  List<Product> products = [];
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Commands')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('panier', isEqualTo: "true")
          .get();

      final List<Product> loadedProducts = [];

      for (final doc in snapshot.docs) {
        final productsSnapshot = await FirebaseFirestore.instance
            .collection('Commands')
            .doc(doc.id)
            .collection('Products')
            .get();

        for (final productDoc in productsSnapshot.docs) {
          final data = productDoc.data();
          final product = Product(
              name: data['name'],
              image: data['image'],
              price: data['price'],
              count: data['count'],
              commandId: doc.id,
              productId: productDoc.id);

          loadedProducts.add(product);
        }
      }

      setState(() {
        products = loadedProducts;
      });
    } catch (error) {
      //print('Error fetching products: $error');
    }
  }

  void updateProductCount(Product product, int newCount) async {
    try {
      await FirebaseFirestore.instance
          .collection('Commands')
          .doc(product.commandId)
          .collection('Products')
          .doc(product.productId)
          .update({'count': newCount});
    } catch (error) {
      //print('Error updating product count: $error');
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await FirebaseFirestore.instance
          .collection('Commands')
          .doc(product.commandId)
          .collection('Products')
          .doc(product.productId)
          .delete();
    } catch (error) {
      //print('Error deleting product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: Image.network(product.image),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(product.name),
              ),
            ),
          );
        });
  }
}
