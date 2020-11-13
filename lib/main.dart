import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:haider_app/screens/business_overview_screen.dart';
import 'package:haider_app/screens/splash_screen.dart';

import './screens/login_screen.dart';

import './providers/auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await Auth().deleteMessages('', '23');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => EmailAuth(),
          ),
        ],
        child: Consumer<EmailAuth>(builder: (ctx, auth, _) {
          // print(auth.isAuth);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '''Haider's App''',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Color.fromRGBO(124, 116, 146, 1),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  elevation: 0.0,
                  iconTheme:
                      IconThemeData(color: Color.fromRGBO(124, 116, 146, 1))),
            ),
            home: auth.isAuth
                ? BusinessOverViewScreen()
                : FutureBuilder(
                    builder: (context, authResultSnapshot) {
                      print(auth.isAuth);
                      return authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen();
                    },
                    future: auth.tryAutoLogin(),
                  ),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              BusinessOverViewScreen.routeName: (ctx) =>
                  BusinessOverViewScreen()
            },
          );
        }));
  }
}
