import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

final FirebaseAuth fAuthUser = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;