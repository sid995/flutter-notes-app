import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),

        /// Future handles async
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(hintText: "Enter email"),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration:
                            const InputDecoration(hintText: "Enter password"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              print("userCredential $userCredential");
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "weak-password") {
                                print("Weak password");
                              } else if (e.code == "invalid-email") {
                                print("Invalid email");
                              } else if (e.code == "email-already-in-use") {
                                print("Email already in use");
                              } else {
                                print("Some error");
                                print(e.code);
                              }
                            }
                          },
                          child: const Text("Register"),
                        ),
                      ),
                    ],
                  ),
                );

              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}
