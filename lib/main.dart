import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'widgets/provider_widget.dart';
import 'Pages/HomePage.dart';
import 'Pages/SignUpPage.dart';
import 'Pages/first_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      db: Firestore.instance,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SD',
          theme: ThemeData(
            primarySwatch: createMaterialColor(Color(0xFF1565C0)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'OpenSans'
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomeController(),
            '/signUp': (BuildContext context) => SignUpView(
                  authFormType: AuthFormType.signUp,
                ),
            '/signIn': (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.signIn),
          }),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn
              ? Home(
                  page_index: 0,
                )
              : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
