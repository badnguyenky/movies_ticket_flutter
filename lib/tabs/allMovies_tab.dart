import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';

class allMovies_tab extends StatefulWidget {
  const allMovies_tab({super.key});
  @override
  State<allMovies_tab> createState() => _allMovies_tabState();
}

class _allMovies_tabState extends State<allMovies_tab> {
  int _index = 2;
  int _length = 0;
  late Future _getNowShowingMovies;
  late Future _getComingSoonMovie;
  @override
  void initState() {
    super.initState();
    _getNowShowingMovies = getNowShowingMovies();
    _getComingSoonMovie = getComingSoonMovie();
  }

  Future getNowShowingMovies() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection("movies")
        .where('nowshowing', isEqualTo: true)
        .get();
    _length = snapshot.docs.length;
    return snapshot.docs;
  }

  Future getComingSoonMovie() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection("movies")
        .where('comingsoon', isEqualTo: true)
        .get();
    return snapshot.docs;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: _getComingSoonMovie,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                String trailer = snapshot.data[0].data()['trailer'];
                String title = snapshot.data[0].data()['title'];
                return Stack(children: [
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(trailer)!,
                        flags: const YoutubePlayerFlags(
                            hideControls: true, autoPlay: true, loop: true)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ]);
              }),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Now Showing',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: _getNowShowingMovies,
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: _length,
                      itemBuilder: (context, index, realIndex) {
                        return SizedBox(
                            child: Image.network(
                          snapshot.data[index].data()['poster'],
                          fit: BoxFit.fill,
                        ));
                      },
                      options: CarouselOptions(
                          aspectRatio: 1.0,
                          viewportFraction: 0.5,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          disableCenter: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _index = index;
                            });
                          }),
                    ),
                    Text(snapshot.data[_index].data()['title'],
                        style: const TextStyle(color: Colors.white, fontSize: 15))
                  ],
                );
              })
        ],
      ),
    );
  }
}
