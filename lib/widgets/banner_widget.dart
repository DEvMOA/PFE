import 'dart:async';

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
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  int activeImage = 0;

  final PageController screenController = PageController(initialPage: 0);

  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (screenController.page == _bannersList.length - 1) {
        screenController.animateToPage(0,
            duration: const Duration(microseconds: 300),
            curve: Curves.easeInOut);
      } else {
        screenController.nextPage(
            duration: const Duration(microseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          SizedBox(
            height: 170,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: screenController,
              itemCount: _bannersList.length,
              onPageChanged: (value) {
                setState(() {
                  activeImage = value;
                });
              },
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
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                    _bannersList.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              screenController.animateToPage(index,
                                  duration: const Duration(microseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: activeImage == index
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        )),
              ),
            ),
          )
        ])
      ],
    );
  }
}
