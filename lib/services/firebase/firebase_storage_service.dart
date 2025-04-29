import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage fireStorage;

  FirebaseStorageService(this.fireStorage);

  Reference getProfileImageReference(String uid) {
    return fireStorage.ref().child('users/profileImages/$uid.jpg');
  }

  Future<void> putFilebyReference(Reference ref, String url) async {
    await ref.putFile(File(url));
  }

  Future<String> getDownloadUrl(Reference ref) async {
    return await ref.getDownloadURL();
  }
}
