import 'package:flutter/material.dart';

class MaterialDashboardMainScreen extends StatefulWidget {
  const MaterialDashboardMainScreen({Key? key}) : super(key: key);

  @override
  _MaterialDashboardMainScreenState createState() =>
      _MaterialDashboardMainScreenState();
}

class _MaterialDashboardMainScreenState
    extends State<MaterialDashboardMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('im android')),
      appBar: AppBar(
        title: Text("app bar"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'dicks'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'cocks'),
        ],
      ),
    );
  }
}
