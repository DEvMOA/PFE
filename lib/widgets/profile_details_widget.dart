import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDetailsWidget extends StatefulWidget {
  const ProfileDetailsWidget({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget> {
  void _updateValue(String label, String newValue) {
    // Par exemple, vous pouvez utiliser Firestore.instance.collection('Users').doc(userId).update({'$label': newValue});
  }

  void _showUpdateDialog(String label) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Modifier $label'),
            content: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir une nouvelle valeur.';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Nouvelle valeur',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Annuler',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Enregistrer',
                    style: TextStyle(color: Colors.green)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _updateValue(label, controller.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.person, 'Full Name', userData['full name']),
            _buildDetailRow(
                Icons.phone, 'Number', userData['number'].toString()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  userData['email'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(
            height: 5,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          value,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        _showUpdateDialog(label);
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
