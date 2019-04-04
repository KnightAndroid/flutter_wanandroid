import 'package:connectivity/connectivity.dart';

class CheckNetWorkUtils{


  factory CheckNetWorkUtils(){
    if(_singleton == null){
      _singleton = new CheckNetWorkUtils._();
    }
    return _singleton;
  }


  CheckNetWorkUtils._();

  static CheckNetWorkUtils _singleton;


 //检测是否联网 返回true或者false true就是有网
 Future<bool> checkNetWork() async {

   var isConnect = await (Connectivity().checkConnectivity());

   if(isConnect == ConnectivityResult.mobile){
     return true;
   }else if(isConnect == ConnectivityResult.wifi){
     return true;
   }

   return false;
 }


 dynamic checkInternet(Function func){
    checkNetWork().then((isConnect){
      if(isConnect != null && isConnect){
        func(true);
      }else{
        func(false);
      }

    });
 }




}




