import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ComplainDetails extends StatefulWidget {
  final DocumentSnapshot post;
  const ComplainDetails(this.post);

  @override
  State<ComplainDetails> createState() => _ComplainDetailsState();
}

class _ComplainDetailsState extends State<ComplainDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photos submitted by "+widget.post["name"]),
      ),
      body: Container(
        margin: const EdgeInsets.only(top:5,left: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:(widget.post["url"] as List<dynamic>).map((url) => 
            Container(
              margin: const EdgeInsets.only(top: 5,),
              child: Image.network(url as String,width: MediaQuery.of(context).size.width*0.8,
              loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },),
            )).toList() 
          ),
        ),
      )
    );
  }
}