import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'encoding.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WebService{
  final _url="https://reports.ongc.co.in/wps/portal/reports/login";
  final _url1 ="https://reports.ongc.co.in/wps/portal/reports/login/!ut/p/z1/04_Sj9CPykssy0xPLMnMz0vMAfIjo8zizS0cnT28TYz8_E1CnQwCLQzCPAONXEz8HQ30wwkpiAJKG-AAYP1RYCW4TDAyhCrAY0ZBboRBpqOiIgCdFhRp/p0/IZ7_78ACHK42N0IF00Q8GV2SGP2003=CZ6_78ACHK42NO4UB0Q80VIQ2D4OA0=LA0=/";
  var loadingErr=false;
  var _loading=false;

  String? _uvalue='';
  String? _cookie='';//cookie type may be different present in http library

  final _headers={
     'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.60 Safari/537.36 Edg/100.0.1185.29",
      "Connection": "keep-alive",
      "Host": "reports.ongc.co.in"
  };

  getRequest()async{
    if(_loading) return;
    _loading=true;
    var response= await http.get(Uri.parse(_url),headers: _headers);
    if(response.statusCode==200){
      String htmlToParse = response.body;
      _cookie=response.headers['set-cookie'];
      var inputTags=parse(htmlToParse).getElementsByTagName("input");
      for (var tag in inputTags){
        if(tag.attributes.containsValue("uval")){
          _uvalue=tag.attributes['value'];
          break;
        }
      }
    }
    
    _loading=false;
  }

  String? getUvalue(){
    return _uvalue;
  }

  String? getCookie(){
    return _cookie;
  }
  //post request post url
  bool _loadingPost=false;
   final _postheaders={
     'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.60 Safari/537.36 Edg/100.0.1185.29",
      "Connection": "keep-alive",
      "Host": "reports.ongc.co.in",
      //"Content-Length": '512',
      "Cache-Control": 'max-age=0',
      "sec-ch-ua": '" Not A;Brand";v="99", "Chromium";v="100", "Google Chrome";v="100"',
      "sec-ch-ua-mobile": '?0',
      "sec-ch-ua-platform": '"Windows"',
      "Upgrade-Insecure-Requests": '1',
      "Origin": 'https://reports.ongc.co.in',
      "Content-Type": 'application/x-www-form-urlencoded',
      "Sec-Fetch-Site": 'same-origin',
      "Sec-Fetch-Mode": 'navigate',
      "Sec-Fetch-User": '?1',
      "Sec-Fetch-Dest": 'document',
      "Referer": 'https://reports.ongc.co.in/wps/portal/reports/login',
      "Accept-Encoding": 'gzip, deflate, br',
      "Accept-Language": 'en-US,en;q=0.9',
        };
    

    
Future<String> signIn(String uname,pass,bool admin) async{
  if(admin){
    return (await adminLogin(uname, pass));
  }else{
    return (await postRequest(uname, pass));
  }
}
  Future<String> postRequest(String uname,pass)async{
    if(_loadingPost) return "loading";
    var header=_postheaders;
    print('***');
    print(_uvalue);
    print('****');
    //var encoding=Encoding(uname,pass , int.parse(_uvalue as String));
    header['Cookie']=_cookie as String;
    header['SecurityProtocol']='SecurityProtocolType.Tls12';

    var body={
    "uval": _uvalue,
    "userId": "",
    "pass": "",
    "USER_ID": uname,//encoding.encodeUserId(),
    "PASSWORD": pass,
    "Submit": "Login"
  };
 

    var response = await http.post(Uri.parse(_url1),headers: header,body: body);

    _loadingPost=false;
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==302){
    
      //return await (response.stream).bytesToString();

      return 'success';
    }else if(response.statusCode==200){
      return "User id/password incorrect";
    }

      return "Error trying to login"; 
  }

  Future<String> adminLogin(String uname,pass) async{
    var auth=FirebaseAuth.instance;
    try{
        UserCredential user = await auth.signInWithEmailAndPassword(email: uname+"@gmail.com", password: pass);        
        return "success";
    } catch (e) {
      String msg=e.toString();
      msg=msg.split(']')[1];
      return msg;   
    }
  }
}