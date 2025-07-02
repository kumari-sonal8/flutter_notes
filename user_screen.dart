import 'package:flutter/material.dart';
import 'package:blogs_flutter/data/local/user_db.dart'; // uses AppDatabase
import 'login_screen.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();

  final UserDB db = UserDB(); // ✅ updated class using AppDatabase
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    emailController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue.shade100,
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('WELCOME',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: nameController,
                      hint: 'Enter Name',
                      validator: (value) =>
                      value!.isEmpty ? 'Name is required' : null,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: passController,
                      hint: 'Enter Password',
                      obscure: true,
                      validator: (value) => value!.length < 6
                          ? 'Minimum 6 characters'
                          : null,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: emailController,
                      hint: 'Enter Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: idController,
                      hint: 'Enter ID',
                      validator: (value) =>
                      value!.isEmpty ? 'ID is required' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          print("Attempting registration...");
                          final result = await db.addUser(
                            uid: idController.text.trim(),
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passController.text,
                          );

                          if (result == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("User Registered Successfully")),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          } else if (result == 'duplicate') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("User ID already exists")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration failed. Try again")),
                            );
                          }
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
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
