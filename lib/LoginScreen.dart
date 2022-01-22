import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:stopwatch/MyStopWatch.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = "";
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: _buildLoginForm(),
      ),
    );
  }
  Widget _buildLoginForm(){
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Runner'),
              validator: (text) => text != null && text.isEmpty  ? "Enter the runner's name." : null
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (text) {
                   if(text == null) return text;
                   if(text.isEmpty) return "Enter the runner's email.";
                   final regex = RegExp('[^@]+@[^\.]+\..+');
                   if(!regex.hasMatch(text)){
                     return "Enter a valid email";
                   }
                   return null;
              }
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Continue'),
              onPressed: _validate,
            )
          ],
        )
      ),
    );
  }
  void _validate(){
    final form = _formKey.currentState;
    if(!form!.validate()){
      return;
    }
      final name = _nameController.text;
      final email = _emailController.text;
      Navigator.of(context).pushReplacementNamed(MyStopWatch.route,arguments: name);
  }
}
