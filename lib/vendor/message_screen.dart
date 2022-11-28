import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  DateTime? onWayDate;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                        CupertinoIcons.square_list,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Ordered',
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
                                      'Order Date :  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    if (documentSnapshot['orderDate'] != null)
                                      Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(
                                                documentSnapshot['orderDate']
                                                    .toDate())
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                          documentSnapshot['shipping'] == true
                              ? Expanded(child: Text('Item on its Way'))
                              : Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.yellow.shade900),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (
                                          context,
                                        ) {
                                          return CupertinoAlertDialog(
                                            title: Text('Ship Order'),
                                            content: Text('Are you sure ?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(5000),
                                                  ).then((value) {
                                                    setState(() {
                                                      onWayDate = value;
                                                    });
                                                  }).whenComplete(() async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('orders')
                                                        .doc(documentSnapshot[
                                                            'orderId'])
                                                        .update({
                                                      'shippingDate': onWayDate,
                                                      'shipping': true
                                                    });
                                                  }).whenComplete(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('Ok'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Ship'),
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (
                                    context,
                                  ) {
                                    return CupertinoAlertDialog(
                                      title: Text('Reject Order'),
                                      content: Text('Are you sure ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(
                                                    documentSnapshot['orderId'])
                                                .delete();
                                          },
                                          child: Text('Ok'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Reject'),
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
