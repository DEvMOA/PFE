import 'package:flutter/material.dart';
import 'package:magani_shop/views/medicine_detail_screen.dart'; // Importez l'écran de détails du médicament

class MedicineCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String price;
  final String pharmacy;

  const MedicineCard({
    required this.image,
    required this.pharmacy,
    required this.name,
    required this.description,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: GestureDetector(
          onTap: () {
            // Lorsque l'utilisateur appuie sur la carte, naviguez vers l'écran de détails du médicament
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MedicineDetailScreen()),
            );
          },
          child: Container(
            color: Colors.white,
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.0)),
                      child: Image.network(
                        image,
                        height: 125,
                        width: 125,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            pharmacy,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$price DT',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
