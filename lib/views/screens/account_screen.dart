import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/views/screens/auth/customer_login_screen.dart';
import 'package:multi_grocery_shop/views/screens/cart_screen.dart';
import 'package:multi_grocery_shop/views/screens/customer_tab/cust_main_tab.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 200,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      return FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade900,
                                Colors.yellow.shade900,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      NetworkImage(data['profileImage']),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Text(
                                  '${data['fullName']}'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'Account Info',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.email,
                          ),
                          title: Text(
                            'Email Address',
                          ),
                          subtitle: Text('${data['email']}'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text(
                            'Phone Number',
                          ),
                          subtitle: Text(
                            '${data['phone']}',
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            CupertinoIcons.cart_badge_plus,
                          ),
                          title: Text(
                            'Cart',
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CartScreen();
                            }));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.shop,
                          ),
                          title: Text(
                            'My Orders',
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CusMainTab();
                            }));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                          trailing: Icon(
                            Icons.arrow_forward,
                          ),
                          onTap: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .whenComplete(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CustomerLoginScreen();
                              }));
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.blueGrey,
          ),
        );
      },
    );
  }
}
