import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magani_shop/widgets/medicine_list_widget.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  String? selectedCategory = 'ANTI-INFLAMMATOIRE';
  String catName = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        final categories = snapshot.data!.docs;
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: categories.map((categoryData) {
                      final categoryName = categoryData['catName'].toString();
                      final isSelected = categoryName == selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = categoryName;
                            catName = categoryName;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                color: isSelected ? Colors.green : null,
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(categoryData['image']),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                categoryName.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected ? Colors.green : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MedicineListWidget(selectedCategory: catName)
          ],
        );
      },
    );
  }
}
