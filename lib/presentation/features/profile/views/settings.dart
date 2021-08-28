import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/data/repositories/fake_repos/password_repository.dart';
import 'package:hosco/data/repositories/fake_repos/settings_repository.dart';
import 'package:hosco/data/repositories/user_repository_impl.dart';
import 'package:hosco/domain/entities/validator.dart';
import 'package:hosco/presentation/features/profile/password_bloc.dart';
import 'package:hosco/presentation/features/profile/password_event.dart';
import 'package:hosco/presentation/features/profile/password_state.dart';
import 'package:hosco/presentation/features/profile/settings_bloc.dart';
import 'package:hosco/presentation/features/profile/settings_event.dart';
import 'package:hosco/presentation/features/profile/settings_state.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

class SettingsView extends StatefulWidget {
  final Function changeView;

  const SettingsView({Key key, this.changeView}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _currentPasswordController;
  TextEditingController _newPasswordController;
  TextEditingController _repeatPasswordController;
  TextEditingController _fullNameController;
  TextEditingController _dateOfBirthController;

  final GlobalKey<OpenFlutterInputFieldState> _currentPasswordKey = GlobalKey();
  final GlobalKey<OpenFlutterInputFieldState> _newPasswordKey = GlobalKey();

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _fullNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController?.dispose();
    _newPasswordController?.dispose();
    _repeatPasswordController?.dispose();
    _fullNameController?.dispose();
    _dateOfBirthController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = SettingsBloc(settingsRepository: SettingsRepository());

    return BlocProvider<SettingsBloc>(
      create: (context) => settingsBloc,
      child: BlocBuilder<SettingsBloc, SettingsState>(
          cubit: settingsBloc,
          builder: (context, state) {
            _fullNameController.text = state.settings.fullName;
            _dateOfBirthController.text = state.settings.dateOfBirth;

            return Scaffold(
                appBar: AppBar(
                title: Text('Tài khoản',style: TextStyle(color: Colors.white),),
                centerTitle: true,
                backgroundColor: Colors.red,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, hoscoRoutes.profile);
                    },
                  ),
            ),
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.all(AppSizes.sidePadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Thông tin cá nhân',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  OpenFlutterInputField(
                    controller: _fullNameController,
                    hint: 'Họ tên',
                    horizontalPadding: 0,
                    onValueChanged: (value) => settingsBloc
                      ..add(UpdateFullNameEvent(
                          fullName: value.toString().trim())),
                  ),/*
                  SizedBox(
                    height: 24,
                  ),
                  OpenFlutterInputField(
                    controller: _dateOfBirthController,
                    hint: 'Ngày sinh',
                    horizontalPadding: 0,
                    onValueChanged: (value) => settingsBloc.add(
                        UpdateDateOfBirthEvent(
                            dateOfBirth: value.toString().trim())),
                  ),*/
                  SizedBox(
                    height: 55,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Mật khẩu',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showChangePasswordBottomSheet(context);
                        },
                        child: Text(
                          'Thay đổi',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  /*
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sales',
                        style: TextStyle(fontSize: 14, color: AppColors.black),
                      ),
                      CupertinoSwitch(
                        //trackColor: AppColors.lightGray,
                        value: state.settings.notifySales,
                        activeColor: AppColors.success,
                        onChanged: (newValue) => settingsBloc
                            .add(UpdateNotifySalesEvent(notifySales: newValue)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'New arrivals',
                        style: TextStyle(fontSize: 14, color: AppColors.black),
                      ),
                      CupertinoSwitch(
                        //trackColor: AppColors.lightGray,
                        value: state.settings.notifyArrivals,
                        activeColor: AppColors.success,
                        onChanged: (newValue) => settingsBloc
                          ..add(UpdateNotifyArrivalsEvent(
                              notifyArrivals: newValue)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Delivery status changes',
                        style: TextStyle(fontSize: 14, color: AppColors.black),
                      ),
                      CupertinoSwitch(
                        //trackColor: AppColors.lightGray,
                        value: state.settings.notifyDelivery,
                        activeColor: AppColors.success,
                        onChanged: (newValue) => settingsBloc
                          ..add(UpdateNotifyDeliveryEvent(
                              notifyDelivery: newValue)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),*/
                ],
              ),
            )));
          }),
    );
  }

  void _showChangePasswordBottomSheet(BuildContext context) {
    var passwordBloc = PasswordBloc(passwordRepository: PasswordRepository(), userRepository: RepositoryProvider.of<UserRepository>(context));

    showDialog(
    //showModalBottomSheet(
        context: context,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(34), topRight: Radius.circular(34)),
        // ),
        builder: (BuildContext context) => BlocProvider<PasswordBloc>(
              create: (context) => passwordBloc,
              child: BlocBuilder<PasswordBloc, PasswordState>(
                  cubit: passwordBloc,
                  builder: (context, state) {
                    if (state is PasswordChangedState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // close bottom sheet
                        Navigator.pop(context);

                        _showAlertDialog(context, 'Thông báo',
                            'Đổi mật khẩu thành công');

                        clearPasswordFields();
                      });
                    } else if (state is ChangePasswordErrorState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showAlertDialog(context, 'Lỗi', state.errorMessage);
                      });
                    } else if (state is IncorrectCurrentPasswordState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showAlertDialog(context, 'Lỗi', 'Mật khẩu hiện tại không đúng');
                      });
                    }

                    return AlertDialog(
                      //insetPadding: EdgeInsets.fromLTRB(50, 150, 50, 150),
                      // height: 472,
                      // padding: AppSizes.bottomSheetPadding,
                      // decoration: BoxDecoration(
                      //     color: AppColors.background,
                      //     borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(34),
                      //         topRight: Radius.circular(34)),
                      //     boxShadow: []),
                      content: Stack(
                        overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close),
                                ),
                              ),
                            ),
                            /*Container(
                              height: 6,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),*/

                      SingleChildScrollView(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                            // SizedBox(
                            //   height: 16,
                            // ),
                            Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            OpenFlutterInputField(
                              key: _currentPasswordKey,
                              controller: _currentPasswordController,
                              validator: Validator.passwordCorrect,
                              isPassword: true,
                              hint: 'Mật khẩu hiện tại',
                              error: state is EmptyCurrentPasswordState
                                  ? 'không được để trống'
                                  : state is IncorrectCurrentPasswordState
                                      ? 'mật khẩu hiện tại không đúng'
                                      : null,
                            ),
                            /*SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: AppColors.lightGray),
                                ),
                              ],
                            ),*/
                            SizedBox(
                              height: 18,
                            ),
                            OpenFlutterInputField(
                              key: _newPasswordKey,
                              controller: _newPasswordController,
                              validator: Validator.passwordCorrect,
                              isPassword: true,
                              hint: 'Mật khẩu mới',
                              error: state is EmptyNewPasswordState
                                  ? 'không được để trống'
                                  : state is InvalidNewPasswordState
                                      ? 'password should be at least 6 characters'
                                      : null,
                            ),
                            /*SizedBox(
                              height: 18,
                            ),
                            OpenFlutterInputField(
                              controller: _repeatPasswordController,
                              hint: 'Repeat New Password',
                              error: state is EmptyRepeatPasswordState
                                  ? 'field cannot be empty'
                                  : state is PasswordMismatchState
                                      ? 'password mismatch'
                                      : null,
                            ),*/
                            SizedBox(
                              height: 18,
                            ),
                            OpenFlutterButton(
                                title: 'Lưu',
                                height: 48,
                                onPressed: () {
                                  if (_currentPasswordKey.currentState.validate() != null) {
                                    _currentPasswordKey.currentState.error = _currentPasswordKey.currentState.validate();
                                    return;
                                  }

                                  if (_newPasswordKey.currentState.validate() != null) {
                                    _newPasswordKey.currentState.error = _newPasswordKey.currentState.validate();
                                    return;
                                  }
                                  var t = passwordBloc
                                    ..add(ChangePasswordEvent(
                                        currentPassword:
                                        _currentPasswordController.text
                                            .trim(),
                                        newPassword:
                                        _newPasswordController.text.trim(),
                                        repeatNewPassword:
                                        _repeatPasswordController.text
                                            .trim()));
                                  if (t.state is IncorrectCurrentPasswordState) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _showAlertDialog(context, 'Lỗi', 'Mật khẩu hiện tại không đúng');
                                    });
                                  }
                                }),
                          ],
                        ),
                      ),]),
                    );
                  }),
            ));
  }

  Future<void> _showAlertDialog(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content, style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearPasswordFields() {
    _currentPasswordController.text = '';
    _newPasswordController.text = '';
    _repeatPasswordController.text = '';
  }
}
