class Encoding{
  final _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  
  String _password;
  String _userID;
  int _uvalue;
  Encoding(this._userID,this._password,this._uvalue);

  String _tripleEncoding(String orgValue){
      var fstEncVal=_encode(orgValue);
			var secEncVal=_finalManEncodeValue(fstEncVal);
			var fnlEncVal=_encode(secEncVal);
			return fnlEncVal;

  }

  String _charAt(String str,int index){
    if(index<str.length) return str[index];
    return "";
  }

 
  int _getCharCode(String str,int i){
    if(i<str.length) return str.codeUnitAt(i);
    return -1;
  }

String _encode(String input){
  var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      //var isNaN;
      var output = "";
			int chr1, chr2, chr3, enc1, enc2, enc3, enc4;
			var i = 0;
	 
			input = _utf8_encode(input);
	 
			while (i < input.length) 
			{
				chr1 = _getCharCode(input,i++);
				chr2 = _getCharCode(input,i++);
				chr3 = _getCharCode(input,i++);

        bool invalidChr2=chr2==-1;
        bool invalidChr3=chr3==-1;

        if(invalidChr2) chr2=0;
        if (invalidChr3) chr3=0;

				enc1 = chr1 >> 2;
				enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
				enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
				enc4 = chr3 & 63;

	 
				if (invalidChr2) {
					enc3 = enc4 = 64;
				} else if (invalidChr3) {
					enc4 = 64;
				}
				output = output +
				_charAt(_keyStr,enc1) + _charAt(_keyStr,enc2) +
				_charAt(_keyStr,enc3) + _charAt(_keyStr,enc4);
			}
			return output;
  }

   String _utf8_encode(String string){
    //string = string.replace(/\r\n/g,"\n");
			var utftext = "";
	 
			for (var n = 0; n < string.length; n++) {
	 
				var c = string.codeUnitAt(n);
	 
				if (c < 128) {
					utftext += String.fromCharCode(c);
				}
				else if((c > 127) && (c < 2048)) {
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				}
				else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}
			}
			return utftext;

  }
  String _reverseString(String theString)
		{
			 var newString = ""; 
			 var counter = theString.length; 

			 for (counter  ;counter > 0 ;counter--) 
			 { 
				 newString += theString.substring(counter-1, counter); 
			 }
			 return newString;
		} 

  String _finalManEncodeValue(String strEncodeVal){
      var x=strEncodeVal.length;
			var z=x%2;
			var s=(x-z)~/2;
			var strPartOneVal=strEncodeVal.substring(0, s);
			var strPartTwoVal=strEncodeVal.substring(s, x);

			var revEncValOne=_reverseString(strPartOneVal);	
			var revEncValTwo=_reverseString(strPartTwoVal);

			var encOne=_stringManpEncode(revEncValOne);
			var encTwo=_stringManpEncode(revEncValTwo);
			return 	encOne+encTwo;
  }

 
   String _stringManpEncode(String strValue){
    var strRepVal="";
			var capsAlpha="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			var repCapsAlpha="ZYXWVUTSRQPONMLKJIHGFEDCBA";
			var smalAlpha="abcdefghijklmnopqrstuvwxyz";	
			var repSmalAlpha="zyxwvutsrqponmlkjihgfedcba";
			var digVal="0123456789=";
			var repDigVal="0@87\$!*3^1#";
      int i ;
			for(i=0; i<strValue.length; i++)
			{
				var chVal=_charAt(strValue,i);
				
				if(capsAlpha.indexOf(chVal)!=-1)
				{
					var iPos=capsAlpha.indexOf(chVal);
					strRepVal=strRepVal+_charAt(repSmalAlpha,iPos);
				}
				else if(smalAlpha.indexOf(chVal)!=-1)
				{
					var iPos=smalAlpha.indexOf(chVal);
					strRepVal=strRepVal+_charAt(repCapsAlpha,iPos);
				}
				else if(digVal.indexOf(chVal)!=-1)
				{  
          
					var iPos=digVal.indexOf(chVal);
					strRepVal=strRepVal+_charAt(repDigVal,iPos);
				}
				else
				{
					strRepVal=strRepVal+chVal;
				}
			}
			return strRepVal;
  }



   var passesckey="opBcdefgh1iwxy0UV2E67MNOPqQR3STAXHI5JbY4ZaKjklmWzr8stCD9nFGuvL";
   var passesckey2="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
   String _flayer(String str,int num){
    var nval='';
    var x=0;
    num=num%40;
    while(num>x){
    for(var i=0;i<str.length;i++){

      var ch=_charAt(str,i);
      if(ch!="="){
        ch=_charAt(passesckey2,passesckey.indexOf(ch));
      }
      nval=nval+ch;
    }
    x++;
    str=nval; nval='';
    }
    return str;
    }

    String encodeUserId(){
      return _tripleEncoding(_userID);
    }
    String encodePassword(){
      return _flayer(_tripleEncoding(_password), _uvalue);
    }
}