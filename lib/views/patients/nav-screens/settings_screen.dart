import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magani_shop/views/patients/authentication/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Une erreur s\'est produite'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Aucune donnée trouvée'),
            );
          }

          var userData = snapshot.data!.data();

          if (userData == null) {
            return const Center(
              child: Text('Aucune donnée utilisateur trouvée'),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 45),
            child: Column(
              children: [
                _top(context: context),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (snapshot.data!['imageUrl'] == "")
                                        ? CircleAvatar(
                                            radius: 35,
                                            child: Text(
                                              snapshot.data!['full name'][0]
                                                  .toString()
                                                  .toUpperCase(),
                                              style:
                                                  const TextStyle(fontSize: 32),
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                snapshot.data!['imageUrl']),
                                            radius: 35,
                                          ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${snapshot.data!['full name']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ('/updateProfileScreen'));
                                  },
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                    color: Colors.green,
                                  ))
                            ],
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () async {
                              await auth.signOut();
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.logout_outlined,
                                color: Colors.green,
                              ),
                              title: Text(
                                'Se deconnecter',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () async {
                              // Récupérer l'utilisateur actuellement connecté
                              User? user = FirebaseAuth.instance.currentUser;

                              if (user != null) {
                                // Demander à l'utilisateur de confirmer la suppression du compte
                                bool? confirm =
                                    await _showConfirmationDialog(context);

                                if (confirm!) {
                                  // Supprimer le compte de l'utilisateur
                                  try {
                                    await user.delete();
                                    // Si la suppression réussit, déconnectez l'utilisateur
                                    await FirebaseAuth.instance.signOut();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                    // Rediriger l'utilisateur vers l'écran de connexion ou une autre page appropriée
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  } catch (e) {
                                    // Gérer les erreurs éventuelles lors de la suppression du compte
                                  }
                                }
                              }
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.delete_outline,
                                color: Colors.green,
                              ),
                              title: Text(
                                'Supprimer le compte',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, ('/profileInfo'));
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.help_outline,
                                color: Colors.green,
                              ),
                              title: Text(
                                'Aide',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _top({context}) {
    // final FirebaseAuth auth = FirebaseAuth.instance;
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Paramètres',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        // GestureDetector(
        //   onTap: () async {
        //     await auth.signOut();
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => const LoginScreen()),
        //     );
        //   },
        //   child: Container(
        //       padding: const EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(14),
        //       ),
        //       child: const Icon(
        //         Iconsax.login,
        //         size: 24,
        //         color: Colors.green,
        //       )),
        // )
      ]),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
              'Voulez-vous vraiment supprimer votre compte? Cette action est irréversible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Annuler la suppression
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmer la suppression
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
