import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/widgets/progress_dialog.dart';

import '../assistants/request_assistant.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../models/predicted_places.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async{
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: AppLocalization.of(context)!.progressDialog,
        ));

    String placeDirectionDetails = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKeyAndroid";

    var responseAPI = await RequestAssistant.receiveRequest(placeDirectionDetails);

    Navigator.pop(context);

    if(responseAPI == "Error Occurred, Failed. No Response."){
      return;
    }

    if(responseAPI["status"] == "OK"){
      Directions directions = Directions();
      directions.locationName = responseAPI["result"]["name"];
      directions.humanReadableAddress = responseAPI["result"]["formatted_address"];
      directions.locationId = placeId;
      directions.locationLatitude =  responseAPI["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =  responseAPI["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      Navigator.pop(context, "obtainedDropOff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.black87,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(Icons.add_location, color: Colors.grey,),
            const SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0,),
                  Text(
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 2.0,),

                  Text(
                    predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                    ),
                  ),

                  const SizedBox(height: 4.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
