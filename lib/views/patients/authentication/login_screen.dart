import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:magani_shop/views/patients/authentication/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isSigning = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  void _signIn() async {
    try {
      setState(() {
        _isSigning = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      setState(() {
        _isSigning = false;
      });

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "/mainScreen");
    } catch (e) {
      setState(() {
        _isSigning = false;
      });
      // ignore: avoid_print
      print('Erreur lors de la connexion : $e');
      Fluttertoast.showToast(
        msg: 'Veillez verifier les details de connexion',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Logo
                    logo(170, 170),
                    SizedBox(height: size.height * 0.06),
                  ],
                ),
                //From
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildEmailTextField(),
                      SizedBox(height: size.height * 0.03),
                      buildPasswordField(),
                      SizedBox(height: size.height * 0.03),
                      signInButton(size),
                      SizedBox(height: size.height * 0.03),

                      // Footer
                      const SizedBox(height: 20),
                      const BuildFooter(),
                      SizedBox(height: size.height * 0.03),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      onChanged: (value) {
        setState(() {
          _password = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Iconsax.password_check),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(_isPasswordVisible ? Iconsax.eye_slash : Iconsax.eye),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF25D366),
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/images/logiin.png',
      height: height_,
      width: width_,
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _email = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre email';
        } else if (!isValidEmail(value)) {
          return 'Veuillez entrer une adresse email valide';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "E-mail",
        prefixIcon: const Icon(Iconsax.direct_right),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  Widget signInButton(Size size) {
    return GestureDetector(
      onTap: () {
        _signIn();
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: _isSigning
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Login',
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  bool isValidEmail(String value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }
}

class BuildFooter extends StatelessWidget {
  const BuildFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Don't have an account?",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
