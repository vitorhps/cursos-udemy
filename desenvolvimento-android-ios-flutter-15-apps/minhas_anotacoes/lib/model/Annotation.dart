class Annotation {
  int id;
  String title;
  String description;
  String date;

  Annotation(this.title, this.description, this.date);

  Annotation.fromMap(Map map) {
    this.id = map["id"];
    this.title= map["title"];
    this.description = map["description"];
    this.date = map["date"];
  }

  Map toMap() {
    Map<String, dynamic> annotationMap = {
      "title": this.title,
      "description": this.description,
      "date": this.date,
    };

    if (this.id != null) {
      annotationMap["id"] = this.id;
    }

    return annotationMap;
  }
}