//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:magani_shop/views/patients/authentication/auth_controller.dart';
import 'package:magani_shop/views/patients/authentication/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSignup = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _fullName = "";
  String _email = "";
  int _phoneNumber = 0;
  String _password = "";
  String _confirmPassword = "";

  Future<void> _signUp() async {
    try {
      setState(() {
        _isSignup = true;
      });
      await _authController.signUpUser(
          _fullName, _email, _phoneNumber, _password, _confirmPassword);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "/mainScreen");
    } catch (e) {
      setState(() {
        _isSignup = false;
      });
      Fluttertoast.showToast(
        msg: 'Une erreur s\'est produite lors de l\'inscription',
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLogo(110, 110),
                    SizedBox(height: size.height * 0.03),
                    _buildRegisterText(),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildFullNameTextField(),
                      SizedBox(height: size.height * 0.03),
                      _buildEmailTextField(),
                      SizedBox(height: size.height * 0.03),
                      _buildPhoneNumberTextField(),
                      SizedBox(height: size.height * 0.03),
                      _buildPasswordField(),
                      SizedBox(height: size.height * 0.03),
                      _buildConfirmPasswordField(),
                      SizedBox(height: size.height * 0.03),
                      _buildSignUpButton(size),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
                _buildFooter(),
                SizedBox(height: size.height * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildConfirmPasswordField() {
    return TextFormField(
      validator: (value) {
        final String password = _password;
        if (value == null || value.isEmpty) {
          return 'Veuillez confirmer votre mot de passe';
        } else if (value != password) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      },
      obscureText: !_isConfirmPasswordVisible,
      onChanged: (value) {
        setState(() {
          _confirmPassword = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Confirmer le mot de passe',
        prefixIcon: const Icon(Iconsax.password_check),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
          icon:
              Icon(_isConfirmPasswordVisible ? Iconsax.eye_slash : Iconsax.eye),
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
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _password = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        return null;
      },
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
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
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return const Center(
      child: Text(
        'Créer un compte',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLogo(double height, double width) {
    return Image.asset(
      'assets/images/form.png',
      height: height,
      width: width,
    );
  }

  Widget _buildSignUpButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          _signUp();
        }
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
        child: _isSignup
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Créer un compte',
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

  TextFormField _buildEmailTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _email = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre adresse e-mail';
        } else if (!_isValidEmail(value)) {
          return 'Veuillez entrer une adresse e-mail valide';
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

  bool _isValidEmail(String value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  TextFormField _buildFullNameTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _fullName = value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre nom complet';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Nom complet",
        prefixIcon: const Icon(Iconsax.user),
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

  TextFormField _buildPhoneNumberTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _phoneNumber = int.parse(value);
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre numéro de téléphone';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Numéro de téléphone",
        prefixIcon: const Icon(Iconsax.call),
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

  Widget _buildFooter() {
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
            "Vous avez déjà un compte?",
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
