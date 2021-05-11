import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nulendroit/MainPages/mainPage.dart';
import 'package:nulendroit/MainPages/userInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nulendroit/Services/authService.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:nulendroit/Shared/dialogBox.dart';


class LoginRegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _LoginRegisterPageState();
  }
}

enum FormType{
  login,
  register
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {

  DialogBox dialogBox = new DialogBox();

  final GlobalKey<FormState> _authFormKey = new GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  FormType _formType = FormType.register;
  String error = '';
  bool loading = false;
  String _email, _password;


  @override
  Widget build(BuildContext context) {

    //Login form
    if(_formType == FormType.login){
      return loading ? Loading() : Scaffold(
          backgroundColor: Colors.teal[200],

          body: Container(
            child: loginForm(),
          )
      );
    }
    else {

      //Register form
      return loading ? Loading() : Scaffold(
          backgroundColor: Colors.teal[200],

          body: Container(
            child: registerForm(),
          )
      );
    }
  }
/*--------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------DESIGN----------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/

  /*-----------Login form-----------*/
  Widget loginForm() {

    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
      child: Form(

          key: _authFormKey,
          child: Center(

              child: Column(

                children: <Widget>[

                  Image(
                    image: AssetImage('assets/images/logo1.png'),
                    height: 250.0,
                  ),

                  SizedBox(
                    height: 40.0,
                  ),

                  //Email field
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        )
                    ),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please provide an email';

                      } else if (!(input.contains('@'))){
                        return 'Please provide a valid email';

                      }else {
                        return null;
                      }
                    },
                    onSaved: (input) => _email = input.trim(),
                  ),

                  SizedBox(
                    height: 15.0,
                  ),

                  //Password field
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        )
                    ),

                    onSaved: (input) => _password = input,
                    obscureText: true,
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  SizedBox(
                    height: 50.0,
                    width: 200.0,
                    child: RaisedButton(
                      onPressed: validateAndSubmit,
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(27.5)
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 100.0,
                    width: 300.0,
                    child: FlatButton(
                      onPressed: moveToRegister,
                      child: Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              )
          )
      ),
    );
  }

  /*-----------Register form-----------*/
  Widget registerForm() {
    final TextStyle display1 = Theme
        .of(context)
        .textTheme
        .display1;

    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
      child: Form(
          key: _authFormKey,
          child: Column(
            children: <Widget>[

              Image(
                image: AssetImage('assets/images/logo1.png'),
                height: 250.0,
              ),

              SizedBox(
                height: 20.0,
              ),

              Text(
                  "Join us!",
                  style: GoogleFonts.bahianita(
                    textStyle: display1,
                    fontWeight: FontWeight.bold,
                    fontSize: 44.0,
                    color: Colors.white,
                  )
              ),

              SizedBox(
                height: 30.0,
              ),

              //Email field
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.purple,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    )
                ),
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please provide an email';
                  } else if (!(input.contains('@'))){
                    return 'Please provide a valid email';
                  }else
                  {
                    return null;
                  }
                },
                onSaved: (input) => _email = input.trim(),
              ),

              SizedBox(
                height: 15,
              ),

              //Password field
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.purple,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    )
                ),
                validator: (input) {
                  if (input.length < 6) {
                    return "Password should have a minimum of 6 characters";
                  } else {
                    return null;
                  }
                },
                onSaved: (input) => _password = input,
                obscureText: true,
              ),

              SizedBox(
                height: 15,
              ),

              //'Create account' button
              SizedBox(
                  height: 50.0,
                  width: 200.0,
                  child: RaisedButton(
                    onPressed: validateAndSubmit,
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(27.5)
                    ),
                    child: Text(
                      'Create account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white
                      ),
                    ),
                  )
              ),

              //Button to move to log in form
              SizedBox(
                height: 100.0,
                width: 300.0,
                child: FlatButton(
                  onPressed: moveToLogin,
                  child: Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          )
      ),
    );
  }


/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------METHODS----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/

  /*-----------Move to register form-----------*/
  void moveToRegister(){
    setState(() {
      _formType = FormType.register;
    });
  }

  /*-----------Move to login form-----------*/
  void moveToLogin(){
    setState(() {
      _formType = FormType.login;
    });
  }

  /*-----------Method for sign in and sign up button-----------*/
  bool _validateAndSave(){

    final form = _authFormKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async{

    if (_validateAndSave()){

      dynamic userId;

      try{
        if (_formType == FormType.login){
          /*---------------Login---------------*/
          userId = await _auth.signIn(_email, _password);

          if(userId == null) {
            setState(() {
              loading = false;
              error = 'Invalid credentials';
              dialogBox.information(context, "Error", error);
            });
          }
          print("Login userID: " + userId);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
        }
        else{

          /*---------------Register---------------*/
          userId = await _auth.signUp(_email, _password);

          if(userId == null) {
            setState(() {
              loading = false;
              error = 'Account already exists. Please provide a new email or proceed to sign in.';
              dialogBox.information(context, "Error", error);
            });
          }
          print("Register userID: " + userId);
          moveToUserInfoPage();
          dialogBox.information(context, 'Welcome to NuLendroit', 'You have been successfully registered.');
        }


      }catch(e){
        dialogBox.information(context, "Error", e.toString());
        print("Error: " + e.toString());
      }
    }
  }

  void moveToUserInfoPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfo(), fullscreenDialog: true));
  }

}
