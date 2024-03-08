import 'package:firebase_database/firebase_database.dart';
import '../global/global.dart';
import '../models/user_model.dart';

class AssistantMethods {

  static Future<void> readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuthUser.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);
    final snap = await userRef.once();
    if (snap.snapshot.value != null) {
      userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
    }
  }
}

