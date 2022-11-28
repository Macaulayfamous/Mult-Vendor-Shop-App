import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/add_product_screen.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/all_product.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/profile_screens.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 96,
            width: MediaQuery.of(context).size.width,
            child: DrawerHeader(
              child: Text(
                'Manage',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          ExpansionTile(
            leading: Icon(
              Icons.manage_history,
            ),
            title: Text(
              'Vendor Area',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              ListTile(
                leading: Icon(
                  CupertinoIcons.person,
                ),
                title: Text(
                  'Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return VendorProfileScreen();
                  }));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text(
              'Product Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              ListTile(
                leading: Icon(
                  Icons.more_horiz_outlined,
                ),
                title: Text(
                  'All Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllProducts();
                  }));
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.add,
                ),
                title: Text(
                  'Add Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddProductScreen();
                  }));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
