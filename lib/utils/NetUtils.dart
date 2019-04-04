import 'dart:convert';
import 'package:wanandroid/api/Api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/utils/ToastUtils.dart';
import 'package:wanandroid/utils/CheckNetWorkUtils.dart';



/*
 * desc: 请求网络工具
 *
 *
 */

class NetUtils{
   //get请求
   static const String GET = "get";
   //post请求
   static const String POST = "post";

   factory NetUtils(){
     if(_singleton == null){
       _singleton = new NetUtils._();
     }
     return _singleton;
   }


   NetUtils._();

   static NetUtils _singleton;


   //get请求
   void get(String url,Function callBack,{Map<String,String> params,
       Map<String,String> headers,Function errorCallBack})  {

     //判断请求链接开头是否等于http，不是的话替换，后面再扩展
//     if(!url.startsWith("http")){
//       url = Api.baseUrl + url;
//     }
     url = Api.baseUrl + url;

     //做非空判断
     if(params != null && params.isNotEmpty){
       // 如果参数不为空，则将参数拼接到URL后面
       StringBuffer sb = new StringBuffer("?");
       params.forEach((key,value){
         sb.write("$key" + "=" + "$value" + "&");
       });

       String paramStr = sb.toString();
       paramStr = paramStr.substring(0,paramStr.length - 1);
       url += paramStr;
     }
     //发起get请求
      http_requset(url, callBack, GET,headers: headers,errorCallBack: errorCallBack);


   }

   //post请求
    void post(String url,Function callBack,{Map<String,String> params,
      Map<String,String> headers,Function errorCallBack}) {
      //做判断
//     if(!url.startsWith("http")){
//        url = Api.baseUrl + url;
//     }
     url = Api.baseUrl + url;
     http_requset(url, callBack, POST,headers: headers,params: params,errorCallBack: errorCallBack);

   }





   //发起网络请求
    Future http_requset(String url,Function callBack,String method,
     {Map<String,String> headers,Map<String,String> params,Function errorCallBack}) {

       CheckNetWorkUtils().checkInternet((data) async{
         if(data == true){
           String errorMsg;
           int errorCode;
           var data;
           //头部参数
           Map <String,String> headerMap;
           //普通参数
           Map <String,String> paramMap;
           try{
             //添加头部
             if(headers == null){
               headerMap = new Map();
             }else{
               headerMap = headers;
             }
             //添加参数
             if(params == null){
               paramMap = new Map();
             }else{
               paramMap = params;
             }

             //添加Cookie
             SharedPreferences pres = await SharedPreferences.getInstance();
             String cookie = pres.get("Cookie");
             if(cookie != null && cookie.length > 0){
               headerMap['Cookie'] = cookie;
             }
             //下面发起请求
             http.Response res;
             //如果是GET请求
             if(method == GET){
               res = await http.get(url,headers: headerMap);
             }
             //如果是POST请求
             if(method == POST){
               res = await http.post(url,headers: headerMap,body:paramMap);
             }
             if(res.statusCode != 200){
               errorMsg = "请求失败，状态码:"+ res.statusCode.toString();
               handError(errorCallBack, errorMsg);
               return;
             }

             //下面处理数据
             Map<String,dynamic> map = json.decode(res.body);
             errorCode = map["errorCode"];
             errorMsg = map["errorMsg"];
             data = map["data"];
             //这里要判断如果是登录就要存储cookie
             if(url.contains(Api.userLogin)){
               SharedPreferences pres = await SharedPreferences.getInstance();
               pres.setString("Cookie", res.headers['set-cookie']);
             }

             //把具体数据data带出去
             if(callBack != null){
               if(errorCode == 0){
                 callBack(data);
               } else {
                 handError(errorCallBack, errorMsg);
               }
             }

           }catch(ex){
             handError(errorCallBack, ex.toString());
           }
         }else{
           handError(errorCallBack, "没有网络，请检测网络是否可用~");
         }
       });




   }


   //错误提示
    void handError(Function errorCallBack,String errorMsg){
     //回调出去
     if(errorCallBack != null){
       errorCallBack(errorMsg);
     }
     print("error $errorMsg");

   }

//   //返回true获取false
//   isNetAliable(bool isNetworkPresent){
//     if(isNetworkPresent){
//
//     }else{
//
//     }
//
//   }

}
