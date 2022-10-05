import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/pages/complainDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AdminPage extends StatefulWidget { 
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future getComplains() async{
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('students').get();
    return qn.docs;
    //lectionReference complain = FirebaseFirestore.instance.collection('complain');
  }

  var _deleting=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Admin'),
         actions:[
           IconButton(
               tooltip: "Close App",
               icon: Icon(Icons.exit_to_app),
               onPressed: () => SystemNavigator.pop(),
               
               ),
         ]
         
        
      ),
      body: FutureBuilder(
        
        future: getComplains(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError){
            print("something went wrong");
          }
          if(snapshot.connectionState== ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            //print(snapshot.data);
           // print(widget.userID);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                var info='Name: '+snapshot.data[index]['name']+'\n'+
                     'Mobile: '+snapshot.data[index]['mobile']+'\n'+
                      'CPF NO.: '+snapshot.data[index]['cif']+'\n'+
                      'Complaint Date: '+ snapshot.data[index]['date']+'\n'+
                      'Location: '+snapshot.data[index]['location']+'\n'+
                       'Quarter Type: '+snapshot.data[index]['quarterType']+'\n'+
                       'Quarter No: ' +snapshot.data[index]['quarterNo']+'\n';
                       
                return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(2, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text('Complain:'+snapshot.data[index]['complainDetails']),
                    subtitle:Text(info),

                    trailing:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                              Share.share(info);
                            }, icon: const Icon(Icons.share)),
                          // IconButton(onPressed: () {
                          //     showDialog(context: context, builder: (context){
                          //       return WillPopScope(
                          //         onWillPop: () {
                          //           return Future.value(!_deleting);
                          //         },
                          //         child: AlertDialog(
                          //           title: const Text('Delete complain?'),
                          //           actions: [
                          //             TextButton(                                        
                          //               onPressed: (){
                          //               (_deleting)?null:
                          //               Navigator.of(context).pop();
                          //             }, child: (_deleting)?const CircularProgressIndicator(): Text('Cancel')),
                          //             TextButton(onPressed: ()async{
                          //               setState(()=>_deleting=true);
                          //               await Future.delayed(Duration(seconds: 2));
                          //               setState(()=>_deleting=false);
                          //             }, child: const Text('Delete')),
                          //           ],
                          //         ),
                          //       );
                          //     });
                          //   }, icon: const Icon(Icons.delete_forever)),
                      ],
                    ),
                    onTap: (){
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder:(context) =>  ComplainDetails(snapshot.data[index])),
                          );
                    },
                  ),
                );
                
                
              });

          }
        
        }),
    );
  }
}
