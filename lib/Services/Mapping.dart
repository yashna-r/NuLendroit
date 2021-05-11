/*
import 'package:flutter/material.dart';
import 'package:nulendroit/Pages/login_register.dart';
import 'package:nulendroit/Services/authService.dart';
import 'package:nulendroit/Pages/mainPage.dart';


class MappingPage extends StatefulWidget{

  MappingPage({
    this.auth,
  });

  final AuthImplementation auth;

  @override
  State<StatefulWidget> createState() {
    return _MappingPageState();
  }

}

enum AuthStatus{
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;
  String _userId = "";

  @override
  void initState(){

    super.initState();
    widget.auth.getCurrentUser().then((user){

      setState(() {

        if (user != null) {
          _userId = user?.uid;
        }

        authStatus = user?.uid == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });

  }

  void _signedIn() {


    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();

      });
    });
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }


  void _signedOut() {

    setState(() {
      authStatus = AuthStatus.notSignedIn;
      _userId = "";
    });
  }

  Widget progressScreenWidget() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    switch(authStatus){

      case AuthStatus.notSignedIn:
        return new LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
        break;

      case AuthStatus.signedIn:
        if (_userId.length > 0 && _userId != null) {
          return new MainPage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _signedOut,
          );
        } else
          return progressScreenWidget();
        break;

      default:
        return progressScreenWidget();

    }
  }
}*/
