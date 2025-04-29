import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore firestore;

  FirebaseFirestoreService(this.firestore);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMarkers() async {
    final snapshot = await firestore.collection('markers').get();
    return snapshot.docs;
  }

  Future<void> setUsersByUid(Map<String, dynamic> userInfo) async {
    await firestore.collection('users').doc(userInfo['uid']).set(userInfo);
  }
}
