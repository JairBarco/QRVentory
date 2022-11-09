import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> callOnFcmApiSendPushNotifications(
    {required String title, required String body}) async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "to": "/topics/chats",
    "notification": {
      "title": title,
      "body": body,
    },
    "data": {
      "type": '0rder',
      "id": '28',
      "click_action": 'FLUTTER_NOTIFICATION_CLICK',
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'key=AAAAllq7gd8:APA91bH3Z_rJ4PD24EjcVwiTZ0dUJJtgDwhvxsQHI-LkD5KCwkBpKExjWGKMLrrpodarTnQI7NvF4hRIZ-5ycn9u74uEp5gKt0gd_lA-nBPHP10kpNNcFDmhjvjCokBQFzKs4MfPPtwh'
    // 'key=YOUR_SERVER_KEY'
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}
