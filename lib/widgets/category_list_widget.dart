import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magani_shop/widgets/medicine_list_widget.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  String? selectedCategory = 'TOUS';
  String catName = 'TOUS';
  List<DocumentSnapshot>? categoriesData;

  @override
  void initState() {
    super.initState();
    loadCategoriesData();
    catName = 'TOUS';
  }

  void loadCategoriesData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    setState(() {
      categoriesData = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categoriesData == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    List<Widget> categoryWidgets = [
      GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = 'TOUS';
            catName = 'TOUS';
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: selectedCategory == 'TOUS' ? Colors.green : null,
                child: const SizedBox(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.all_inclusive),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'TOUS',
                style: TextStyle(
                  fontWeight: selectedCategory == 'TOUS'
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selectedCategory == 'TOUS' ? Colors.green : null,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    categoryWidgets.addAll(categoriesData!.map((categoryData) {
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
                categoryName.length > 13
                    ? categoryName.substring(0, 13).toUpperCase()
                    : categoryName.toUpperCase(),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green : null,
                ),
              )
            ],
          ),
        ),
      );
    }).toList());

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categoryWidgets,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        MedicineListWidget(selectedCategory: catName)
      ],
    );
  }
}
