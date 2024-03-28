import 'package:flutter/material.dart';
import 'package:magani_shop/widgets/banner_widget.dart';
import 'package:magani_shop/widgets/category_widget.dart';
import 'package:magani_shop/widgets/widget_support.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello,',
                  style: AppWidget.boldTextStyle(),
                ),
                AppWidget.cartIcon(),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            AppWidget.searchBar(),
            const SizedBox(
              height: 24,
            ),
            const BannerWidget(),
            const SizedBox(
              height: 24,
            ),
            const CategoryWidget(),
            // Row(
            //   children: [
            //     Material(
            //       elevation: 5.0,
            //       borderRadius: BorderRadius.circular(10),
            //       child: Container(
            //         padding: const EdgeInsets.all(8),
            //         child: Image.network(''),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
