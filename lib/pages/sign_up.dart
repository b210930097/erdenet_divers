import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:erdenet_divers/home.dart';
import 'package:erdenet_divers/pages/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
      height: 340,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Нэвтрэх нэр'),
                validator: (text) => text!.isEmpty ? 'Нэрээ оруулна уу!' : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
                decoration: const InputDecoration(labelText: 'Нууц үг'),
                validator: (text) =>
                    text!.isEmpty ? 'Нууц үгээ оруулна уу!' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Бүртгүүлэх'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Надад бүртгэл байгаа'),
                  TextButton(
                    child: Text(
                      'Нэвтрэх',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
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

  gotoHome(BuildContext context) =>
      Navigator.pop(context, MaterialPageRoute(builder: (context) => Home()));

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (user != null) {
      log('Amjilttai bvrtgvvlle');
      gotoHome(context);
    }
  }
}
