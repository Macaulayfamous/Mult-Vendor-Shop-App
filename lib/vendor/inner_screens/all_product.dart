import 'package:flutter/material.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade900,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Unpublised'),
              ),
              Tab(
                child: Text('Published'),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Center(
            child: Text('Publised'),
          ),
        ]),
      ),
    );
  }
}
