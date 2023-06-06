import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:qr_code_scanner/qr_code_scanner.dart';
class Qr extends StatefulWidget {
  const Qr({super.key});
  @override
  State<Qr> createState() => _QrState();
}

class _QrState extends State<Qr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30))
                  : Text('Scan a code',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
            ),
          )
        ],
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

