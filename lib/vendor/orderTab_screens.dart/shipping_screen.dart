import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  DateTime? onWayDate;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('shipping', isEqualTo: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(color: Colors.yellow.shade900),
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Scaffold(
            body: Center(
              child: Center(
                child: Text(
                  'No Product \n  Delivered yet',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 30,
                    letterSpacing: 7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return Scaffold(
            body: ListView(
          children:
              snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            return Container(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      child: Icon(
                        Icons.nordic_walking,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Shipping',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    trailing: Text(
                      'Amount' +
                          ' ' +
                          '\$' +
                          documentSnapshot['orderPrice'].toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text('Order Details'),
                    subtitle: Text(
                      ' View Order Details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                      ),
                    ),
                    children: [
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: documentSnapshot['orderQuantity'],
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Image.network(
                                    documentSnapshot['orderImage']),
                              ),
                              title: Text(documentSnapshot['orderName']),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        child: Card(
                          color: Colors.yellow.shade900,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Customer Details :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['fullName']
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email Address :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['email'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Country :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['country'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'City :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['city'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'State :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['state'].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery Status :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    documentSnapshot['delivered'] == true
                                        ? Text(
                                            'Delivered',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 22,
                                            ),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 3,
                    color: Colors.grey,
                  ),
                  Divider(
                    height: 3,
                    color: Colors.grey,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(documentSnapshot['orderId'])
                                    .update({
                                  'delivered': true,
                                  'shipping': false,
                                });
                              },
                              child: Text(
                                'Delevered ?',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 8),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ));
      },
    );
  }
}
