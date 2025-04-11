
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('홈')),
      body: ListView(
        children: [
          ListTile(
            title: Text('작업일보'),
            onTap: () => Navigator.pushNamed(context, '/dailyReport'),
          ),
          ListTile(
            title: Text('작업허가서'),
            onTap: () => Navigator.pushNamed(context, '/permit'),
          ),
          ListTile(
            title: Text('설정'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}
