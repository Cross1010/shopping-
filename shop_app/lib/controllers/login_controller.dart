import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/user_provider.dart';

import '../widgets/widgets.dart';

class LoginController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BuildContext? context;

  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  UsersProvider usersProvider = UsersProvider();

  SecureStogare secureStogare = SecureStogare();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);

    String userJson = await secureStogare.read('user');

    if (userJson != 'null') {
      User? user = User.fromMap(jsonDecode(userJson));
      print('USUARIO LOGIN: ${user.toJson()}');

      if (user.sessionToken != null) {
        if (user.roles!.length > 1) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/roles',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            user.roles![0].route,
            (route) => false,
          );
        }
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, '/register');
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      ResponseApi responseApi = await usersProvider.login(email, password);

      if (responseApi.success) {
        User user = User.fromMap(responseApi.data);

        secureStogare.save('user', user.toJson());

        print('USUARIO LOGIN: ${user.toJson()}');

        if (user.roles!.length > 1) {
          Navigator.pushNamedAndRemoveUntil(
            context!,
            '/roles',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context!,
            user.roles![0].route,
            (route) => false,
          );
        }
      } else {
        Snackbar.show(context, responseApi.message);
      }
    }
  }
}
