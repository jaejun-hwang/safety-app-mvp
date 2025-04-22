
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: '이메일')),
            TextField(decoration: InputDecoration(labelText: '비밀번호'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              child: Text('로그인'),
            ),
            TextButton(onPressed: () {}, child: Text('회원가입')),
            TextButton(onPressed: () {}, child: Text('비밀번호 찾기')),
          ],
        ),
      ),
    );
  }
}
