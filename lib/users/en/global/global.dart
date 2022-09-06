import 'package:firebase_auth/firebase_auth.dart';

import '../../../users/en/models/direction_details_info.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuthUser = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //Drivers key list
DirectionDetailsInfo? tripDirectionDetailsInfo;