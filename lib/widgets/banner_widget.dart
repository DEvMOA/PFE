import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final _firestore = FirebaseFirestore.instance;
  final List<dynamic> _bannersList = [];

  Future<void> getBanners() async {
    final querySnapshot = await _firestore.collection('Banners').get();
    for (var doc in querySnapshot.docs) {
      setState(() {
        _bannersList.add(doc['image']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount: _bannersList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _bannersList[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
