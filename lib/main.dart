import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:go_router/go_router.dart';
import 'login.dart';
import 'signup.dart';
import 'todo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'ha9uAMeggq4q4vUaKByoe2aG4V99U5dwDkfKz27Y';
  final keyClientKey = 'eGwmw31G7fZRcovj3c4GRgN28U13rfS4iTz30otE';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  //await Parse().initialize(keyApplicationId, keyParseServerUrl, clientKey: keyClientKey, autoSendSessionId: true);

  await Parse().initialize(keyApplicationId, keyParseServerUrl,clientKey: keyClientKey, debug: true);
  //runApp(MaterialApp(home: Home(),));
  
  // Create an Object to verify connected
  var firstObject = ParseObject('FirstClass')
    ..set('message', 'Parse Login Demo is Connected');
  await firstObject.save();

  print('done');
  // Parse code done
  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/todo',
      builder: (context, state) => const Todo(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUp(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}