import 'package:blogs_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:blogs_flutter/data/local/user_db.dart'; // ✅ Uses AppDatabase
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final idController = TextEditingController();

  final UserDB db = UserDB(); // ✅ Updated class
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.blue.shade100,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Welcome Back",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: nameController,
                    hint: 'Enter Username',
                    validator: (value) =>
                    value!.isEmpty ? 'Username required' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: passController,
                    hint: 'Enter Password',
                    obscure: true,
                    validator: (value) =>
                    value!.isEmpty ? 'Password required' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: idController,
                    hint: 'Enter ID',
                    validator: (value) =>
                    value!.isEmpty ? 'ID required' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final user = await db.loginUser(
                          uid: idController.text.trim(),
                          name: nameController.text.trim(),
                          password: passController.text,
                        );

                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Successful")),
                          );

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('uid', idController.text);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invalid credentials")),
                          );
                        }
                      }
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
      ),
    );
  }
}
