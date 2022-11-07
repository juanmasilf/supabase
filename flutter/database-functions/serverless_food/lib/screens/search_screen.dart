import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serverless_food/screens/view_food_screen.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/services/food_db_service.dart';
import 'package:serverless_food/services/storage_service.dart';
import 'package:serverless_food/utils/constants.dart';
import 'package:serverless_food/widget/rounded_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _titleController = TextEditingController();

  List<Map<String, dynamic>> foundedFoods = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Search a food'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: _buildSearchTextField(context)),
                  IconButton(
                      onPressed: searchFoods, icon: const Icon(Icons.search))
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: foundedFoods.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewFoodScreen(
                        foodId: foundedFoods[index]['id'],
                      ),
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(foundedFoods[index]['title']),
                      subtitle: Text(foundedFoods[index]['description']),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchFoods() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final list = await FoodDbService.textSearch(_titleController.text);

      setState(() {
        foundedFoods = list;
        isLoading = false;
      });
    }
  }

  Widget _buildSearchTextField(BuildContext context) {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Type a food name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
    );
  }
}
