import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';

class NotificationScreenView extends StatefulWidget {
  NotificationScreenView({Key key}) : super(key: key);

  @override
  _NotificationScreenViewState createState() => _NotificationScreenViewState();
}

class _NotificationScreenViewState extends State<NotificationScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, hoscoRoutes.home);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => Container(
            width: MediaQuery.of(context).size.width - 30,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  width: 0.44,
                  color: Colors.grey[400],
                )),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.grey[100]),
                        child: Container(
                          child: Icon(
                            Icons.notifications,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đơn hàng DH024668 đã hủy thành công',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                              'Khi mua  lon sữa Hoàng gia tăng cường miễn dịch Lacoferrin hồng hoặc 3 Lacroferrin xanh bạn sẽ được tặng ngay nhiệt kế điện tử cao cấp. Nha ...',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  fontSize: 12.0),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '13/08/2021',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
