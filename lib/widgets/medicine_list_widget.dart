import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magani_shop/widgets/medicine_card_widget.dart';

class MedicineListWidget extends StatelessWidget {
  final String selectedCategory;

  const MedicineListWidget({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Medicines')
          .where('category', isEqualTo: selectedCategory)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        final medicines = snapshot.data!.docs;
        return SizedBox(
          height: MediaQuery.of(context).size.width *
              0.75, // Hauteur de la première carte
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicineData = medicines[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.60, // Largeur fixe pour toutes les cartes
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0), // Espacement entre les cartes
                  child: MedicineCard(
                    image: medicineData['image'],
                    pharmacy: medicineData['pharmacyName'],
                    name: medicineData['name'],
                    description: medicineData['description'],
                    price: medicineData['price'],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
