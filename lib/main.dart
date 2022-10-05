//import 'package:first_app/pages/home_page.dart';
import 'package:first_app/pages/LoginPage.dart';
import 'package:first_app/pages/form-page.dart';
import 'services/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(MyApp());
// }
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: LoginService.loggedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting) return const LinearProgressIndicator();
          if(snapshot.hasData){
            bool? login=(snapshot.data==null)?false:snapshot.data;
            if(login==null || !login){
              return LoginPage();
            }
            else{
              return MyCustomForm(LoginService.userID);
            }
          }
          return const LinearProgressIndicator();
      },),
      // routes: {
      //   "/login":(context) => LoginPage(),
      //   //"/form": (context) =>MyCustomForm()
      // },
    );
  }

}
