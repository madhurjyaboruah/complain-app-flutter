import 'package:shared_preferences/shared_preferences.dart';
class LoginService{
  static const idKey='userID';
  static const dateKey='logindate';

  static String _userID='';
  static get userID=>_userID;

  static SharedPreferences? prefs;

   static Future<bool> loggedIn()async{
     prefs ??= await SharedPreferences.getInstance();
     bool retVal=false;
    if(prefs!.containsKey(dateKey) && prefs!.containsKey(idKey)){
      if(prefs!.getString(idKey)=="admin") return false;
        DateTime d=DateTime.parse(prefs!.getString(dateKey) as String);
        Duration du=DateTime.now().difference(d);
        _userID=prefs!.getString(idKey) as String;
        retVal= du.inDays<=5;
      }
      return Future.value(retVal);
    }

    static logout()async{
      prefs ??= await SharedPreferences.getInstance();
      if(prefs!.containsKey(dateKey)) prefs!.remove(dateKey);
      if(prefs!.containsKey(idKey)) prefs!.remove(idKey);
    }
}