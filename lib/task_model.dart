class Task {
  final int? id;
  final String title;
  int pomodoroCount;
  Task({this.id, required this.title, this.pomodoroCount = 0});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],

      pomodoroCount: map['pomodoroCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'pomodoroCount': pomodoroCount};
  }
}
