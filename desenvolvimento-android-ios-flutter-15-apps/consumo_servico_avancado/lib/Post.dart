class Post {

  int userId;
  int id;
  String title;
  String body;

  Post(this.userId, this.id, this.title, this.body);

  Map toJson() {
    return {
      "userId": this.userId,
      "id": this.id,
      "title": this.title,
      "body": this.body,
    };
  }
}