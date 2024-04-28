import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magani_shop/widgets/medicine_card_widget.dart';

class MedicineListWidget extends StatelessWidget {
  final String selectedCategory;

  const MedicineListWidget({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('Medicines');

    if (selectedCategory != "TOUS") {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
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
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: medicines.map((medicineData) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: MedicineCard(
                  image: medicineData['image'],
                  pharmacy: medicineData['pharmacyName'],
                  name: medicineData['name'],
                  description: medicineData['description'],
                  price: medicineData['price'],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
