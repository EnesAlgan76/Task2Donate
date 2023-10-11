import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final int points;

  Task({required this.id, required this.name, required this.description, required this.points});

  factory Task.fromSnapshot(QueryDocumentSnapshot doc) {
    return Task(
      id: doc.id,
      name: doc['name'],
      description: doc['description'],
      points: doc['points'],
    );
  }
}
