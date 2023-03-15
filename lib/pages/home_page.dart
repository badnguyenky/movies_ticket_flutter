import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';
import '../tabs/allMovies_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: width,
              // height: 50,
              child: TabBar(
                indicatorColor: Colors.transparent,
                labelColor: Constants.secondaryColor,
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'All Movies',
                  ),
                  Tab(
                    text: 'For Kids',
                  ),
                  Tab(
                    text: 'My Tickets',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: width,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    allMovies_tab(),
                    Text('2'),
                    Text('3'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

