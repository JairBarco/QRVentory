import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class PayFareAmountCollectionDialog extends StatefulWidget {
  double? fareAmount;

  PayFareAmountCollectionDialog({this.fareAmount});

  @override
  State<PayFareAmountCollectionDialog> createState() =>
      _PayFareAmountCollectionDialogState();
}

class _PayFareAmountCollectionDialogState
    extends State<PayFareAmountCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Costo del viaje",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 4,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.fareAmount.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 50),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Total del viaje",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.pop(context, "cashPayed");
                    Restart.restartApp();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pagar",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "\$" + widget.fareAmount!.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
