import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_grocery_shop/utils/const.dart';
import 'package:multi_grocery_shop/vendor/home_screen.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/add_product_screen.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/profile_screens.dart';
import 'package:multi_grocery_shop/vendor/message_screen.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:multi_grocery_shop/views/screens/cart_screen.dart';
import 'package:multi_grocery_shop/views/screens/category_screen.dart';
import 'package:multi_grocery_shop/views/shop_screen.dart';
import 'package:provider/provider.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  List<Widget> _pages = [
    VendorHomeScreen(),
    CategoryScreen(),
    VendorProfileScreen(),
    ShopScreen(),
    CartScreen(),
    AddProductScreen(),
  ];
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.yellow.shade900,
        currentIndex: _pageIndex,
        onTap: ((value) {
          setState(() {
            _pageIndex = value;
          });
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/explore.svg',
              width: 20,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/account.svg'),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              width: 20,
            ),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
              icon
                
                  : SvgPicture.asset(
                      'assets/icons/cart.svg',
                      width: 20,
                    ),
              label:   'Cart'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: 'Upload',
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
