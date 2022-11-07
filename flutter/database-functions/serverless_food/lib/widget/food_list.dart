import 'package:flutter/material.dart';
import 'package:serverless_food/screens/view_food_screen.dart';
import 'package:serverless_food/services/auth_service.dart';
import 'package:serverless_food/services/food_db_service.dart';

class FoodList extends StatefulWidget {
  FoodList({Key? key}) : super(key: key);

  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  // final foodsFuture =
  //     FoodDbService.getUserFoods(AuthService.getCurrentSession()!.user!.id);

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //       future: foodsFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           final foods = snapshot.data as List<Map<String, dynamic>>;
  //           return ListView.builder(
  //             itemCount: foods.length,
  //             itemBuilder: (context, index) {
  //               return InkWell(
  //                 onTap: () => Navigator.of(context).push(
  //                   MaterialPageRoute(
  //                     builder: (context) => ViewFoodScreen(
  //                       foodId: foods[index]['id'],
  //                     ),
  //                   ),
  //                 ),
  //                 child: Card(
  //                   child: ListTile(
  //                     title: Text(foods[index]['title']),
  //                     subtitle: Text(foods[index]['description']),
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //         return Center(child: CircularProgressIndicator());
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FoodDbService.listenUserFoods(
            AuthService.getCurrentSession()!.user!.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final foods = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewFoodScreen(
                        foodId: foods[index]['id'],
                      ),
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(foods[index]['title']),
                      subtitle: Text(foods[index]['description']),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
