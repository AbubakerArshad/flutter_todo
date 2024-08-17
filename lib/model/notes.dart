class Notes {
  int? id;
  String? title;
  String? description;
  String? dateTime;

  Notes({this.id, this.title, this.description, this.dateTime});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['dateTime'] = this.dateTime;
    return data;
  }

  static Notes fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: map['dateTime'],
    );
  }
}