import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_scroll/constraints_tab.dart';
import 'package:flutter_custom_scroll/custom_scroll_tab.dart';

void main() {
  runApp(ScrollingApp());
}

class ScrollingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Scroll View Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: TabBar(
              physics: NeverScrollableScrollPhysics(),
              tabs: [
                Tab(
                  icon: Icon(Icons.aspect_ratio),
                  text: "Constraints & Geometry",
                ),
                Tab(
                  icon: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(Icons.view_carousel),
                  ),
                  text: "Custom scroll",
                )
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ConstraintsTab(),
              CustomScrollTab(),
            ],
          ),
        ),
      ),
    );
  }
}
