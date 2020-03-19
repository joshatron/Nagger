import 'package:flutter/material.dart';
import 'nags.dart';
import 'charts.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}


class _NavigationState extends State<Navigation> {
  int _page = 0;

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
    });
  }

  Widget _getCurrentPage() {
    if(_page == 0) {
      return NagsPage();
    }
    else {
      return ChartsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nagger')),
      body: _getCurrentPage(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            title: Text("Nags")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text("Charts")
          ),
        ],
        currentIndex: _page,
        onTap: _onItemTapped,
      ),
    );
  }
}
