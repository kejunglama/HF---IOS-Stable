import 'package:flutter/material.dart';

class HealthyMealsSearchScreen extends StatefulWidget {
  const HealthyMealsSearchScreen({Key key}) : super(key: key);

  @override
  State<HealthyMealsSearchScreen> createState() =>
      _HealthyMealsSearchScreenState();
}

class _HealthyMealsSearchScreenState extends State<HealthyMealsSearchScreen> {
  Icon customIcon = const Icon(Icons.search);

  Widget customSearchBar = const Text('My Personal Journal');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = const ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'type in journal name...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('My Personal Journal');
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
      ),
    );
  }
}
