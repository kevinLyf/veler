import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:veler/features/screens/menu/menu_screen.dart';
import 'package:veler/features/screens/signup/signup_screen.dart';
import 'package:veler/shared/services/auth/Auth.dart';
import 'package:veler/shared/services/auth/LocalAuth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    tryUsingBiometrics();
    super.initState();
  }

  void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(strokeAlign: 3),
            ],
          ),
        );
      },
    );
  }

  void showSnackBar(String title, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
        ),
      ),
    );
  }

  Future<void> tryUsingBiometrics() async {
    await Auth.getId().then((id) async {
      if (id.isEmpty || id == "") return;

      if (await LocalAuth().authenticate()) {
        showSnackBar(
          "Autenticação Biométrica feita com sucesso",
          Icons.fingerprint_rounded,
          Colors.green,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MenuScreen(),
          ),
        );
      } else {
        showSnackBar(
          "Biometria fracassou",
          Icons.fingerprint_rounded,
          Colors.red,
        );
      }
    });
  }

  Future<void> handleLogin() async {
    Map<String, dynamic> data = {
      "email": _emailController.text,
      "password": _passwordController.text
    };

    try {
      final response = await http
          .post(Uri.parse("http://10.0.2.2:3000/auth/signin"), body: data);

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Auth.setId(body["id"]);
        Auth.setName(body["name"]);
        Auth.setEmail(body["email"]);
        Auth.setPassword(body["password"]);
        Auth.setAdmin(body["admin"]);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MenuScreen(),
          ),
        );
      } else {
        showSnackBar(body["error"], Icons.warning_rounded, Colors.red);
      }
    } catch (err) {
      showSnackBar("Something went wrong", Icons.router_outlined, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("public/assets/icons/logo.png"),
              ),
              const SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_rounded,
                          color: Color(0xffBCBCBC),
                        ),
                        hintText: "joedoe@test.com",
                        hintStyle: const TextStyle(
                          fontFamily: "Nunito",
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) return "This field is required";
                        if (!RegExp(r"^[a-zA-Z-0-9_.@]+$").hasMatch(value))
                          return "Only characters from a-z, A-Z, 0-9";

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password_rounded,
                          color: Color(0xffBCBCBC),
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          fontFamily: "Nunito",
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) return "This field is required";
                        if (!RegExp(r"^[a-zA-Z-0-9_.@]+$").hasMatch(value))
                          return "Only characters from a-z, A-Z, 0-9";

                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) handleLogin();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w800,
                      color: Color(0xffBCBCBC),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: Text(
                      "Sign up.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
