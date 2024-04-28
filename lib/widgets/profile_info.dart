// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProfileInfo extends StatefulWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  _lancerAppel({required String phoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible d\'appeller $launchUri';
    }
  }

  _lanceremail({required String phoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible de texter $launchUri';
    }
  }

  _lancerweb({required String phoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'https', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Impossible de texter $launchUri';
    }
  }

  Widget imageProfile() {
    return const CircleAvatar(
      radius: 90,
      backgroundColor: Colors.green,
      backgroundImage: AssetImage("assets/images/img_register.png"),
    );
  }

  Widget call() {
    return GestureDetector(
      onTap: () {
        _lancerAppel(phoneNumber: '+21651840138');
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.green.shade300),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.call),
            SizedBox(width: 15),
            Text('+216 51840138', style: TextStyle(fontSize: 20))
          ],
        ),
      ),
      // child: TextFormField(strutStyle: StrutStyle(),
      //   enabled: false,
      //   initialValue: '                 +227 98663248',
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.call)),
      // ),
    );
  }

  Widget email() {
    return GestureDetector(
      onTap: () {
        _lanceremail(phoneNumber: 'maganishop@gmail.com');
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.green.shade300),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined),
            SizedBox(width: 15),
            Text('maganishop@gmail.com', style: TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }

  Widget web() {
    return GestureDetector(
      onTap: () {
        _lancerweb(phoneNumber: 'wwww.maganishop.com');
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.green.shade300),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.web_outlined),
            SizedBox(width: 15),
            Text(
              'wwww.maganishop.com',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Aucune donnée trouvée');
        }

        final userData = snapshot.data!;
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: Scaffold(
              body: SafeArea(
                  child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 14,
                        ),
                        imageProfile(),
                        const SizedBox(height: 50),
                        Text(
                          'Bonjour ${userData['full name']},',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Text('En quoi puis-je vous aidez?'),
                        const SizedBox(height: 50),
                        call(),
                        const SizedBox(height: 40),
                        email(),
                        const SizedBox(height: 40),
                        web(),
                      ],
                    ),
                  ),
                ),
              )),
            ));
      },
    );
  }
}
