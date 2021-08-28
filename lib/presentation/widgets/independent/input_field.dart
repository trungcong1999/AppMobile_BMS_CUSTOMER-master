import 'package:flutter/material.dart';
import 'package:hosco/config/theme.dart';

class OpenFlutterInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final FormFieldValidator validator;
  final TextInputType keyboard;
  final FocusNode focusNode;
  final VoidCallback onFinished;
  final bool isPassword;
  final double horizontalPadding;
  final Function onValueChanged;
  final String error;

  const OpenFlutterInputField(
      {Key key,
      @required this.controller,
      this.hint,
      this.validator,
      this.keyboard = TextInputType.text,
      this.focusNode,
      this.onFinished,
      this.isPassword = false,
      this.horizontalPadding = 16.0,
      this.onValueChanged,
      this.error})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OpenFlutterInputFieldState();
  }
}

class OpenFlutterInputFieldState extends State<OpenFlutterInputField> {
  String error;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    //error = widget.error;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.hint,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Card(
            elevation: 3,
            shape: error != null
                ? RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  )
                : RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
            color: AppColors.white,
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TextField(
                  onChanged: (value) => widget.onValueChanged(value),
                  style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  keyboardType: widget.keyboard,
                  obscureText: widget.isPassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      // labelText: widget.hint,
                      hintText: widget.hint,
                      suffixIcon: error != null
                          ? Icon(
                              Icons.close,
                              color: AppColors.red,
                            )
                          : isChecked
                              ? Icon(Icons.done)
                              : null,
                      hintStyle: TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                ),
              ),
            ),
          ),
          error == null
              ? Container()
              : Text(
                  error,
                  style: TextStyle(color: AppColors.red, fontSize: 12),
                  textAlign: TextAlign.start,
                )
        ],
      ),
    );
  }

  String validate() {
    setState(() {
      error = widget.validator(widget.controller.text);
    });
    return error;
  }
}
