
import 'package:flutter/material.dart';

import 'gallery.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery Multi picker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Image Gallery Multi picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> checkedList;

  @override
  void initState() {
    super.initState();
    checkedList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Gallery Multi picker'),),
      body: Container(
        child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text('selected images total count: ${checkedList.length}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Text('${checkedList}'),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Text('Gallery'),),
            onTap: () async {
          final getCheckedList = await Navigator.push(context, MaterialPageRoute(builder: (_)=> Gallery()));
          if (getCheckedList != null)
          setState(() {
          checkedList = getCheckedList;
          });
          },
          ),
        ],),),)
    );
  }
}
