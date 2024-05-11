import 'package:flutter/material.dart';


import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:go_router/go_router.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);


  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QuickTask Application',
          style: TextStyle(
                          color: Color.fromARGB(255, 1, 3, 135),
                          fontWeight: FontWeight.w500,
                          fontSize: 50),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Login to QuickTask',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Specify your credentials to login',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text(
                    ' ',
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        print("Controller name = ${nameController.text}");
                        print(
                            "Controller password = ${passwordController.text}");
                        processLogin(context, nameController.text,
                            passwordController.text);
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('To Signup,'),
                    TextButton(
                      child: const Text(
                        'click here',
                        //style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        print("SIGNUP PRESSED");
                        GoRouter.of(context).go('/signup');
                      },
                    )
                  ],
                ),
              ],
            )));
  }


  processLogin(context, username, password) async {
    print("processLogin name = $username");
    print("processLogin password = $password");
    var user = ParseUser(username, password, "");
    var response = await user.login();
    if (response.success) {
      user = response.result;
      GoRouter.of(context).go('/todo');
    } else {
      // set up the button
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () => Navigator.pop(context),
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Error Dialog"),
        content: Text('${response.error?.message}'),
        actions: [
          okButton,
        ],
      );


      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}