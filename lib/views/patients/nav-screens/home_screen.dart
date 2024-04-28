import 'package:flutter/material.dart';
import 'package:magani_shop/widgets/banner_widget.dart';
import 'package:magani_shop/widgets/category_list_widget.dart';
import 'package:magani_shop/widgets/items_number_widget.dart';
import 'package:magani_shop/widgets/widget_support.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ItemsNumber>(context, listen: false).getProductsNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'MAGANI',
          style: AppWidget.boldTextStyle(),
        ),
        actions: <Widget>[
          badges.Badge(
            onTap: () {
              Navigator.pushNamed(context, '/cartScreen');
            },
            badgeContent:
                Consumer<ItemsNumber>(builder: (context, itemsNumber, child) {
              return Text('${itemsNumber.items}');
            }),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cartScreen');
                },
                child: AppWidget.cartIcon()),
          ),
          const SizedBox(width: 10)
        ],
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
              const CategoryListWidget(),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
