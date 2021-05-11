import 'package:flutter/material.dart';
import 'package:nulendroit/MainPages/login_register.dart';

class WelcomePage extends StatefulWidget{

  @override
  _WelcomePageState createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage>{

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
      return new Future(() => false);
    },
      child: Scaffold(
          backgroundColor: Colors.purple,
          body: Container(
//          margin: EdgeInsets.symmetric(horizontal: 50.0),
            child:Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.stretch,

              children: <Widget>[

                Center(
                  child: Image(
                    image: AssetImage('assets/images/logo1.png'),
                    height: 250.0,
                  ),
                ),

                Center(
                  child: Text(
                    'Welcome to NuLendroit',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.0,
                        color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50.0,
                  width: 200.0,
                  child: RaisedButton(
                    color: Colors.teal[600],
                    onPressed: navigateToLoginRegister,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),

          )
      ),
    );
  }

  void navigateToLoginRegister(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRegisterPage(), fullscreenDialog: true));

  }
}
