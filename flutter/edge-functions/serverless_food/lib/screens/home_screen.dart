import 'package:flutter/material.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/services/food_db_service.dart';
import 'package:serverless_food/widget/food_list.dart';
import 'package:serverless_food/widget/rounded_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isAddingTestData = false;

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
          _buildSearchButton(context),
          _buildLogOutButton(context),
        ],
      ),
      floatingActionButton: SizedBox(
          width: 170,
          child: RoundedButton(
              text: 'Add test data', onPressedAction: addTestData)),
      body: FoodList(),
    );
  }

  void addTestData() async {
    setState(() {
      isAddingTestData = true;
    });
    await FoodDbService.addTestData(
      numberOfFoods: 20,
      userId: AuthService.getCurrentSession()!.user!.id,
    );
    setState(() {
      isAddingTestData = false;
    });
  }

  IconButton _buildAddButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed('/add'),
      icon: const Icon(Icons.add, color: Colors.black),
    );
  }

  IconButton _buildSearchButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed('/search'),
      icon: const Icon(Icons.search, color: Colors.black),
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
