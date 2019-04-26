import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class drink extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>
      (
      stream: Firestore.instance.collection("G.H.D.P").snapshots(),
      builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot)
      {
        if(snapshot.hasError)

          return new Text('${snapshot.error}');
        switch(snapshot.connectionState)
        {
          case ConnectionState.waiting:

          return new Center(
            child: new CircularProgressIndicator(),
          );
          default:
            return new StaggeredGridView.count(
              physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
               children: buildGrid(snapshot.data.documents),
                staggeredTiles: generateRandomTiles(snapshot.data.documents.length)
            );
        }
      }

    );
  }
}
List<Widget> buildGrid(List<DocumentSnapshot> documents)
{
  List<Widget> _gridview = [];
  for(DocumentSnapshot document in documents)
  {
    _gridview.add(buildGridItem(document));
  }
  return _gridview;
}
Widget buildGridItem(DocumentSnapshot document)
{
  return new GestureDetector(
    child: new Card(
    elevation: 3.0,
    margin: const EdgeInsets.all(2.0),
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Hero(
          tag: document.data['url'],
          child:FadeInImage(
              placeholder: new AssetImage("assets/nest.jpg"),
              image: new NetworkImage(document.data['url']),
          fit: BoxFit.cover,
            height: 600.0,
          ),
        ),
        new Align(
          child: Container(
            padding: const EdgeInsets.all(3.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(document.data['name'],
                    style:new TextStyle(color: Colors.limeAccent)
                ),
                new Text("\$" +'${document.data['price']}',
                    style: new TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    )
                ),
              ],
            ),
            color: Colors.black.withOpacity(0.4),
            width: double.infinity,
          ),
          alignment: Alignment.bottomCenter
        )
      ],
    ),
    ),
    onTap: () async
    {
      //todo on press of gestureDetector.
    },
  );
}
List<StaggeredTile> generateRandomTiles(int count) {
  Random rnd = new Random();
  List<StaggeredTile> _staggeredTiles = [];
  for (int i=0; i<count; i++) {
    num mainAxisCellCount = 0;
    double temp = rnd.nextDouble();

    if (temp > 0.6)
    {
      mainAxisCellCount = temp + 0.5;
    } else if (temp < 0.3) {
      mainAxisCellCount = temp + 0.9;
    } else {
      mainAxisCellCount = temp + 0.7;
    }
    _staggeredTiles.add(new StaggeredTile.count(rnd.nextInt(1) + 1, mainAxisCellCount));
  }
  return _staggeredTiles;
}