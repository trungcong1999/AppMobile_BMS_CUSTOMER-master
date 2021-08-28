import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/domain/entities/validator.dart';
import 'package:hosco/presentation/features/sign_in/FadeAnimation.dart';
import 'package:hosco/presentation/features/sign_up/sign_up.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import 'sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tenantController = TextEditingController();
  final GlobalKey<OpenFlutterInputFieldState> emailKey = GlobalKey();
  final GlobalKey<OpenFlutterInputFieldState> passwordKey = GlobalKey();
  final GlobalKey<OpenFlutterInputFieldState> tenantKey = GlobalKey();

  double sizeBetween;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    sizeBetween = height / 20;
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Đăng nhập', style: Theme.of(context).accentTextTheme.headline4.copyWith(
      //   //   color: Colors.lightBlue, fontWeight: FontWeight.bold
      //   // ),),
      //   title: null,
      //   centerTitle: true,
      //   backgroundColor: AppColors.transparent,
      //   brightness: Brightness.light,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: AppColors.black),
      // ),
      backgroundColor: AppColors.background,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          // on success delete navigator stack and push to home
          if (state is SignInFinishedState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              hoscoRoutes.home,
              (Route<dynamic> route) => false,
            );
          }
          // on failure show a snackbar
          if (state is SignInErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          // show loading screen while processing
          if (state is SignInProcessingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          tenantController.text = Storage()?.account?.tenantCode ?? '';
          emailController.text = Storage()?.account?.username ?? '';
          passwordController.text = Storage()?.account?.password ?? '';
          return Scaffold(
            backgroundColor: Colors.grey,
            body: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF5F5F5),
                        Color(0xFFF5F5F5),
                        Color(0xFFF5F5F5),
                        Color(0xFFF5F5F5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 80.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,),
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/icons/signin/icon2.png'),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'MasterPro Loyalty',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 25.0),
                        OpenFlutterInputField(
                          key: tenantKey,
                          controller: tenantController,
                          hint: 'Mã khách hàng',
                          validator: Validator.validateCusCode,
                          onValueChanged: (val) {},
                          //error: tenantKey.currentState.validate(),
                        ),
                        SizedBox(height: 15.0),
                        OpenFlutterInputField(
                          key: emailKey,
                          controller: emailController,
                          hint: 'Tên đăng nhập',
                          validator: Validator.validateUsername,
                          onValueChanged: (val) {},
                          //error: emailKey.currentState.validate(),
                        ),
                        SizedBox(height: 15.0),
                        OpenFlutterInputField(
                          key: passwordKey,
                          controller: passwordController,
                          hint: 'Mật khẩu',
                          validator: Validator.passwordCorrect,
                          keyboard: TextInputType.visiblePassword,
                          isPassword: true,
                          onValueChanged: (val) {},
                        ),
                        _buildLoginBtn(),
                        // OpenFlutterButton(
                        //     title: 'ĐĂNG NHẬP', onPressed: _validateAndSend),
                        SizedBox(height: height * 0.03),
                        // _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          // return SingleChildScrollView(
          //   child: Container(
          //     height: height * 0.9,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Stack(children: <Widget>[
          //           Align(
          //             alignment: Alignment.topCenter,
          //             child: AppLogo(),
          //           ),
          //         ]),
          //         SizedBox(
          //           height: sizeBetween,
          //         ),
          //         OpenFlutterInputField(
          //           key: tenantKey,
          //           controller: tenantController,
          //           hint: 'Mã khách hàng',
          //           validator: Validator.validateCusCode,
          //           onValueChanged: (val) {},
          //           //error: tenantKey.currentState.validate(),
          //         ),
          //         OpenFlutterInputField(
          //           key: emailKey,
          //           controller: emailController,
          //           hint: 'Tên đăng nhập',
          //           validator: Validator.validateUsername,
          //           onValueChanged: (val) {},
          //           //error: emailKey.currentState.validate(),
          //         ),
          //         // OpenFlutterInputField(
          //         //   key: emailKey,
          //         //   controller: emailController,
          //         //   hint: 'Email',
          //         //   validator: Validator.validateEmail,
          //         //   keyboard: TextInputType.emailAddress,
          //         // ),
          //         OpenFlutterInputField(
          //           key: passwordKey,
          //           controller: passwordController,
          //           hint: 'Mật khẩu',
          //           validator: Validator.passwordCorrect,
          //           keyboard: TextInputType.visiblePassword,
          //           isPassword: true,
          //           onValueChanged: (val) {},
          //         ),
          //         /*OpenFlutterRightArrow(
          //           'Forgot your password',
          //           onClick: _showForgotPassword,
          //         ),*/
          //         OpenFlutterButton(
          //             title: 'ĐĂNG NHẬP', onPressed: _validateAndSend),
          //         SizedBox(
          //           height: sizeBetween * 2,
          //         ),
          //         /* Padding(
          //           padding: EdgeInsets.only(bottom: AppSizes.linePadding),
          //           child: Center(
          //             child: Text('Or sign up with social account'),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.symmetric(horizontal: width * 0.2),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: <Widget>[
          //               OpenFlutterServiceButton(
          //                 serviceType: ServiceType.Google,
          //                 onPressed: () {
          //                   BlocProvider.of<SignInBloc>(context).add(
          //                     SignInPressedGoogle(),
          //                   );
          //                 },
          //               ),
          //               OpenFlutterServiceButton(
          //                 serviceType: ServiceType.Facebook,
          //                 onPressed: () {
          //                   BlocProvider.of<SignInBloc>(context).add(
          //                     SignInPressedFacebook(),
          //                   );
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //         */
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  void _showForgotPassword() {
    Navigator.of(context).pushNamed(hoscoRoutes.forgotPassword);
  }

  void _validateAndSend() {
    if (tenantKey.currentState.validate() != null) {
      tenantKey.currentState.error = tenantKey.currentState.validate();
      return;
    }

    if (emailKey.currentState.validate() != null) {
      emailKey.currentState.error = emailKey.currentState.validate();
      return;
    }

    if (passwordKey.currentState.validate() != null) {
      passwordKey.currentState.error = passwordKey.currentState.validate();
      return;
    }
    BlocProvider.of<SignInBloc>(context).add(
      SignInPressed(
        tenantCode: tenantController.text,
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _validateAndSend,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.red,
        child: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Column(
      children: [
        Center(
          child: Text('Copyright '),
        ),
      ],
    );
  }
}

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.green[800]),
      child: CircleAvatar(
        radius: 60.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/icons/signin/icon2.png'),
        // backgroundImage: NetworkImage(
        //     'https://images.pexels.com/photos/462118/pexels-photo-462118.jpeg?cs=srgb&dl=bloom-blooming-blossom-462118.jpg&fm=jpg'),
      ),
    );
  }
}
