
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:projeto_oh_campeao/models/user.dart';
import 'package:dio/dio.dart';


class Auth {
  static User user = User();

  static Future<bool> signIn(var obj) async {
    
    user = User.fromJson(obj);

    return true;

  }

  static Future<String> signUp(String cpf, String password, String name, String phone) async {
    return "Cadastrado";
  }

  static Future<void> signOut() async {
    
  }

  static Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    
  }

  static String getUserName() {

      if(user.name == null)
        return "";
      else 
        return user.name;

  }

  static String getUserEmail() {
    if(user.username == null)
        return "";
    else 
      return user.username;
  }

  static int getUserId() {
    if(user.idUser == null)
        return 0;
    else 
      return user.idUser;
  }

  static String getExceptionText(Exception error) {
    if (error is PlatformException) {
      return error.message;
    } else {
      return 'Unknown error occured.';
    }
  }
}
