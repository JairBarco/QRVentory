import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuthUser = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
String cloudMessagingServerToken =
    "key=AAAAllq7gd8:APA91bH3Z_rJ4PD24EjcVwiTZ0dUJJtgDwhvxsQHI-LkD5KCwkBpKExjWGKMLrrpodarTnQI7NvF4hRIZ-5ycn9u74uEp5gKt0gd_lA-nBPHP10kpNNcFDmhjvjCokBQFzKs4MfPPtwh";