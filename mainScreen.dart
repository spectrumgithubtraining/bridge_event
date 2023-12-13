import 'dart:convert';
import 'dart:ui';

import 'package:bridge_events/screen/detailPages/beachPage.dart';
import 'package:bridge_events/screen/detailPages/bohemianPage.dart';
import 'package:bridge_events/screen/detailPages/diyPage.dart';
import 'package:bridge_events/screen/detailPages/rusticPage.dart';
import 'package:bridge_events/screen/detailPages/traditionalPage.dart';
import 'package:bridge_events/screen/detailPages/vintagePage.dart';
import 'package:bridge_events/screen/hindu_wedding/hindu_page1.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../hindu_wedding/hindu_demo.dart';
import 'package:http/http.dart' as http;

import '../profile.dart';
import 'cart.dart';
import 'favourite.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    readCatogory();
    super.initState();
  }

  int currentindex = 0;

  final List<String> imageList = [
    'assets/images/scroll1.jpg',
    'assets/images/scroll2.jpg',
    'assets/images/scroll3.jpg'
  ];

  final List<String> imagePaths = [];

  final List<String> titles = [];
  final itemHeight = 250;
  final itemWidth = 180;

  final url = "https://bridge-event-default-rtdb.firebaseio.com/" +
      "eventCategory.json";

  readCatogory() async {
    final result = await http.get(Uri.parse(url));

    final data = json.decode(result.body) as Map<String, dynamic>;
    data.forEach((key, value) {
      titles.add(value["name"]);
      imagePaths.add(value["image"]);

    });

  }
  final List<Widget> _pages = [
    const DiyPage(),
    const RusticPage(),
    const VintagePage(),
    const TraditionalPage(),
    const BeachPage(),
    const BohemianPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'Bridge Events',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 34,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 220,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        pauseAutoPlayOnTouch: true,
                        enlargeCenterPage: true,
                        padEnds: true,
                        aspectRatio: 3.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentindex = index;
                          });
                        },
                      ),
                      items: imageList.map((items) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              items,
                              fit: BoxFit.fill,
                              width: 1200.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Find Your",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text(
                    "Wedding Party",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: imagePaths.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    ),
                    itemBuilder: (context, index) {
                      final imagePath = imagePaths[index].toString();
                      final title = titles[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return _pages[index];
                              },
                            ));
                          });
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Stack(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                     fit: BoxFit.cover,
                                     width: double.infinity,
                                     height: double.infinity,
                                  image: NetworkImage(imagePaths[index].toString()),
                                ),

                              ),

                              // Text
                              Positioned(
                                right: 38.0,
                                left: 38.0,
                                bottom: 25.0,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 8.0,
                                          sigmaY: 8.0,
                                        ),
                                        child: SizedBox(
                                          height: 68.0,
                                          width: 145.0,
                                          child: Center(
                                            child: Text(
                                              title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Follow Me...!",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            child: const Image(
                              image: AssetImage('assets/images/instaQR1.jpg'),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
