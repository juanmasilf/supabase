import 'package:flutter/material.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/widget/food_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Serverless food',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          _buildAddButton(context),
          _buildLogOutButton(context),
        ],
      ),
      body: FoodList(),
    );
  }

  IconButton _buildAddButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed('/add'),
      icon: const Icon(Icons.add, color: Colors.black),
    );
  }

  IconButton _buildLogOutButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await AuthService.signOut();
        Navigator.of(context).pushReplacementNamed('/login');
      },
      icon: const Icon(Icons.logout, color: Colors.black),
    );
  }
}
