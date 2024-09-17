import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:erdenet_divers/home.dart';
import 'package:erdenet_divers/pages/auth_service.dart';
import 'package:erdenet_divers/pages/sign_up.dart';

class SignIn extends StatefulWidget {
  static const route = '/login';
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = AuthService();

  late final String? name;
  late final String? email;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                child: Image.asset("assets/image/login.png"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(50),
              child: Text(
                'TH',
                style: TextStyle(fontFamily: 'MySoul', fontSize: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Center(
                child: _buildLoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoginForm() {
    return Container(
      color: Color.fromARGB(150, 255, 255, 255),
      width: double.infinity,
      height: 330,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нэвтрэх'),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Э-мэйл'),
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Э-мэйлээ оруулна уу!';
                  }
                  final regex = RegExp('[^@]+@[^\.]+\..+');
                  if (!regex.hasMatch(text)) {
                    return 'Э-мэйлээ зөв эсэхийг шалгана уу?';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(labelText: 'Нууц үг'),
                validator: (text) =>
                    text!.isEmpty ? 'Нууц үгээ оруулна уу!' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validate,
                child: const Text('Нэврэх'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Бүртгэл үүсгэх'),
                  TextButton(
                    child: Text(
                      'Бүртгүүлэх',
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  gotoHome(BuildContext context) => Navigator.of(context).pushReplacementNamed(
        Home.route,
        arguments: {
          name = _emailController.text,
          email = _passwordController.text
        },
      );

  void _validate() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    final user = await _auth.loginUserWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (user != null) {
      log('Amjilttai newterlee');
      gotoHome(context);
    }
  }
}
