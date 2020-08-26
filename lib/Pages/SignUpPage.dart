import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:SD/services/auth_service.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/models/user_info.dart';

final primaryColor = const Color(0xFF75A2EA);
enum AuthFormType { signIn, signUp, reset }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;
  SignUpView({Key, key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;
  void switchFormState(String state) {
    _formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              color: primaryColor,
              width: _width,
              height: _height,
              child: SafeArea(
                  child: Column(
                children: <Widget>[
                  showAlert(),
                  SizedBox(height: _height * 0.025),
                  buildHeaderText(),
                  SizedBox(height: _height * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                ],
              )),
            ),
          ]),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error_outline)),
            Expanded(child: AutoSizeText(_warning, maxLines: 3)),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Create New Account";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    if (authFormType == AuthFormType.reset) {
      textFields.add(
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            validator: EmailValidator.validate,
            style: TextStyle(fontSize: 22.0),
            decoration: buildSignUpInputDecoration("Email"),
            onSaved: (value) => _email = value,
          ),
        ),
      );
      textFields.add(SizedBox(height: 20));
      return textFields;
    }
    // if were in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            validator: NameValidator.validate,
            style: TextStyle(fontSize: 22.0),
            decoration: buildSignUpInputDecoration("Name"),
            onSaved: (value) => _name = value,
          ),
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value,
        ),
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          validator: PasswordValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Password"),
          obscureText: true,
          onSaved: (value) => _password = value,
        ),
      ),
    );
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;
    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          _warning = "A password reset link has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
              _email, _password, _name);
          final snapShot = await Firestore.instance
              .collection('userData')
              .document(uid)
              .get();
          UserInfo _userInfo = UserInfo(
              "https://firebasestorage.googleapis.com/v0/b/seekdis-6115e.appspot.com/o/image_picker395842049722564467.jpg?alt=media&token=2caf99fa-1d76-47ae-b012-5f0abaaa021b",
              _name,
              "",
              0,
              0,
              uid.toString());
          if (snapShot == null || !snapShot.exists) {
            await Provider.of(context)
                .db
                .collection('userData')
                .document(uid)
                .setData(_userInfo.toJson());
          }
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 10),
          GoogleSignInButton(
            onPressed: () async {
              try {
                final _listvals = await _auth.signInWithGoogle();
                final _uid = _listvals[0];
                final _name = _listvals[1];
                final snapShot = await Firestore.instance
                    .collection('userData')
                    .document(_uid)
                    .get();
                UserInfo _userInfo = UserInfo(
                    "https://firebasestorage.googleapis.com/v0/b/seekdis-6115e.appspot.com/o/image_picker395842049722564467.jpg?alt=media&token=2caf99fa-1d76-47ae-b012-5f0abaaa021b",
                    _name,
                    "",
                    0,
                    0,
                    _uid);
                if (snapShot == null || !snapShot.exists) {
                  await Provider.of(context)
                      .db
                      .collection('userData')
                      .document(_uid)
                      .setData(_userInfo.toJson());
                }
                Navigator.of(context).pushReplacementNamed('/home');
              } catch (e) {
                setState(() {
                  print(e);
                  _warning = e.message;
                });
              }
            },
          )
        ],
      ),
      visible: visible,
    );
  }
}
