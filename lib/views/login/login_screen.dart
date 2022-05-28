import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_oh_campeao/views/home/home_page.dart';
import 'package:projeto_oh_campeao/views/login/sign_up.page.dart';
import 'package:projeto_oh_campeao/widgets/custom_icon_button.dart';
import 'package:projeto_oh_campeao/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:projeto_oh_campeao/stores/login_store.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginStore loginStore;

  ReactionDisposer disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loginStore = Provider.of<LoginStore>(context);

    disposer = reaction((_) => loginStore.loggedIn, (loggedIn) {
      if (loggedIn)
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
     
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: 
          Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      '',
                      height: 80,
                    ),
                    Observer(
                      builder: (_) {
                        return CustomTextField(
                          hint: 'CPF',
                          prefix: Icon(Icons.account_circle),
                          textInputType: TextInputType.number,
                          onChanged: loginStore.setCpf,
                          enabled: !loginStore.loading,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(
                      builder: (_) {
                        return CustomTextField(
                          hint: 'Senha',
                          prefix: Icon(Icons.lock),
                          obscure: !loginStore.passwordVisible,
                          onChanged: loginStore.setPassword,
                          enabled: !loginStore.loading,
                          suffix: CustomIconButton(
                            radius: 32,
                            iconData: loginStore.passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onTap: loginStore.togglePasswordVisibility,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Observer(
                          builder: (_) {
                            return SizedBox(
                              height: 44,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: loginStore.loading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      )
                                    : Text('Login'),
                                color: Theme.of(context).primaryColor,
                                disabledColor: Theme.of(context)
                                    .primaryColor
                                    .withAlpha(100),
                                textColor: Colors.white,
                                onPressed: loginStore.loginPressed,
                              ),
                            );
                          },
                        ),
                        Observer(builder: (_) {
                          return SizedBox(
                            height: 44,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Text('Cadastrar'),
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                                  Theme.of(context).primaryColor.withAlpha(100),
                              textColor: Colors.white,
                              onPressed: () {
                                loginStore.cleanPressed;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }
}
