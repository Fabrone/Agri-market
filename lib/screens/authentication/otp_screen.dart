import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agri_market/screens/authentication/phone_auth_service.dart';

class OTPScreen extends StatefulWidget {
  final String? number;
  final String verId;

  const OTPScreen({super.key, this.number, required this.verId});

  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  bool _loading = false;
  String error = '';

  final PhoneAuthService _services = PhoneAuthService();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  Future<void> phoneCredential(BuildContext context, String otp) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verId, smsCode: otp);
      final User? user = (await auth.signInWithCredential(credential)).user;

      if (user != null) {
        if (context.mounted) {
        _services.addUser(context, user.uid); // Navigate to the next screen after successful login
        }
      } else {
        setState(() {
          error = 'Login Failed';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Invalid OTP';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Login', style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade200,
                child: const Icon(CupertinoIcons.person_alt_circle, size: 60, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              const Text('Welcome Back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'We sent a 6 digit code to ',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          TextSpan(text: widget.number, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Go back to PhoneAuthScreen
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          node.nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          node.previousFocus();
                        }

                        if (index == 5 && value.length == 1) {
                          String otp = _controllers.map((controller) => controller.text).join();
                          setState(() {
                            _loading = true;
                          });
                          phoneCredential(context, otp);
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              if (_loading)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 50,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
