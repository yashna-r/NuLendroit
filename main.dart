import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/Services/wrapper.dart';
import 'package:provider/provider.dart';
import 'Services/authService.dart';

void main() {

  runApp(NuLendroitApp());
}


// ignore: must_be_immutable
class NuLendroitApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(

        debugShowCheckedModeBanner: false,

          title: 'NuLendroit',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                  color: Colors.purple,
              ),
            ),
          ),

          home: Wrapper(),
        //MappingPage(auth: AuthService(),),

      ),
    );
  }

}



