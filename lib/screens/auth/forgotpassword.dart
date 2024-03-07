import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  bool isLoading = false, isErrEmail = false;
  String errEmail = "";

  Future forgotPassword() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text.trim())
          .then((value) => {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Recuperar cuenta"),
                          content: const Text(
                              "Revise su correo y confirme el link para cambiar la contrasena."),
                          actions: [
                            MaterialButton(
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text(
                                "Aceptar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isErrEmail = true;
          errEmail = 'El correo no existe.';
        });
      } else if (e.code == 'unknown') {
        setState(() {
          isErrEmail = true;
          errEmail = 'Complete los campos.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          isErrEmail = true;
          errEmail = 'Correo invalido.';
        });
      } else if (e.code == 'network-request-failed') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text("Error internet"),
                    content: const Text("Compuebe su conexion a internet."),
                    actions: [
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Aceptar",
                            style: TextStyle(color: Colors.white)),
                      )
                    ]));
      }
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/Vectorback-logo.png',
                      width: 300.0,
                      height: 150.0,
                    ),
                    const Text(
                      'Iniciar Session',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40.0),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Correo Electronico',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onTap: () => setState(() => isErrEmail = false),
                      controller: _emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introdusca un correo';
                        }
                        String pattern = r'\w+@\w+\.\w+';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(_emailTextController.text)) {
                          return 'La direccion de correo es invalida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Visibility(
                          visible: isErrEmail,
                          child: Text(
                            errEmail,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12.0),
                          )),
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: !isLoading
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 0))),
                              onPressed: (() {
                                if (_formKey.currentState!.validate()) {
                                  forgotPassword();
                                }
                              }),
                              child: Ink(
                                width: 250.0,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff1e51df),
                                      Color(0xff537ef7)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0, minHeight: 36.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Recuperar cuenta",
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Tengo una cuenta",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 38, 101, 238)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
