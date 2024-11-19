// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybuddyapp/screens/home.dart'; // Import your volunteer home screen
import 'package:mybuddyapp/screens/parenthome.dart'; // Import your parent home screen

class LoginScreen extends StatefulWidget {
  final VoidCallback onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
  // Show loading circle
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    // Log in the user
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    User? user = userCredential.user;

    // Fetch user role from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Retrieve and clean the role from userData
      String role = (userData['role'] as String).trim().toLowerCase(); // Trim and make it lowercase

      // Debug print to ensure role is being retrieved

      // Check if the widget is still mounted before navigating
      if (!mounted) return;

      // Check if role is 'parent' or 'volunteer' and navigate accordingly
      if (role == 'parent') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
        );
      } else if (role == 'volunteer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VolunteerHomeScreen()),
        );
      } else {
      }
    } else 
    {
    }
  } on FirebaseAuthException catch (e) {
    // Close the loading circle
    if (mounted) {
      Navigator.pop(context);

      // Show error message
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
          break;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const Text(
                  'Back!',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Sign in to access your account and meet with potential Buddies or your real Buddies',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail, color: Colors.black),
                    labelText: 'Enter your mail/phone number',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    labelText: 'Enter your password',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (newValue) {},
                        ),
                        const Text('Remember me', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: login,
                  icon: const Icon(Icons.account_circle, color: Colors.black),
                  label: const Text('Sign in with Account', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: Colors.purple),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 95.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or', style: TextStyle(color: Colors.black)),
                    ),
                    Expanded(child: Divider(color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Google sign-in
                  },
                  icon: const Icon(Icons.account_circle, color: Colors.black),
                  label: const Text('Sign in with Google', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: Colors.purple),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
                  ),
                ),
                const SizedBox(height: 4.0),
                Center(
                  child: TextButton(
                    onPressed: widget.onTap,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
