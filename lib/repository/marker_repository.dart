import '../models/marker.dart';
import '../services/firebase_firestore_service.dart';

class MarkerRepository {
  final FirebaseFirestoreService firebaseFirestoreService;

  MarkerRepository(this.firebaseFirestoreService);

  Future<List<Marker>> fetchMarkers() async {
    final markers = await firebaseFirestoreService.getMarkers();
    return markers.map((doc) => Marker.fromFirestore(doc)).toList();
  }
}
