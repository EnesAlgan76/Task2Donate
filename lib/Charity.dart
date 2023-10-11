import 'package:cloud_firestore/cloud_firestore.dart';

class Charity {
  final String id;
  final String name;
  final String description;

  Charity({required this.id, required this.name, required this.description});

  factory Charity.fromSnapshot(QueryDocumentSnapshot doc) {
    return Charity(
      id: doc.id,
      name: doc['name'],
      description: doc['description'],
    );
  }
}
