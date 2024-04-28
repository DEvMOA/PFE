import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:magani_shop/widgets/items_number_widget.dart';
import 'package:provider/provider.dart';

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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> products = [];
  double totalPrice = 0;
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
        totalPrice = getTotalPrice(products);
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

  double getTotalPrice(List<Product> products) {
    double totalPrice = 0.0;
    for (final product in products) {
      totalPrice += (product.count * double.parse(product.price));
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Panier'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Slidable(
                    startActionPane:
                        ActionPane(motion: const BehindMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          setState(() {
                            deleteProduct(product);
                            if (products.isNotEmpty &&
                                index < products.length) {
                              products.removeAt(index);
                            }
                            Provider.of<ItemsNumber>(context, listen: false)
                                .getProductsNumber();
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: Colors.red,
                        icon: Icons.delete_outline,
                      ),
                    ]),
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: Image.network(product.image),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(product.name),
                          ),
                          subtitle: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    product.decrement();
                                    updateProductCount(product, product.count);
                                    totalPrice = getTotalPrice(products);
                                  });
                                  Provider.of<ItemsNumber>(context,
                                          listen: false)
                                      .getProductsNumber();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text('${product.count}'),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    product.increment();
                                    updateProductCount(product, product.count);
                                    totalPrice = getTotalPrice(products);
                                  });

                                  Provider.of<ItemsNumber>(context,
                                          listen: false)
                                      .getProductsNumber();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                              '${(product.count * double.parse(product.price)).toStringAsFixed(2)} FCFA'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Consumer<ItemsNumber>(builder: (context, itemsNumber, child) {
              return itemsNumber.items == 0
                  ? const Center()
                  : Padding(
                      padding: const EdgeInsets.only(
                          bottom: 50, left: 15, right: 15),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtotal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(totalPrice.toStringAsFixed(2)),
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    );
            }),
          ],
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ('/checkoutScreen'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )))));
  }
}
