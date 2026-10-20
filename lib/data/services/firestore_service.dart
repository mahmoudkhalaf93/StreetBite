import 'package:cloud_firestore/cloud_firestore.dart';

/// Pattern: Singleton Pattern
/// Why: Ensures only one instance of FirestoreService exists globally, avoiding multiple initializations and reducing memory footprint.
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // Global helper methods can be added here if needed
}
