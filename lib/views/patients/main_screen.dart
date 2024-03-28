import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:magani_shop/views/patients/nav-screens/cart_screen.dart';
import 'package:magani_shop/views/patients/nav-screens/home_screen.dart';
import 'package:magani_shop/views/patients/nav-screens/search_screen.dart';
import 'package:magani_shop/views/patients/nav-screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  static const List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,

              activeColor: Colors.green,

              gap: 8,
              iconSize: 24,
              selectedIndex: _pageIndex,
              onTabChange: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              padding: const EdgeInsets.all(16),
              //tabBackgroundColor: const Color(0xFF00A86B),
              //backgroundColor: Colors.black,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.search, text: 'Search'),
                GButton(icon: Icons.shopping_bag, text: 'Panier'),
                GButton(icon: Icons.person, text: 'Account'),
              ],
            ),
          ),
        ),
      ),
      body: _pages[_pageIndex],
    );
  }
}
