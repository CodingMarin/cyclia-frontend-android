import 'package:cyclia/providers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartAuth extends ConsumerWidget {
  const StartAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authRepositoryProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.0),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 0),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Ink(
                  width: 250.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    gradient: LinearGradient(
                      colors: [Color(0xff1e51df), Color(0xff537ef7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Crear Cuenta",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 0),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Ink(
                  width: 250.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color(0xffEAEAEA),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Iniciar Sesión",
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 15.0),
                  ),
                  fixedSize: MaterialStateProperty.all(const Size(250, 40)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 31, 31, 31),
                  ),
                ),
                onPressed: () => authProvider.googleLogin(),
                icon: const Icon(Icons.account_balance_rounded),
                label: const Text('Inicia con Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
