import 'package:flutter/material.dart';
import 'package:magani_shop/widgets/banner_widget.dart';
import 'package:magani_shop/widgets/category_list_widget.dart';
import 'package:magani_shop/widgets/widget_support.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello,',
          style: AppWidget.boldTextStyle(),
        ),
        actions: <Widget>[AppWidget.cartIcon(), const SizedBox(width: 10)],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              AppWidget.searchBar(),
              const SizedBox(
                height: 10,
              ),
              const BannerWidget(),
              const SizedBox(
                height: 10,
              ),
              const CategoryListWidget()
            ],
          ),
        ),
      ),
    );
  }
}
