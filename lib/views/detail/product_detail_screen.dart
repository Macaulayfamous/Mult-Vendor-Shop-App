import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:multi_grocery_shop/vendor/inner_screens/vendorStore_screen.dart';

import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';

import 'package:multi_grocery_shop/views/screens/widgets/category_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic products;

  const ProductDetailScreen({super.key, required this.products});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int pageNumber = 0;

  onPageChanged(int value) {
    setState(() {
      pageNumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('categoryName', isEqualTo: widget.products['categoryName'])
        .snapshots();

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.products['productId'])
        .collection('reviews')
        .snapshots();

    final List productsImages = widget.products['productImage'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.products['productName'],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(
                    25,
                  ),
                ),
              ),
              height: 400,
              child: Stack(
                children: [
                  PageView(
                    onPageChanged: onPageChanged,
                    children: productsImages.map(
                      (e) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                e,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    right: MediaQuery.of(context).size.width / 2,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black45,
                      child: Text(
                        '${pageNumber + 1} / ${productsImages.length}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$ ${widget.products['productPrice'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.yellow.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.products['productName'],
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.products['productDescription'],
                    style: TextStyle(
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          child: ListView.builder(
                              itemCount: snapshot.data!.size,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final reviewData = snapshot.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            reviewData['profileImage']),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(reviewData['fullName']),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RatingBar.readOnly(
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        initialRating: reviewData['rating'],
                                        maxRating: 5,
                                        alignment: Alignment.center,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      );
                    },
                  ),
                  Text(
                    'Related Products',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _productStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.cyan),
                    ),
                  );
                }

                return Container(
                  height: 270,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.size,
                      itemBuilder: ((context, index) {
                        return ReuseProductModel(
                          categoryData: snapshot.data!.docs[index],
                        );
                      })),
                );
              },
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VendorStoreScreen(
                        vendorId: widget.products['vendorId']);
                  }));
                },
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/shop.svg'),
                    Text(
                      'Store',
                      style: TextStyle(color: Colors.yellow.shade900),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.yellow.shade900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: _cartProvider.getCartItem
                        .containsKey(widget.products['productId'])
                    ? null
                    : () {
                        _cartProvider.addProductToCart(
                          widget.products['productId'],
                          widget.products['productName'],
                          widget.products['productImage'],
                          widget.products['productPrice'],
                          widget.products['vendorId'],
                          widget.products['shippingDate'],
                        );
                      },
                child: Text(_cartProvider.getCartItem
                        .containsKey(widget.products['productId'])
                    ? 'IN CART'
                    : 'ADD TO CART'),
              )
            ],
          ),
        )
      ],
    );
  }
}
