import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magani_shop/widgets/items_number_widget.dart';
import 'package:provider/provider.dart';

class MedicineDetailScreen extends StatefulWidget {
  final String image, name, detail, price;
  const MedicineDetailScreen({
    super.key,
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  int total = 1;

  dynamic day;
  var time = DateTime.now();
  void day1() {
    if (time.day < 10) {
      setState(() {
        day = '0${time.day}';
      });
    } else {
      day = time.day;
    }
  }

  dynamic mois;
  void mois1() {
    if (time.month < 10) {
      setState(() {
        mois = '0${time.month}';
      });
    } else {
      mois = time.month;
    }
  }

  dynamic hours;

  void hours1() {
    if (time.hour < 10) {
      setState(() {
        hours = '0${time.hour}';
      });
    } else {
      hours = time.hour;
    }
  }

  dynamic minute;

  void minutes1() {
    if (time.minute < 10) {
      setState(() {
        minute = '0${time.minute}';
      });
    } else {
      minute = time.minute;
    }
  }

  dynamic seconds;

  void seconds1() {
    if (time.second < 10) {
      setState(() {
        seconds = '0${time.second}';
      });
    } else {
      seconds = time.second;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                )),
            Image.network(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (total > 1) total--;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  total.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      total++;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              widget.detail,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${(total == 1) ? widget.price : (total * double.parse(widget.price)).toStringAsFixed(2)} DT",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      mois1();
                      day1();
                      hours1();
                      minutes1();
                      seconds1();
                      String orderId =
                          '${time.year}$mois$day$hours$minute$seconds';

                      String userId = FirebaseAuth.instance.currentUser!.uid;

                      // Recherche d'une commande active pour l'utilisateur
                      QuerySnapshot<Map<String, dynamic>> activeCommands =
                          await _firebaseFirestore
                              .collection("Commands")
                              .where("userId", isEqualTo: userId)
                              .where("panier", isEqualTo: "true")
                              .get();

                      if (activeCommands.docs.isNotEmpty) {
                        String commandId = activeCommands.docs.first.id;

                        // Créer une référence à la collection de produits de la commande existante
                        CollectionReference productsRef = _firebaseFirestore
                            .collection("Commands")
                            .doc(commandId)
                            .collection("Products");

                        bool productExist = false;

                        productsRef.get().then((querySnapshot) async {
                          for (var doc in querySnapshot.docs) {
                            if (doc.id == widget.name) {
                              productExist = true;
                              break;
                            }
                          }
                          // Ajouter le produit à la collection de produits de la commande
                          if (productExist != true) {
                            await productsRef.doc(widget.name).set({
                              "name": widget.name,
                              "description": widget.detail,
                              "image": widget.image,
                              "count": total,
                              "price": widget.price,
                              "totalPrice": (total == 1)
                                  ? widget.price
                                  : (total * double.parse(widget.price))
                                      .toStringAsFixed(2),
                              "orderDate": orderId,
                            });
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Produit ajouté",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Produit déjà ajouté",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            );
                          }
                        });
                      } else {
                        DocumentReference newCommandRef =
                            await _firebaseFirestore
                                .collection("Commands")
                                .add({"userId": userId, "panier": "true"});

                        await newCommandRef
                            .collection("Products")
                            .doc(orderId)
                            .set({
                          "name": widget.name,
                          "description": widget.detail,
                          "image": widget.image,
                          "count": total,
                          "totalPrice": (total == 1)
                              ? widget.price
                              : (total * double.parse(widget.price))
                                  .toStringAsFixed(2),
                          "price": widget.price,
                          "orderDate": orderId,
                        });

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Produit ajouté",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      }
                      // ignore: use_build_context_synchronously
                      Provider.of<ItemsNumber>(context, listen: false)
                          .getProductsNumber();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins'),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
