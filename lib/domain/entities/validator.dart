class Validator {
  static String valueExists(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Please fill this field';
    } else {
      return null;
    }
  }

  static String passwordCorrect(dynamic value) {
    var emptyResult = valueExists(value);
    if (emptyResult == null || emptyResult.isEmpty) {
      //TODO:
      return null;

      var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[#?!@$%^&*-]).{8,}$';
      var regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return 'Your password must be at least 8 symbols with number, big and small letter and special character (!@#\$%^&*).';
      } else {
        return null;
      }
    } else {
      return 'Mật khẩu không được để trống!';
      //return emptyResult;
    }
  }

  static String validateEmail(dynamic value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(pattern);
    var emptyResult = valueExists(value);
    if (emptyResult != null) {
      return emptyResult;
    } else if (!regExp.hasMatch(value)) {
      return 'Not a valid email address. Should be your@email.com';
    } else {
      return null;
    }
  }

  static String validateUsername(dynamic value) {
    if (value.isEmpty) {
      return 'Tên đăng nhập không được để trống';
    }
    return null;
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(pattern);
    var emptyResult = valueExists(value);
    if (emptyResult != null) {
      return emptyResult;
    } else if (!regExp.hasMatch(value)) {
      return 'Not a valid email address. Should be your@email.com';
    } else {
      return null;
    }
  }

  static String validateCusCode(dynamic value) {
    if (value.isEmpty) {
      return 'Mã khách hàng không được để trống';
    }
    return null;

  }
}
