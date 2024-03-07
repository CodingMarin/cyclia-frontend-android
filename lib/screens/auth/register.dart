import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cyclia/screens/auth/authgate.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameTextController = TextEditingController();
  final _pass1TextController = TextEditingController();
  final _pass2TextController = TextEditingController();
  final _emailTextController = TextEditingController();

  bool isLoading = false,
      isLoadingGoogle = false,
      isErrEmail = false,
      isErrPass1 = false,
      isErrPass2 = false;
  String errEmail = "", errPass1 = "", errPass2 = "";

  signIn() async {
    setState(() => isLoading = true);
    if (_pass1TextController.text.trim() != _pass2TextController.text.trim()) {
      setState(() {
        isErrPass2 = true;
        errPass2 = 'La contraseña no son iguales.';
      });
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailTextController.text.trim(),
          password: _pass2TextController.text.trim(),
        )
            .then((res) {
          res.user?.updateDisplayName(_fullNameTextController.text);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthGate()),
            (Route<dynamic> route) => false,
          );
        });
      } on FirebaseAuthException catch (e) {
        debugPrint('$e.code $e.message');
        if (e.code == 'weak-password') {
          setState(() {
            isErrPass1 = true;
            errPass1 = 'La contraseña proporcionada es demasiado débil.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            isErrEmail = true;
            errEmail = 'La cuenta ya existe.';
          });
        }
      }
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameTextController.dispose();
    _pass1TextController.dispose();
    _pass2TextController.dispose();
    _emailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Registrate',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40.0),
                    )
                  ],
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
                        'Nombre Completo',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _fullNameTextController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introdusca un nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Contraseña',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onTap: () => setState(() => isErrPass1 = false),
                        controller: _pass1TextController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introdusca una Contraseña';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                          visible: isErrPass1,
                          child: Text(
                            errPass1,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12.0),
                          )),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Repetir Contraseña',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onTap: () => setState(() => isErrPass2 = false),
                        controller: _pass2TextController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introdusca una Contraseña';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                          visible: isErrPass2,
                          child: Text(
                            errPass2,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12.0),
                          )),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Correo Electronico',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        textInputAction: TextInputAction.done,
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
                      Visibility(
                          visible: isErrEmail,
                          child: Text(
                            errEmail,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12.0),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: [
                      const Text(
                        'Al registrarte, aceptarás nuestros',
                        softWrap: false,
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Términos y condiciones",
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                              color: Color.fromARGB(255, 38, 101, 238)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                !isLoading
                    ? ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 0))),
                        onPressed: (() {
                          if (_formKey.currentState!.validate()) {
                            signIn();
                          }
                        }),
                        child: Ink(
                          width: 250.0,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            gradient: LinearGradient(
                              colors: [Color(0xff1e51df), Color(0xff537ef7)],
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
                                "Registrarte",
                                style: TextStyle(fontSize: 18.0),
                              )),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya dispones de una cuenta?',
                      softWrap: false,
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Ingresa aquí",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 38, 101, 238)),
                      ),
                    ),
                  ],
                ),
                !isLoadingGoogle
                    ? ElevatedButton.icon(
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 15.0)),
                            fixedSize:
                                MaterialStateProperty.all(const Size(250, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 31, 31, 31))),
                        // onPressed: () =>
                        onPressed: () {},
                        icon: Icon(Icons.account_balance_rounded),
                        label: const Text('Registrate con Google'))
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
