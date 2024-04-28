import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File? _image;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();
  final firebase_storage.Reference _storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('ProfilesImages');

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    // Get the current user ID
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final currentUserId = currentUser.uid;

      // Get the user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .get();

      // Check if the user document contains the imageUrl field
      if (userDoc.exists && userDoc.data()!.containsKey('imageUrl')) {
        setState(() {
          _imageUrl = userDoc.data()!['imageUrl'];
        });
      }
    }
  }

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      // Upload image to Firebase Storage
      await _uploadImage(image);
    }
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      final String fileName = image.path.split('/').last;
      final firebase_storage.Reference fileRef =
          _storageReference.child(fileName);
      final task = await fileRef.putFile(File(image.path));
      final url = await task.ref.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
      // Get the current user ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final currentUserId = currentUser.uid;

        // Update imageUrl in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserId)
            .update({'imageUrl': _imageUrl});
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: _getImage,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_imageUrl != null)
                ClipOval(
                  child: Image.network(
                    _imageUrl!,
                    width: 190,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                )
              else if (_image != null)
                ClipOval(
                  child: Image.file(
                    _image!,
                    width: 190,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Icon(Icons.add_a_photo, size: 50),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.edit, size: 20, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
