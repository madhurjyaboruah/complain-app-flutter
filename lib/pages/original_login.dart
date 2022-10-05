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

  final _webservice=WebService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login  Page"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            child: FutureBuilder(
              future: _webservice.getRequest(),
              builder: ((context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting)
                  return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: Center(
                              child: CircularProgressIndicator(),
                                ),
                            );
                return _buildLogin(_webservice.getUvalue());
              }),
              
            ),
          ),
        ),
      ),
    );
  }
  
  var _loging=false;
  var passController=TextEditingController();
  var unameController=TextEditingController();
  String? error;
  Widget _buildLogin(String? uvalue){
    return  WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: IgnorePointer(
        ignoring: _loging,
        child: Column(
                    children:<Widget>[
                       Form(child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                           children:<Widget>[
                             TextFormField(
                               controller: unameController,
                               decoration:InputDecoration(hintText: "Enter UserName", labelText: "Username"),
                             ),
                             SizedBox(
                               height: 20,
                             ),
                             TextFormField(
                               controller: passController,
                               obscureText: true,
                               decoration:InputDecoration(hintText:"enter Password", labelText: "Password"),
                             )
                           ],
                         ),
                       )),
                       const SizedBox(
                         height: 20,
                       ),
                       ElevatedButton(
                         onPressed: ()async{
                           setState(() {
                             _loging =true;
                           });
                           var admin=unameController.text=="admin";
                           var status=await _webservice.signIn(unameController.text, passController.text,admin);
                          
                          if(status=='success'){
                            var pref=await SharedPreferences.getInstance();
                            pref.setString("logindate", DateTime.now().toString());
                            pref.setString('userID', unameController.text);
                            
                            if(admin){
                              Navigator.push
                           (context, MaterialPageRoute(builder: (context)=>AdminPage()));
                            }
                            else{
                              Navigator.push
                           (context, MaterialPageRoute(builder: (context)=>MyCustomForm(unameController.text)));
                            }
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(status,style: const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                               ),
                            );
                            //error=status;
                             setState(() {
                            _loging =false;
                          });
                          }
                        },
                         child: const Text("Sign In"),
                         style: ElevatedButton.styleFrom(
                           primary: Colors.deepOrange
                         ),
                       ),
      
                       //(_loging)?const LinearProgressIndicator():const SizedBox(),
                       (error!=null)?Text(error as String):const SizedBox()            
                    ]   
                    
                  ),
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