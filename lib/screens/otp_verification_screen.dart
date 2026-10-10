import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _otpController = TextEditingController();

  late String _verificationId;

  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();

    _verificationId = widget.verificationId;
  }

  // =========================
  // VERIFY OTP
  // =========================
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showMessage("Please enter the OTP.");
      return;
    }

    if (otp.length != 6) {
      _showMessage("Please enter the 6-digit OTP.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create phone credential
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      // Current Firebase user
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        _showMessage("Your account session has expired. Please sign up again.");

        setState(() {
          _isLoading = false;
        });

        return;
      }

      // Link phone number with email/password account
      await currentUser.linkWithCredential(credential);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phone verified successfully! 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      // Go to Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
    // =========================
    // FIREBASE OTP ERROR
    // =========================
    on FirebaseAuthException catch (e) {
      print("🔥 OTP ERROR CODE: ${e.code}");
      print("🔥 OTP ERROR MESSAGE: ${e.message}");

      String message;

      switch (e.code) {
        case 'invalid-verification-code':
          message = "Incorrect OTP. Please check the code and try again.";
          break;

        case 'invalid-verification-id':
          message = "This OTP has expired. Please request a new code.";
          break;

        case 'credential-already-in-use':
          message = "This phone number is already linked to another account.";
          break;

        case 'provider-already-linked':
          message = "This phone number is already linked to your account.";
          break;

        case 'session-expired':
          message = "OTP session expired. Please request a new code.";
          break;

        case 'too-many-requests':
          message = "Too many attempts. Please try again later.";
          break;

        case 'network-request-failed':
          message = "Please check your internet connection.";
          break;

        default:
          message =
              "Firebase Error: ${e.code}\n"
              "${e.message ?? ''}";
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(message);
    }
    // =========================
    // GENERAL ERROR
    // =========================
    catch (e) {
      print("🔥 GENERAL OTP ERROR: $e");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage("Something went wrong. Please try again.");
    }
  }

  // =========================
  // RESEND OTP
  // =========================
  Future<void> _resendOtp() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final User? user = _auth.currentUser;

            if (user != null) {
              await user.linkWithCredential(credential);
            }
          } catch (e) {
            print("🔥 AUTO PHONE VERIFICATION ERROR: $e");
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          print("🔥 RESEND OTP ERROR: ${e.code}");

          if (!mounted) return;

          setState(() {
            _isResending = false;
          });

          _showMessage("Could not send OTP: ${e.message}");
        },

        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;

          setState(() {
            _verificationId = verificationId;
            _isResending = false;
          });

          _otpController.clear();

          _showMessage("A new OTP has been sent to your phone.");
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print("🔥 RESEND GENERAL ERROR: $e");

      if (!mounted) return;

      setState(() {
        _isResending = false;
      });

      _showMessage("Could not resend OTP. Please try again.");
    }
  }

  // =========================
  // SHOW MESSAGE
  // =========================
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 30),

              // =========================
              // ICON
              // =========================
              Container(
                width: 80,
                height: 80,

                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.sms_outlined,
                  size: 38,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // TITLE
              // =========================
              const Text(
                "Verify Your Phone",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Enter the 6-digit code we sent to",
                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 6),

              // Phone number
              Text(
                widget.phoneNumber,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 35),

              // =========================
              // OTP FIELD
              // =========================
              TextField(
                controller: _otpController,

                keyboardType: TextInputType.number,

                maxLength: 6,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                ),

                decoration: InputDecoration(
                  hintText: "••••••",

                  counterText: "",

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // VERIFY BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,

                    foregroundColor: Colors.white,

                    disabledBackgroundColor: Colors.black54,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: _isLoading
                      ? const SizedBox(
                          width: 23,
                          height: 23,

                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "VERIFY CODE",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // RESEND OTP
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    "Didn't receive the code? ",

                    style: TextStyle(color: Colors.black54),
                  ),

                  GestureDetector(
                    onTap: _isResending ? null : _resendOtp,

                    child: Text(
                      _isResending ? "Sending..." : "Send again",

                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
