import 'package:flutter/material.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/services/food_db_service.dart';
import 'package:serverless_food/utils/constants.dart';
import 'package:serverless_food/widget/rounded_button.dart';

class ViewFoodScreen extends StatefulWidget {
  const ViewFoodScreen({super.key, required this.foodId});

  final String foodId;

  @override
  State<ViewFoodScreen> createState() => _ViewFoodScreenState();
}

class _ViewFoodScreenState extends State<ViewFoodScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late Future<Map<String, dynamic>?> foodFuture;

  @override
  void initState() {
    super.initState();
    foodFuture = FoodDbService.getFood(widget.foodId);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('View food'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: foodFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final food = snapshot.data!;
                _descriptionController.text = food['description'];
                _titleController.text = food['title'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleTextField(context),
                      _buildDescriptionTextField(context),
                      const Text(
                        'Owner',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        'Username: ${food['owner']['username']}',
                      ),
                      Text(
                        'Email: ${food['owner']['email']}',
                      ),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Padding _buildTitleTextField(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      child: TextField(
        controller: _titleController,
        enabled: false,
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
        enabled: false,
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
