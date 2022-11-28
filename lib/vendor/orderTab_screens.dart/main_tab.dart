import 'package:flutter/material.dart';

import 'package:multi_grocery_shop/vendor/message_screen.dart';
import 'package:multi_grocery_shop/vendor/orderTab_screens.dart/delivered.dart';
import 'package:multi_grocery_shop/vendor/orderTab_screens.dart/shipping_screen.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('My Orders'),
          backgroundColor: Colors.yellow.shade800,
          bottom: TabBar(tabs: [
            Tab(
              text: 'All Orderd',
            ),
            Tab(
              text: 'On Way',
            ),
            Tab(
              text: 'Delivered',
            ),
          ]),
        ),
        body: TabBarView(children: [
          MessageScreen(),
          ShippingScreen(),
          DeliveredScreen(),
        ]),
      ),
    );
  }
}
