import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';
import '../Providers/JobProvider.dart';
import './Screens/launch.dart';
import './Screens/singin.dart';
import './Screens/singup.dart';
import './Screens/forgotpassword.dart';
import './Screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(
        value: AuthProvider(),
      ),
      ChangeNotifierProvider.value(
        value: JobProvider(),
      ),
    ], child: MaterialWidget());
  }
}

class MaterialWidget extends StatefulWidget {
  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends State<MaterialWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        fontFamily: 'Quicksand',
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (ctx) => Launch(),
        '/SignIn': (ctx) => SignIn(),
        '/SignUp': (ctx) => SignUp(),
        '/ForgotPassword': (ctx) => ForgotPassWord(),
        '/DashBoard': (ctx) => DashBoard(),
      },
    );
  }
}
