import 'package:chat_application/screens/main_screen/main_screen.dart';
import 'package:chat_application/screens/signin_screen/signin_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instanceFor(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return const MainScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
