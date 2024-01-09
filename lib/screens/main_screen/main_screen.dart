import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _messageController = TextEditingController();

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
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseDatabase.instance.ref().child('chats').onValue,
              builder: (context, snapshot) {
                Map result = (snapshot.data?.snapshot.value ?? []) as Map;
                List data = result.entries.map((e) => e.value).toList();

                print(data);

                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      title: Text(data[index]['message']),
                      subtitle: Text(data[index]['name']),
                    ),
                    itemCount: data.length,
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    User user = FirebaseAuth.instance.currentUser!;
                    FirebaseDatabase.instance.ref().child('chats').update({
                      '${user.uid}:${DateTime.now().millisecondsSinceEpoch}': {
                        'uid': user.uid,
                        'name': user.displayName,
                        'message': _messageController.text
                      }
                    });
                    FocusScope.of(context).unfocus();
                    _messageController.clear();
                  },
                  child: const Text("전송"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
