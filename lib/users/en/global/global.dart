import 'package:firebase_auth/firebase_auth.dart';

import '../../../users/en/models/direction_details_info.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuthUser = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //Drivers key list
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String cloudMessagingServerToken = "key=AAAAllq7gd8:APA91bH3Z_rJ4PD24EjcVwiTZ0dUJJtgDwhvxsQHI-LkD5KCwkBpKExjWGKMLrrpodarTnQI7NvF4hRIZ-5ycn9u74uEp5gKt0gd_lA-nBPHP10kpNNcFDmhjvjCokBQFzKs4MfPPtwh";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";