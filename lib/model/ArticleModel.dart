
class ArticleModel{

  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;


  ArticleModel(jsonData){
    courseId = jsonData['courseId'];
    id = jsonData['id'];
    name = jsonData['name'];
    order = jsonData['order'];
    parentChapterId = jsonData['parentChapterId'];
    userControlSetTop = jsonData['userControlSetTop'];
    visible = jsonData['visible'];
  }

}


