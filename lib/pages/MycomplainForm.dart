import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/pages/complainDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MycomplainForm extends StatefulWidget { 
  final String userID;
  const MycomplainForm(this.userID,{Key? key}) : super(key: key);


  @override
  State<MycomplainForm> createState() => _MycomplainFormState();
}

class _MycomplainFormState extends State<MycomplainForm> {
  Future getComplains() async{
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('students').where('cif',isEqualTo: widget.userID).get();
    return qn.docs;
    //lectionReference complain = FirebaseFirestore.instance.collection('complain');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complain Details'),
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
                    title: Text(snapshot.data[index]['complainDetails']),
                    trailing: const Icon(Icons.arrow_right_alt_rounded),
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



// class MycomplainForm extends StatefulWidget {
//   MycomplainForm({Key? key}) : super(key: key);

//   @override
//   State<MycomplainForm> createState() => _MycomplainFormState();
// }

// class _MycomplainFormState extends State<MycomplainForm> {
//    CollectionReference complain = FirebaseFirestore.instance.collection('complain');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: StreamBuilder(
//           stream: complain.snapshots(),
//           builder: (context,snapshot){
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text("Loading");
//             }
//             // if(snapshot.data==null){
//             //   return Text("Something Else"); 
//             //   }

//             return ListView.builder(
              
//               itemCount:snapshot.data!.documents.length,
//               itemBuilder: (context,index){
//                 return ListTile(
//                   title: Text(snapshot.data.documents[index]['title']),
//                   //subtitle: Text(snapshot.data!.documents[index]['desc']),
//                 );
//               },
//             );
//           }),
//     );
//   }
// }