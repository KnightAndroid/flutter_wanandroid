class UserInfo{
    //先不管
    List chapterTops;
    //先不管
    List collectIds;
    //邮箱
    String icon;
    //id
    int id;
    //token
    String token;
    //type
    int type;
    //userName
    int userName;

    UserInfo(joinData){
      icon = joinData['icon'];
      id = joinData['id'];
      token = joinData['token'];
      type = joinData['type'];
      userName = joinData['userName'];
    }


}