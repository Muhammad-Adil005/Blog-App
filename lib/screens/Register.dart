import 'package:blog_app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth/authentication.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationHelper _authHelper = AuthenticationHelper();

  String? _email;
  String? _password;
  String _errorMessage = '';

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? result =
          await _authHelper.createAccount(email: _email!, password: _password!);

      if (result == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        setState(() {
          _errorMessage = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _email = value,
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) => value!.length < 6
                    ? 'Password should be at least 6 characters'
                    : null,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('Create Account'),
              ),
              SizedBox(height: 16.h),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to previous screen
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
