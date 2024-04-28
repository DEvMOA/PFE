import 'package:flutter/material.dart';
import 'package:magani_shop/widgets/profile_details_widget.dart';
import 'package:magani_shop/widgets/profile_image_widget.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ProfileImageWidget(), ProfileDetailsWidget()],
            ),
          ),
        ),
      ),
    );
  }
}
