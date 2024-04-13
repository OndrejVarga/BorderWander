import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/utils/error_alert.dart';
import '../auth_widgets/text_field_form.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      String email,
      String password,
      String anotherPassword,
      String username,
      Color color,
      bool isLogIn,
      BuildContext context,
      int weight) submitAuthForm;
  final bool isLoading;
  final FirebaseAuth auth;

  AuthForm(this.submitAuthForm, this.isLoading, this.auth);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _anotherPassword = '';
  String _username = '';
  int _weight = 0;
  bool _isLogIn = true;
  Color _currentColor = HexColor('00B349');

  void changeColor(Color color) {
    setState(() => _currentColor = color);
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final validated = _formKey.currentState.validate();
    if (validated) {
      _formKey.currentState.save();
      if (_weight == 0 && !_isLogIn) {
        //Show user the weight is missing
        ErrorAlert.showError(context, "You didn't enter the weight");
      } else if ((_password != _anotherPassword) && !_isLogIn) {
        //Show user the passwords are not the same
        ErrorAlert.showError(context, 'Enter the same password');
      } else {
        //Try to register / login when data is ok
        _formKey.currentState.save();
        widget.submitAuthForm(_email.trim(), _password, _anotherPassword,
            _username, _currentColor, _isLogIn, context, _weight);
      }
    }
  }

  //Reseting password
  Future<void> _passwordChange(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            'You will receive an email with password recovery',
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
          ),
          content: TextField(
            autofocus: true,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
            controller: _textFieldController,
            decoration: InputDecoration(
              labelStyle:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
              labelText: 'Email',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Ok',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 15),
              ),
              onPressed: () {
                String email = _textFieldController.text;
                widget.auth.sendPasswordResetEmail(email: email);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //Chosing color
  Future<void> _getColor(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            'Choose a color!',
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              enableAlpha: false,
              showLabel: false,
              displayThumbColor: false,
              pickerAreaHeightPercent: 0.8,
              pickerColor: _currentColor,
              onColorChanged: (color) {
                changeColor(color);
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  //Getting weight of user
  Future<void> _getWeight(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            'Enter your weight (kg)',
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
          ),
          content: TextField(
            autofocus: true,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
            keyboardType: TextInputType.number,
            controller: _textFieldController,
            decoration: InputDecoration(
              labelStyle:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
              labelText: 'Weight',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "I don't want to",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 15),
              ),
              onPressed: () {
                _weight = 80;
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Ok',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 15),
              ),
              onPressed: () {
                _weight = int.tryParse(_textFieldController.text);
                if (_weight != null && _weight > 20 && _weight < 150) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //Main Title----------------------------------------------------------
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 5),
              child: Text(
                _isLogIn ? 'Log in' : 'Register',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 30),
              ),
            ),
            Image.asset(
              'assets/images/Logo1.png',
              height: 45,
            ),
          ]),

          //Subtitle------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 20, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'To continue ${_isLogIn ? 'log in' : 'register'}',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: 20),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),

          //Registration Form---------------------------------------------------
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //EmailForm---------------------------------------------------
                  TextFieldForm(
                    'Email',
                    Icons.mail_outline_rounded,
                    TextInputType.emailAddress,
                    (String value) {
                      _email = value;
                    },
                    (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  //NameForm----------------------------------------------------
                  if (!_isLogIn)
                    TextFieldForm(
                      'Username',
                      Icons.accessibility,
                      TextInputType.text,
                      (String value) {
                        _username = value;
                      },
                      (value) {
                        if (value.isEmpty ||
                            value.toString().length < 4 ||
                            value.toString().length > 10) {
                          return 'The username must be 4 to 10 characters';
                        } else if (!Provider.of<DataFetcher>(context,
                                listen: false)
                            .checkValiability(value)) {
                          return 'This name is already taken';
                        }
                        return null;
                      },
                    ),

                  //Password----------------------------------------------------
                  TextFieldForm(
                    'Password',
                    Icons.lock_open_rounded,
                    TextInputType.text,
                    (String value) {
                      _password = value;
                    },
                    (value) {
                      if (value.isEmpty ||
                          value.toString().length < 6 ||
                          value.toString().length > 12) {
                        return 'The password must be 6 to 12 characters long';
                      }
                      return null;
                    },
                    obscureTxt: true,
                  ),

                  //Another password--------------------------------------------
                  if (!_isLogIn)
                    TextFieldForm('Password Again', Icons.lock_open_rounded,
                        TextInputType.text, (String value) {
                      _anotherPassword = value;
                    }, (value) {
                      if (value.isEmpty) {
                        return 'Please enter the same password';
                      }
                      return null;
                    }, obscureTxt: true),

                  //Weight button-----------------------------------------------
                  if (!_isLogIn)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Theme.of(context).backgroundColor,
                              primary: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () => _getWeight(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 28),
                              child: Text(
                                'Weight',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(width: 50),

                          //ColorButton-----------------------------------------
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Theme.of(context).backgroundColor,
                              primary: Theme.of(context).cardColor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () => _getColor(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 25),
                              child: Text(
                                'Color of\nterritory',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  //Submiting Buttons-------------------------------------------
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Theme.of(context).backgroundColor,
                        primary: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _trySubmit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 35),
                        child: widget.isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                _isLogIn ? 'Log in' : 'Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: 20,
                                        color:
                                            Theme.of(context).backgroundColor),
                              ),
                      ),
                    ),
                  ),

                  //Forgot password---------------------------------------------
                  if (_isLogIn)
                    Container(
                      child: TextButton(
                        onPressed: () {
                          _passwordChange(context);
                        },
                        child: Text(
                          'I forgot my password',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ),

                  //Change Registering to Login-------------------------------
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_isLogIn ? "Don't have an account yet" : 'Already registered'} ?',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontSize: 12),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogIn = !_isLogIn;
                            });
                          },
                          child: Text(
                            _isLogIn ? 'Register' : 'Log in',
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
