import 'package:region_based_chat/models/story_model.dart';

import '../services/firebase_firestore_service.dart';

class MarkerRepository {
  final FirebaseFirestoreService firebaseFirestoreService;

  MarkerRepository(this.firebaseFirestoreService);

  Future<List<StoryMarkerModel>> fetchMarkers() async {
    final markers = await firebaseFirestoreService.getMarkers();
    return markers.map((doc) => StoryMarkerModel.fromMap(doc.data())).toList();
  }
}
