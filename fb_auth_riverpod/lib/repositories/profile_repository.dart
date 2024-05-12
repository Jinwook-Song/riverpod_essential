import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/models/app_user.dart';
import 'package:fb_auth_riverpod/repositories/handle_exception.dart';

class ProfileRepository {
  Future<AppUser> getProfile(String uid) async {
    try {
      final DocumentSnapshot appUserDoc = await usersCollectoin.doc(uid).get();

      if (appUserDoc.exists) {
        return AppUser.fromDoc(appUserDoc);
      }

      throw 'User not found';
    } catch (e) {
      throw handleException(e);
    }
  }
}
