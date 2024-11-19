import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import for Firestore
import 'package:mybuddyapp/auth/login_or_register.dart';
import 'package:mybuddyapp/screens/home.dart';
import 'package:mybuddyapp/screens/parenthome.dart'; // Ensure this is imported

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is not logged in
          if (!snapshot.hasData) {
            return const LoginOrRegister();
          }

          // User is logged in, now fetch their role from Firestore
          final User? user = snapshot.data;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get(),
            builder: (context, snapshot) {
              // Show a loading indicator while waiting for Firestore
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check for errors
              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Error loading user data.'));
              }

              // Get user data and role
              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              final String? role = userData?['role'];

              // Navigate based on role
              if (role == 'parent') {
                return const ParentHomeScreen(); // Parent home screen
              } else if (role == 'volunteer') {
                return const VolunteerHomeScreen(); // Volunteer home screen
              } else {
                // If no role is found, show an error or redirect to login
                return const Center(child: Text('Invalid role.'));
              }
            },
          );
        },
      ),
    );
  }
}
