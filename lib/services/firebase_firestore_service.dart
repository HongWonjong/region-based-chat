import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore firestore;

  FirebaseFirestoreService(this.firestore);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchMarkers() async {
    final snapshot = await firestore.collection('markers').get();
    return snapshot.docs;
  }
}
