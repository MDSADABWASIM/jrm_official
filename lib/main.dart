import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jrm/pages/home.dart';
import 'package:jrm/util/connectivity.dart';
import 'package:jrm/widgets/splashScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BottomNavigationBarProvider()),
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<ConnectivityStatus>(
    builder: (context) => ConnectivityService().connectionStatusController.stream
    )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jrm',
        theme: ThemeData(
          fontFamily: "SF-Pro-Text-Regular",
          primarySwatch: Colors.blue,
          buttonColor: Color(0xFFE9A663),
          primaryColor: Color(0xFF1b1e44),
        ),
        home: SplashScreen(),
      ),
    );
  }

  
}
