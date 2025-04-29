import 'package:flutter/material.dart';
import 'package:flutter_uilogin/provider/auth_provider.dart';
import 'package:flutter_uilogin/widget/textfield/textfield_email_widget.dart';
import 'package:flutter_uilogin/widget/textfield/textfield_pass_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);
    return Container(
      color: const Color.fromARGB(255, 29, 29, 29),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4 - 20,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 42, 127, 224),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height / 4 - 20,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 42, 127, 224),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 250, 250, 250),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Form(
                          key: loadAuth.form,
                          child: Column(
                            children: [
                              Image.asset(
                                "images/logo del.png",
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                              const SizedBox(height: 15),
                              TextfieldEmailWidget(controller: email),
                              const SizedBox(height: 15),
                              TextfieldPasswordWidget(controller: password),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    loadAuth.submit();
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
