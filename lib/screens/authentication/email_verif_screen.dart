import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/phone_auth_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  static const String id = 'email-verification';

  @override
  EmailVerificationScreenState createState() => EmailVerificationScreenState();
}

class EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isCheckingVerification = false;

  @override
  void initState() {
    super.initState();
    _sendEmailVerification(); // Send verification email on page load
  }

  Future<void> _sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent! Check your inbox.')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email: $e')),
        );
      }
    }
  }

  Future<void> _checkEmailVerification() async {
    setState(() {
      _isCheckingVerification = true;
    });

    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload(); // Reload user to get updated info
      user = _auth.currentUser;

      if (user!.emailVerified) {
        if (!mounted) return;

        // Navigate to PhoneAuthScreen after email is verified
        Navigator.pushReplacementNamed(context, PhoneAuthScreen.id);
        return; // Exit after navigation to prevent further execution
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email not verified yet. Please check your inbox.')),
    );

    setState(() {
      _isCheckingVerification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Text(
                'Check your email to verify your registered email address. Once verified, you will be redirected to the next step.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
                onPressed: _sendEmailVerification,
                child: const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
                onPressed: _isCheckingVerification ? null : _checkEmailVerification,
                child: _isCheckingVerification
                    ? const CircularProgressIndicator()
                    : const Text('I Have Verified My Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
