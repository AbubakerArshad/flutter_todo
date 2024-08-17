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

  // Convert a Map into a Todo.
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] is int ? map['isDone'] : int.tryParse(map['isDone'] ?? '0'),
      dateTime: map['dateTime'],
    );
  }
}