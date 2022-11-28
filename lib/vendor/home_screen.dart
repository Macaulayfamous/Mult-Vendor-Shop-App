import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:multi_grocery_shop/vendor/widgets/custom_drawer.dart';
import 'package:multi_grocery_shop/views/screens/widgets/banner.dart';
import 'package:multi_grocery_shop/views/screens/widgets/category_widget.dart';
import 'package:multi_grocery_shop/views/screens/widgets/richTextWidget.dart';
import 'package:multi_grocery_shop/views/screens/widgets/searchWidget.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // drawer: CustomDrawer(),
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          RichTextAndIcon(),
          SearchWidget(),
          BannerWidget(),
          CategoryWidget(),
        ],
      ),
    ));
  }
}
