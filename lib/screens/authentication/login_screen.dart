import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state
  bool _obscureText = true; // Password visibility toggle

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/login.png',
                width: 200.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'User Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 52, 211, 46),
                ),
              ),
              const SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your registered password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Start loading
                          });
                          try {
                            // Attempt to sign in with email and password
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );

                            // Check if the widget is still mounted before navigating
                            if (!mounted) return;

                            // Navigate to home screen on successful login
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacementNamed('/home');
                          } on FirebaseAuthException catch (e) {
                            // Handle errors (e.g., wrong password, user not found)
                            String message;
                            if (e.code == 'user-not-found') {
                              message = 'No user found for that email.';
                            } else if (e.code == 'wrong-password') {
                              message = 'Wrong password provided for that user.';
                            } else {
                              message = 'Login failed: ${e.message}';
                            }

                            // Check if the widget is still mounted before showing the SnackBar
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          } finally {
                            // Stop loading if the widget is still mounted
                            if (mounted) {
                              setState(() {
                                _isLoading = false; // Stop loading
                              });
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.email),
                      label: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _isLoading = true; // Start loading
                  });
                  final user = await googleSignInProvider.loginWithGoogle();

                  // Immediately check if the widget is still mounted after the async call
                  if (!mounted) {
                    setState(() {
                      _isLoading = false; // Stop loading if not mounted
                    });
                    return;
                  }

                  if (user != null) {
                    
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    // Check if the widget is still mounted before showing the SnackBar
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google login failed.')),
                      );
                    }
                  }

                  // Stop loading if the widget is still mounted
                  if (mounted) {
                    setState(() {
                      _isLoading = false; // Stop loading
                    });
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                ),
                label: const Text(
                  'Login with Google',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: const Text(
                  'Do not have an account? Sign Up',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInProvider {
  final googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;
  final Logger logger = Logger(); // Initialize logger

  Future<User?> loginWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      logger.e('Google login error: $e'); // Use logger instead of print
      return null;
    }
  }
}
