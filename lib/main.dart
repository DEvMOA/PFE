import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magani_shop/views/patients/authentication/login_screen.dart';
import 'package:magani_shop/views/patients/checkout_screen.dart';
import 'package:magani_shop/views/patients/main_screen.dart';
import 'package:magani_shop/views/patients/cart_screen.dart';
import 'package:magani_shop/views/patients/update_profile_screen.dart';
import 'package:magani_shop/widgets/items_number_widget.dart';
import 'package:magani_shop/widgets/profile_info.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ChangeNotifierProvider(
      create: (context) => ItemsNumber(),
      child: MaterialApp(
          title: 'MaganiShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
            useMaterial3: true,
          ),
          home: const LoginScreen(),
          routes: {
            ('/mainScreen'): (context) => const MainScreen(),
            ('/cartScreen'): (context) => const CartScreen(),
            ('/checkoutScreen'): (context) => const CheckoutScreen(),
            ('/updateProfileScreen'): (context) => const UpdateProfileScreen(),
            ('/profileInfo'): (context) => const ProfileInfo()
          }),
    );
  }
}
