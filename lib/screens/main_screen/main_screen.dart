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
    User user = FirebaseAuth.instance.currentUser!;
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
                List data = (snapshot.data?.snapshot.value ?? []) as List;
                print(data); // log

                data = data.reversed.toList();

                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: user.uid == data[index]['uid']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(data[index]['name']),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                data[index]['message'],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                  onPressed: () async {
                    User user = FirebaseAuth.instance.currentUser!;
                    DataSnapshot data = await FirebaseDatabase.instance
                        .ref()
                        .child('chats')
                        .get();

                    FirebaseDatabase.instance.ref().child('chats').update({
                      '${data.children.length}': {
                        'uid': user.uid,
                        'name': user.displayName,
                        'message': _messageController.text,
                      }
                    });
                    if (context.mounted) {
                      FocusScope.of(context).unfocus();
                      _messageController.clear();
                    }
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
