/**
 * Describe :
 * Created by Knight on 2019/3/17
 * @Version :
 * 点滴之行,看世界
 */
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHandle{

  //数据库路径
  static String historyDataBasePath = "";
  //数据库名称
  static String historyDataBase = "message.db";
  //创建表语句 这里主要存放搜索历史记录
  static String sql_createTable = "CREATE TABLE historymessage("
      "id INTEGER PRIMARY KEY,"
      "name TEXT)";

  static Database myDb;



  static Future<Database> get db async{
    myDb = await openDatabase(historyDataBasePath);
    return myDb;
  }

  //创建数据库
  static Future<String> createDataBase(String db_name) async {
    //在文档目录建立
    var document = await getApplicationDocumentsDirectory();
    //获取路径 join是path包下的方法，就是将两者路径连接起来
    String path = join(document.path, db_name);
    //逻辑是如果数据库存在就把它删除然后创建
    var _directory = new Directory(dirname(path));
    bool exists = await _directory.exists();
    if (exists) {
      //必存在 这里是为了每次创建数据库表先表删除则删除数据库表
      await deleteDatabase(path);
    } else {
      try {
        //不存在则创建目录  如果[recursive]为false，则只有路径中的最后一个目录是
        //创建。如果[recursive]为真，则所有不存在的路径
        //被创建。如果目录已经存在，则不执行任何操作。
        await new Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }

  //创建数据库表方法
  static cratedb_table(Function callBack,Function errorBack) async {
    try{
      //得到数据库的路径
      historyDataBasePath = await createDataBase(historyDataBase);
      //打开数据库
     // Database my_db = await openDatabase(historyDataBasePath);
      await db;
      //创建数据库表
      await myDb.execute(sql_createTable);
      //关闭数据库
      await myDb.close();
      callBack("创建数据库成功");
    }catch(ex){
      errorBack();
    }

  }


  //增加数据(搜索历史)
  static addHistoryData(String historyData,Function callBack,Function errorBack) async {
    try{
      //首先打开数据库
   //   Database my_db = await openDatabase(historyDataBasePath);
      //插入数据
      String addDataSql = "INSERT INTO historymessage(name) VALUES('$historyData')";
      await db;
      await myDb.transaction((tran) async{
        await tran.rawInsert(addDataSql);
      });

      //关闭数据库
      await myDb.close();
      callBack();
    }catch(ex){
      errorBack();
    }

  }


  //查询数据
  static queryDetail(Function callBack,Function errorBack) async{
    //查询数据库的所有信息
    String sql_queryMessage = 'SELECT * FROM historymessage';
    //Database myDb;
    try{
      //打开数据库
     // myDb = await openDatabase(historyDataBasePath);
      await db;
      //将数据放到集合里面显示
      List<Map> dataList = await myDb.rawQuery(sql_queryMessage);
      print('集合数据'+dataList.toString());

      callBack(dataList);

    }catch(ex){
      print(ex.toString());
      errorBack();
    }finally{
      //最终关闭数据库
      await myDb.close();
    }


  }

  //清空数据
  static clearData(Function callBack,Function errorBack) async{
   // Database my_db = await openDatabase(historyDataBasePath);
    try{
      await db;
      await myDb.delete("historymessage");
      callBack();
    }catch(ex){
      errorBack();
    }finally{
      await myDb.close();
    }

  }



}
