import 'package:first_app/pages/form-page.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
//import '../services/encoding.dart';
import '../services/WebService.dart';
import 'admin_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var onPressed;

  final _webservice = WebService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color.fromARGB(96, 245, 240, 240),
              child: FutureBuilder(
                future: _webservice.getRequest(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return _buildLogin(_webservice.getUvalue());
                }),
              ),
            ),
          ],
        ),
      ),
      //),
      //),
    );
    //);
  }

  var _loging = false;
  var passController = TextEditingController();
  var unameController = TextEditingController();
  String? error;
  Widget _buildLogin(String? uvalue) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: IgnorePointer(
        ignoring: _loging,
        child: Column(children: <Widget>[
          Form(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/ongc-logo1.jpg',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "ONGC COMPLAINTS",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 253, 253, 253),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: unameController,
                  decoration: const InputDecoration(
                      hintText: "Enter CPF Number", labelText: "CPF Number"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Enter Password of ONGCReoprts",
                      labelText: "Password"),
                )
              ],
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _loging = true;
              });
              var admin = unameController.text == "admin";
              var status = await _webservice.signIn(
                  unameController.text, passController.text, admin);

              if (status == 'success') {
                var pref = await SharedPreferences.getInstance();
                pref.setString("logindate", DateTime.now().toString());
                pref.setString('userID', unameController.text);

                if (admin) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminPage()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyCustomForm(unameController.text)));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(status,
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
                //error=status;
                setState(() {
                  _loging = false;
                });
              }
            },
            child: const Text("Sign In"),
            style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
          ),

          //(_loging)?const LinearProgressIndicator():const SizedBox(),
          (error != null) ? Text(error as String) : const SizedBox()
        ]),
      ),
    );
  }

  @override
  void dispose() {
    unameController.dispose();
    passController.dispose();
    super.dispose();
  }
}

//on press make post request
//disable sign in button
//show loading icon below
//on error show error message below and enable sign in button
//on success navigate to home
//on press make post request
//disable sign in button
//show loading icon below
//on error show error message below and enable sign in button
//on success navigate to home