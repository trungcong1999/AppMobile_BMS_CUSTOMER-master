import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/presentation/features/authentication/authentication.dart';
import 'package:hosco/presentation/features/profile/views/history_point.dart';
import 'package:hosco/presentation/features/profile/views/orders.dart';
import 'package:hosco/presentation/features/wrapper.dart';
import 'package:hosco/presentation/widgets/independent/custom_button.dart';
import 'package:hosco/presentation/widgets/independent/menu_line.dart';
import 'package:hosco/presentation/widgets/independent/scaffold.dart';

import '../profile.dart';

class ProfileView extends StatefulWidget {
  final Function changeView;

  const ProfileView({Key key, this.changeView}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ProfileBloc>(context);
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    var profileInfo = Expanded(
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(top: 30),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(Storage().account?.avatar),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    onTap: (() => {
                          widget.changeView(
                              changeType: ViewChangeType.Exact, index: 6)
                        }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Storage().account?.name ?? '',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            Storage().account?.email ?? '',
            style: TextStyle(
                color: AppColors.lightGray, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [profileInfo],
    );
    var sizedBox = SizedBox(
      height: 200,
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 100,
              color: Colors.red,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 105, top: 30),
              child: InkWell(
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                onTap: (() => {
                      widget.changeView(
                          changeType: ViewChangeType.Exact, index: 1)
                    }),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 8,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(Storage().account?.avatar),
                        // image: AssetImage('assets/splash/bottombanner.png'),
                      ),
                    ),
                  ),
                  onTap: (() => {
                        widget.changeView(
                            changeType: ViewChangeType.Exact, index: 1)
                      }),
                ),
                Text(
                  Storage().account?.name ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  Storage().account?.email ?? '',
                  style: TextStyle(
                      color: AppColors.lightGray, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          // header,
          sizedBox,
          Expanded(
            child: ListView(
              children: [
                ProfileListItem(
                  icon: Icons.shopping_cart,
                  text: 'Đơn hàng của tôi',
                  // onTap: (() => {
                  //       bloc..add(ProfileMyOrdersEvent()),
                  //       // widget.changeView(
                  //       //     changeType: ViewChangeType.Exact, index: 1)
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => MyOrdersView())),
                  //     }),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyOrdersView()
                        ));
                  },
                ),
                ProfileListItem(
                  icon: Icons.airplane_ticket_sharp,
                  text: 'Lịch sử tích điểm',
                  onTap: (() => {
                        // widget.changeView(
                        //     changeType: ViewChangeType.Exact, index: 2)
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryPointView())),
                      }),
                ),
                // ProfileListItem(
                //   icon: Icons.wallet_giftcard,
                //   text: 'Ưu đãi của tôi',
                //   onTap: (() => {
                //         widget.changeView(
                //             changeType: ViewChangeType.Exact, index: 3)
                //       }),
                // ),
                // ProfileListItem(
                //   icon: Icons.settings,
                //   text: 'Cài đặt',
                //   onTap: (() => {
                //         widget.changeView(
                //             changeType: ViewChangeType.Exact, index: 6)
                //       }),
                // ),
                ProfileListItem(
                  icon: Icons.logout_sharp,
                  text: 'Đăng xuất',
                  hasNavigation: false,
                  onTap: (() => {
                    Navigator.pop(context),
                  authBloc.add(LoggedOut())
                }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.red,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final text;
  final bool hasNavigation;
  final VoidCallback onTap;
  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 55,
        // margin: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            width: 0.44,
            color: Colors.grey[400],
          )),
        ),

        child: Row(
          children: [
            Icon(
              this.icon,
              size: 25,
              color: Colors.red,
            ),
            SizedBox(
              width: 25,
            ),
            Text(
              this.text,
              style: TextStyle().copyWith(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                Icons.chevron_right,
                size: 25,
                color: Colors.black,
              ),
          ],
        ),
      ),
      onTap: onTap,
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
    // path.moveTo(0, size.height-40);
    // path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-40);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);
    // path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
