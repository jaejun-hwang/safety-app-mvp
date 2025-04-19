import 'package:flutter/material.dart';

class AccessQRScreen extends StatelessWidget {
  const AccessQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR 출입 관리')),
      body: const Center(
        child: Text('QR 출입 관리 화면'),
      ),
    );
  }
}

