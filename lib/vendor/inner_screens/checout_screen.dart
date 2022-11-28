import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_grocery_shop/vendor/inner_screens/edit_profile_screen.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:multi_grocery_shop/views/screens/home_screen.dart';
import 'package:multi_grocery_shop/views/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _payMethod = 1;
  late String orderId;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: buyers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text(
                        'BILLING ADDRESS',
                      ),
                      subtitle: Text('Default shipping Address'),
                      trailing: Icon(
                        Icons.arrow_forward,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfileScreen();
                        }));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Your Order',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: ((context, cart, child) {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.getCartItem.length,
                          itemBuilder: (context, index) {
                            final cartData =
                                cart.getCartItem.values.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: SizedBox(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          cartData.imageUrls[0],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartData.productName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '\$' +
                                                  '${cartData.price.toStringAsFixed(2)}',
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: _payMethod,
                    onChanged: (value) {},
                    title: Row(
                      children: [
                        Icon(FontAwesomeIcons.dollarSign),
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: _payMethod,
                    onChanged: (value) {},
                    title: Row(
                      children: [
                        Icon(FontAwesomeIcons.stripe),
                        Text(
                          'Stripe',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: _payMethod,
                    onChanged: (value) {},
                    title: Row(
                      children: [
                        Icon(FontAwesomeIcons.paypal),
                        Text(
                          'PayPal',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () async {
                  if (_payMethod == 1) {
                    EasyLoading.show();

                    _cartProvider.getCartItem.forEach((key, item) async {
                      CollectionReference orderRef =
                          _firestore.collection('orders');

                      orderId = Uuid().v4();

                      await orderRef.doc(orderId).set({
                        'cid': data['cid'],
                        'vendorId': item.vendorId,
                        'email': data['email'],
                        'city': data['city'],
                        'country': data['country'],
                        'fullName': data['fullName'],
                        'state': data['state'],
                        'phone': data['phone'],
                        'profileImage': data['profileImage'],
                        'productId': item.productId,
                        'orderId': orderId,
                        'orderName': item.productName,
                        'orderImage': item.imageUrls.first,
                        'orderPrice': item.price,
                        'orderQuantity': item.quantity,
                        'deliveryDate': '',
                        'delivered': false,
                        'deliveryStatus': true,
                        'shipping': false,
                        'accepted': false,
                        'orderDate': DateTime.now(),
                      }).whenComplete(() {
                        setState(() {
                          EasyLoading.dismiss();

                          _cartProvider.getCartItem.clear();
                        });
                      }).whenComplete(() {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: ((context) {
                          return MainScreen();
                        })));
                      });
                    });
                  }
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade900,
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'PAY NOW',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    );
  }
}
