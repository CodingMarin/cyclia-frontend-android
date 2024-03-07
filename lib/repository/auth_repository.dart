import 'dart:convert';

import 'package:cyclia/models/error_model.dart';
import 'package:cyclia/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
  })  : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: 'Some unexpected error occurred');
    try {
      final data = await _googleSignIn.signIn();
      if (data != null) {
        final user = UserModel(
          name: data.displayName!,
          email: data.email,
          photoUrl: data.photoUrl!,
        );

        var response = await _client.post(
            Uri.parse('http://localhost:8000/signup'),
            body: user.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            });

        switch (response.statusCode) {
          case 200:
            final newUser = user.copyWith(
              uuid: jsonDecode(response.body)['user']['uuid'],
            );
            error = ErrorModel(data: newUser);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
      );
    }
    return error;
  }
}
