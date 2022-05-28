  
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrCode extends StatefulWidget {

  static const String routeName = '/qrCode';
  static String mesa = "";

  @override
  _QrCode createState() => _QrCode();

  static bool setMesa(var id) {
    mesa = id;

    return true;
  }

  static String getMesa() {


    return mesa;
  }

}

class _QrCode extends State<QrCode> {

  final String data = QrCode.getMesa();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Código QR"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Mesa: $data",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16,),

            QrImage(
              data: data,
              gapless: true,
              size: 250,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            )
          ],
        ),
      ),
    );
  }
}