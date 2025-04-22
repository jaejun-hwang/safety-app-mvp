
import 'package:flutter/material.dart';

class PermitScreen extends StatelessWidget {
  const PermitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('작업허가서')),
      body: Center(child: Text('작업허가서 입력화면')),
    );
  }
}
