import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/services/food_db_service.dart';
import 'package:serverless_food/services/storage_service.dart';
import 'package:serverless_food/utils/constants.dart';
import 'package:serverless_food/widget/rounded_button.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Create a post'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImagePicker(context),
                    _buildTitleTextField(context),
                    _buildDescriptionTextField(context)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RoundedButton(
                text: 'Add',
                showLoader: isLoading,
                onPressedAction: () => _addFood(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addFood(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final post = await FoodDbService.addFood(
      title: _titleController.text,
      description: _descriptionController.text,
      userId: AuthService.getCurrentSession()!.user!.id,
    );

    if (post != null) {
      if (pickedImage != null) {
        final imageUrl =
            await StorageService.uploadFile(pickedImage!, post['id']);

        await FoodDbService.setFoodImage(
          id: post['id'],
          imageUrl: imageUrl,
        );
      }

      Navigator.of(context).pop();
    } else {
      context.showErrorSnackBar(message: 'Something went wrong');
    }

    setState(() {
      isLoading = false;
    });
  }

  Padding _buildImagePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: pickedImage != null
              ? Image.file(
                  pickedImage!,
                  fit: BoxFit.cover,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.image,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Tap to pick an image'),
                  ],
                ),
        ),
      ),
    );
  }

  _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  Padding _buildTitleTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      child: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildDescriptionTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Description',
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
