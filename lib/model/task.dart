// data class
class Task {
  static const String collectionName = 'tasks';
  String? title;
  String? description;
  DateTime? date;
  String? id;
  bool? isDone;

  /// constructor
  Task({
    required this.title,
    required this.description,
    required this.date,
    this.id = '',
    this.isDone = false,
  });

  /// named constructor
  // from Json
  // Map => Object
  Task.fromFirestore(Map<String, dynamic> data) : this(
    title: data['title'],
    description: data['description'],
    date: DateTime.fromMillisecondsSinceEpoch(data['date']),
    id: data['id'],
    isDone: data['isDone']
  );

  bool taskDone(){
    return isDone ?? false;
  }

  /// method
  // to Json
  // Object => Map
  Map<String, dynamic> toFirestore() {
    return {
      'id' : id,
      'title' : title,
      'description' : description,
      'date' : date?.millisecondsSinceEpoch, // Epoch time
      'isDone' : isDone
    };
  }
}