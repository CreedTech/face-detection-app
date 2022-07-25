import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({Key? key}) : super(key: key);

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String data = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            QrImage(
              data: data,
              size: 200,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                controller: _textEditingController,
                onChanged: (value){
                  setState(() {
                    data = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: const Icon(Icons.qr_code_2_outlined),
              onPressed: () {}
          )
        ],
      ),
    );
  }
}
