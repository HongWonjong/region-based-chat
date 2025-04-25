import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowRegisterPrompt extends StatelessWidget {
  const ShowRegisterPrompt({super.key});

  Future<bool> _isUserRegistered() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserRegistered(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(); // 로딩 전엔 안 보이게

        final isRegistered = snapshot.data!;
        if (isRegistered) return const SizedBox(); // 등록된 유저면 아무것도 안 보여줌

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/register'); //회원가입 페이지로 이동
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "회원가입",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.person_add, color: Colors.blueAccent),
            ],
          ),
        );
      },
    );
  }
}
