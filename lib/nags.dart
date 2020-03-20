import 'package:flutter/material.dart';

class NagsPage extends StatefulWidget {
  NagsPage({Key key}) : super(key: key);

  @override
  _NagsPageState createState() => _NagsPageState();
}

class _NagsPageState extends State<NagsPage> {
  var nags = List<String>();

  void _addNag() {
    setState(() {
      var number = nags.length + 1;
      nags.add('Nag $number');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nagger')),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text(nags[index])),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: nags.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNag,
      ),
    );
  }
}
