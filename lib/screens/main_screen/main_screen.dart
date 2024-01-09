import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("채팅룸"),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance.ref().child('chats').onValue,
          builder: (context, snapshot) {
            List data = (snapshot.data?.snapshot.value ?? []) as List;

            print(data);

            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(data[index]['message']),
                subtitle: Text(data[index]['name']),
              ),
              itemCount: data.length,
            );
          },
        ),
      ),
    );
  }
}
