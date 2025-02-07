import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmanager/auth.dart';
import 'package:taskmanager/provider/task_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;
  bool obscure = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    if (_controllerPassword.text == '' || _controllerEmail.text == '') {
      setState(() {
        errorMessage = 'Empty credentials!';
      });
      return;
    }

    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      ref.invalidate(taskListProvider);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_controllerPassword.text == '' || _controllerEmail.text == '') {
      setState(() {
        errorMessage = 'Empty credentials!';
      });
      return;
    }

    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Text('Firebase Authentication');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white38,
        contentPadding: EdgeInsets.all(20),
        // labelText: title,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Humm? $errorMessage',
      style: TextStyle(color: Colors.red, fontSize: 18),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(Size(125, 50)),
          backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF888AF5)),
        ),
        child: Text(
          isLogin ? "Login" : 'Sign Up',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin ? 'Get started!' : 'Login',
          style: TextStyle(color: Color(0xFF888AF5)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Color(0xFF888AF5),
                        borderRadius: BorderRadius.circular(18)),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  Text(
                    "Let's get started!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFF111827)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'EMAIL ADDRESS',
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      _entryField('email', _controllerEmail),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      TextField(
                        controller: _controllerPassword,
                        obscureText: obscure,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white38,
                            contentPadding: EdgeInsets.all(20),
                            // labelText: title,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: IconButton(
                              icon: Icon(obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                            )),
                      )
                    ],
                  ),
                  _errorMessage(),
                  _submitButton(),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    isLogin ? "Don't have an account?" : "Already an account?"),
                _loginOrRegisterButton(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
