import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/storage.dart';
import 'package:steps/steps.dart';

class QrCodeScreen extends StatefulWidget {
  QrCodeScreen({Key key}) : super(key: key);

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var sizedBox = SizedBox(
      height: 200,
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 180,
              color: Colors.red,
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(4),
                  height: height / 4,
                  width: width - 30,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: width - 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: BarcodeWidget(
                              barcode: Barcode.code93(),
                              data: Storage().account?.username ?? '',
                              width: 300,
                              height: 90,
                              style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 70, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, hoscoRoutes.home);
          },
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: Text(
          'Tích lũy điểm',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox,
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Quét mã để tích điểm khi thanh toán',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    width: 0.44,
                    color: Colors.grey[400],
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Expanded(
                child: Steps(
                  direction: Axis.vertical,
                  size: 20.0,
                  path: {'color': Colors.lightBlue.shade200, 'width': 3.0},
                  steps: [
                    {
                      'color': Colors.white,
                      'background': Colors.lightBlue.shade700,
                      'label': '1',
                      'content': Text(
                        'Mua sắm',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    },
                    {
                      'color': Colors.white,
                      'background': Colors.lightBlue.shade700,
                      'label': '2',
                      'content': Text(
                        'Tích lũy điểm',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      )
                    },
                    {
                      'color': Colors.white,
                      'background': Colors.lightBlue.shade700,
                      'label': '3',
                      'content': Text(
                        'Đổi phiếu chiết khấu',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      )
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
