import 'navbar.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:camera/camera.dart';
import '../services/image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MyCustomForm extends StatefulWidget {
  final String userID;
  const MyCustomForm(this.userID,{Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();  
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  var name="";
  var mobile= "";
  var address = "";
  var quarterno= "";
  var complainDetails= "";
  
  
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final quarternoController = TextEditingController();
  final complainDetailsController = TextEditingController();

   clearText() {
    nameController.clear();
    mobileController.clear();
    addressController.clear();
    quarternoController.clear();
    complainDetailsController.clear();
    _imagepaths=[];
    setState(() {
    });

  }
  CollectionReference complain = FirebaseFirestore.instance.collection('students');
  String? addressType = 'one';
  String quarterType= 'one';
  String? location = 'one';

  Future<List<String>> addImage() async{
    int i=1;
    List<String> url=[];
    for(var path in _imagepaths){
      File file=File(path);
      String imaId = DateTime.now().microsecondsSinceEpoch.toString()+i.toString();
      File? compressedFile;
      String outpath=file.absolute.path+imaId+'.jpeg';
      try{
        compressedFile = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path, 
            outpath,
            format: CompressFormat.jpeg,
            quality: 20);
      }catch(e){
        print(e.toString());
      }
      if(compressedFile==null) print("NULL COMPRESSED FILE");
      Reference reference = FirebaseStorage.instance.ref().child('Image$imaId');
      await reference.putFile(
        (compressedFile==null)?file:compressedFile,
      );
      url.add(await reference.getDownloadURL());
      i++; 
    }
    return url;
  }
  void showSnakeBar(BuildContext context){
     final snackBar = const SnackBar(content:const Text("Submitted"));
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> addUser() async {
    //DateTime.now()
    List<String> imgUrls =await addImage();
    //showAlertDialog(context);
    return complain
        .add({'name': name,'mobile': mobile, 'complainDetails': complainDetails, 'addressType':addressType,
            'quarterType':quarterType,'quarterNo':quarterno, 'location':location,'date':DateTime.now().toString(),
            'url':imgUrls,
          'cif':widget.userID})
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to Add user: $error'));
  }

  List<String> _imagepaths=[];

  final List<String> locationItems = [
    'Nazira',
    'Sivasagar',
  ];

  final List<String> addressItems = [
    'Office',
    'Residences',
  ];

  final List<String> quarterItems = [
    'A Type',
    'B Type',
    'C Type',
    'D Type',
  ];

  String? selectedValue;
  var uploadingForm=false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final double height = MediaQuery.of(context).size.height;
    
    //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("ONGC COMPLAINTS PORTAL"),
        actions: [
                    (uploadingForm)?
                    Center(
                      child: Container(
                        width: 17,
                        height: 17,
                        child: const CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white))),
                    )
                    :const SizedBox(),
        ],
      ),
      drawer: NavBar(widget.userID),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: IgnorePointer(
          ignoring: uploadingForm,
          child: Form(
            key: _formKey, //key for form
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.05),
                    Text(
                      "CPF number: "+(widget.userID),
                      style: const TextStyle(fontSize: 20, color: Color(0xFF363f93)),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                        }
                        return null;
                        },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          labelText: "Enter your Name"),
                          controller: nameController,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if(value.length<10)
                          return  "Phone number must be of length 10";
                        return null;
                      },
                      maxLength: 10,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          labelText: "Enter Mobile No."),
                          controller: mobileController,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Address Type"
                          //Add more decoration as you want here
                          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Address Type',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: addressItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value){
                        if (value == null) {
                          return 'Please select address type.';
                        }
                        return null;
                      },
                      onChanged: (String?  newValue) {
                        setState(() {
                          addressType= newValue.toString();
                        });
                     },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enters address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          labelText: "Enter Full Address"),
                          controller: addressController,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Quarter Type"
                          //Add more decoration as you want here
                          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Quarter Type',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: quarterItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select Quarter Type.';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          quarterType = newValue.toString();
                        });
            
                      },
                      onSaved: (value) {
                        quarterType = value.toString();
                      },
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFormField(
                      validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          labelText: "Enter Quarter Number"),
                          controller: quarternoController,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Location"
                          //Add more decoration as you want here
                          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Your Location',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: locationItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Location.';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          location = newValue.toString();
                        });
                        
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter complain description';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          labelText: "Enter Complaint Description"),
                          controller: complainDetailsController,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Center(
                      child: (_imagepaths.length<5)?Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionChip(
                            onPressed: () async{
                              String? tmp=await imageservice.getImage(true, context);
                              if(tmp!=null)
                                setState(() {
                                  _imagepaths.add(tmp);
                                });
                            },
                            avatar: new Icon(Icons.camera),
                              label: const Text('Take Photo'),
                              ),ActionChip(
                            onPressed: () async{
                              String? tmp=await imageservice.getImage(false, context);
                              if(tmp!=null)
                                setState(() {
                                  _imagepaths.add(tmp);
                                });
                            },
                            avatar: new Icon(Icons.photo),
                              label: const Text('Gallery'),
                              )
                        ],
                      ):const Text("Maximum 5 photos allowed"),
                    ),
                    Center(
                      child: (_imagepaths.isEmpty)?const Text('no photo selected'):
                      SizedBox(
                        height: ((_imagepaths.length/3).ceil()*80).toDouble(),
                        child: GridView( gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  children: _imagepaths.map((e) => Image.file(File(e),width: 80,height: 80,)).toList(),
                        ),
                      )
                    ),
            
                    Container(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              setState(()=>uploadingForm=true);
                              name = nameController.text;
                              mobile = mobileController.text;
                              address = addressController.text;
                              quarterno= quarternoController.text;
                              complainDetails = complainDetailsController.text;
                              //addImage(File(_imagepath as String));
                              await addUser();
                              showSnakeBar(context);
                              clearText();
                              await Future.delayed(const Duration(milliseconds: 100));
                              setState(() {
                                uploadingForm=false;
                              });
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        
                        ElevatedButton(
                          onPressed: () => {clearText()},
                          child: Text(
                            'Reset',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                        ),
                      ],
                    ),
                    )
                   
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
