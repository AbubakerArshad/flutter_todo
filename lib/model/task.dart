class Task {
  int? id;
  String? title;
  int? isDone;
  String? dateTime;

  Task({this.id, this.title, this.isDone, this.dateTime});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isDone = json['isDone'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['isDone'] = this.isDone;
    data['dateTime'] = this.dateTime;
    return data;
  }
}