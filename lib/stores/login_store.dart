import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_oh_campeao/services/auth.dart';
import 'package:dio/dio.dart';
import 'package:projeto_oh_campeao/services/menuList.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  
  @observable
  String cpf = "";

  @action
  void setCpf(String value) => cpf = value;

  @observable
  String password = "";

  @action
  void setPassword(String value) => password = value;

  @observable
  String phone = "";

  @action
  void setPhone(String value) => phone = value;

  @observable
  String name = "";

  @action
  void setname(String value) => name = value;

  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility() => passwordVisible = !passwordVisible;

  @observable
  bool loading = false;

  @observable
  bool loggedIn = false;

  @computed
  bool get isCpfValid => cpf.length <= 11 && cpf.length >= 1;

  @computed
  bool get isPasswordValid => password.length >= 1;

  @computed
  bool get isPhoneValid => phone.length == 11;

  @computed
  bool get isNameValid => name.length >= 1;

  @computed
  Function get loginPressed =>
      (isCpfValid && isPasswordValid && !loading) ? login : null;

  @computed
  Function get signUpPressed =>
      (isCpfValid && isPasswordValid && isPhoneValid && isNameValid && !loading) ? singUp : null;

  @computed
  Function get cleanPressed => () {
        cpf = "";
        password = "";
        phone = "";
        name = "";
      };

  @action
  Future<void> login() async {
    loading = true;
    
      Response response = await Dio().request(
        "http://192.168.15.10:8080/api/user/login/mobile/" + cpf + "/" + password,
        options: Options(
          headers: {"Accept": "application/json"},
          method: 'GET'
          )      
      );

      var user = response.data["resultData"];
    

      if (user != null){   

        await Auth.signIn(user);
    
        await Menu.menuList();
        //await Menu.orderList();
        //await Menu.orderTableList();

        loading = false;
        loggedIn = true;

        cpf = "";
        password = "";
      }
      else{

        print("erro");

        AlertDialog(title: Text("erro"));
        
        loading = false;

      }
    
    
  }

  @action
  Future<void> singUp() async {
    loading = true;

    await Future.delayed(Duration(seconds: 2));
    Auth.signUp(cpf, password, name, phone);

  //  await Menu.menuList();
   // await Menu.orderList();
   // await Menu.orderTableList();

    loading = false;
    loggedIn = true;

    cpf = "";
    password = "";
    name = "";
    phone = "";
  }

  @action
  void logout() {
    loggedIn = false;
    Auth.signOut();
  }

}

