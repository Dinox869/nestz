import 'dart:async';
import 'package:nestz/food.dart';
import 'package:nestz/drink.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nest',
      theme: ThemeData(
        primaryColorLight: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePage createState() => _MyHomePage();

}

class _MyHomePage  extends State<MyHomePage> with SingleTickerProviderStateMixin {
  StreamSubscription<QuerySnapshot> subscription;
  int photoIndex = 0;
  List<DocumentSnapshot> imagesUrl;
  List<DocumentSnapshot> details;
  final CollectionReference collectionReference = Firestore.instance.collection("G.H.C.P");
  final CollectionReference collectionReferences = Firestore.instance.collection("G.H.D");
  TabController _tabController;
  ScrollController _scrollController;

  void _previousImage(){
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex -1 : 0;
    });
  }

  void _nextImage(){
    setState(() {
      photoIndex = photoIndex < imagesUrl.length -1 ? photoIndex +1 : photoIndex ;
    });
  }

  @override
  void initState() {

    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot){
      setState(() {
        imagesUrl = datasnapshot.documents;
      });
    });
    subscription = collectionReferences.snapshots().listen((datasnapshot){
      setState(() {
        details = datasnapshot.documents;
      });
    });
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

  }

  @override
  void dispose() {
    subscription?.cancel();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 275.0,
                    child: Hero(
                        tag: imagesUrl[photoIndex].data['url'],
                        child: new FadeInImage(
                            placeholder: new AssetImage("assets/nest.jpg"),
                            image: new NetworkImage(imagesUrl[photoIndex].data['url']),
                        fit: BoxFit.cover,
                        )),
                  ),
                  GestureDetector(
                    child: Container(
                      height: 275.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                    onTap: _nextImage,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 275.0,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.transparent,
                    ),
                    onTap: _previousImage,
                  ),
                  Positioned(
                      top: 240.0,
                      left: MediaQuery.of(context).size.width / 2 - 30.0,
                      child: Row(
                        children: <Widget>[
                          selectedPhoto(
                            numberofDots: imagesUrl.length,
                          photoIndex: photoIndex
                          )
                        ],
                      )
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.only(left: 15.0),
              child: Text(details[0].data['Name'],
              style: TextStyle(fontSize: 22.0,
              fontWeight: FontWeight.bold),
              ),
              ),
              SizedBox(height: 10),
              Padding(padding: EdgeInsets.only(left: 15.0),
              child: Text(details[0].data['Description'],
              style: TextStyle(fontSize: 12.0)
                ,)
                ,),
              SizedBox(height: 10),
              Padding(padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.location_on),
                      color: Colors.black,
                      onPressed: null),
                  Text(details[0].data['Location'],
                  style: TextStyle(fontSize: 18.0,
                  fontWeight: FontWeight.bold),
                  )
                ],
              ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded
                    (
                      child: Divider()
                  ),
                  Text("Products",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),Expanded(
                    child: Divider(),
                  ),
                ]
              ),
              SizedBox(height: 15),
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        RaisedButton.icon(
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute
                                (builder: (context)=>
                                  food()
                              ));
                              },
                            color: Colors.amber,
                            splashColor: Colors.grey,
                            icon: Icon(Icons.local_dining),
                            label: Text("Food") )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        RaisedButton.icon(
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute
                                (builder: (context)=>
                              drink()
                              ));
                            },
                            color: Colors.limeAccent,
                            splashColor: Colors.grey,
                            icon: Icon(Icons.local_bar),
                            label: Text("Drinks") )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        RaisedButton.icon(
                            onPressed: (){
                              //
                            },
                            color: Colors.lightBlueAccent,
                            splashColor: Colors.grey,
                            icon: Icon(Icons.all_inclusive),
                            label: Text("Fun") )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        RaisedButton.icon(
                            onPressed: (){
                              //
                            },
                            color: Colors.greenAccent,
                            splashColor: Colors.grey,
                            icon: Icon(Icons.hotel),
                            label: Text("Accomodation") )
                      ],
                    )
                  ],
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}

class selectedPhoto extends StatelessWidget
{
  final int numberofDots;
  final int photoIndex;

  selectedPhoto({this.numberofDots,this.photoIndex});

  Widget _inactivePhoto(){
    return new Container(
      child: Padding(
          padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4.0)
          ),
        ),
      ),
    );
  }

  Widget _activePhoto(){
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(5.0)
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDots(){
    List<Widget> dots = [];
    for(int i=0;i < numberofDots; ++i){
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }

}