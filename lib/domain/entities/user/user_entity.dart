import 'package:hosco/domain/entities/entity.dart';

class UserEntity extends Entity<String> {
  final String name;
  final String username;
  final String avatar;
  final String email;
  final String password;
  final String birthDate;
  final String token;
  final bool salesNotification;
  final bool newArrivalsNotification;
  final bool deliveryStatusChanges;
  final String tenantCode;
  final bool isAdmin;
  final String address;
  final String mobile;
  final String Company_Tel1;
  final String Company_Tel2;

  UserEntity(
      {String id,
      this.name,
      this.username,
      this.avatar,
      this.email,
      this.password,
      this.birthDate,
      this.token,
      this.salesNotification,
      this.newArrivalsNotification,
      this.deliveryStatusChanges,
      this.tenantCode,
      this.address,
      this.mobile,
      this.Company_Tel1,
      this.Company_Tel2,
      this.isAdmin})
      : super(id);

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      avatar: json['avatar'],
      email: json['email'],
      password: json['password'],
      tenantCode: json['tenantCode'],
      token: json['token'],
      isAdmin: json['isAdmin'],
      address: json['Address'],
      mobile: json['Mobile'],
      Company_Tel1: json['Company_Tel1'] ,
      Company_Tel2: json['Company_Tel2'] ,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'avatar': avatar,
        'email': email,
        'password': password,
        'tenantCode': tenantCode,
        'token': token,
        'isAdmin': isAdmin,
        'address': address,
        'mobile': mobile,
        'Company_Tel1': Company_Tel1,
        'Company_Tel2': Company_Tel2,
      };

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
      'email': email,
      'password': password,
      'birthDate': birthDate,
      'token': token,
      'salesNotification': salesNotification,
      'newArrivalsNotification': newArrivalsNotification,
      'deliveryStatusChanges': deliveryStatusChanges,
      'tenantCode': tenantCode,
      'isAdmin': isAdmin,
      'address': address,
      'mobile': mobile,
      'Company_Tel1': Company_Tel1,
      'Company_Tel2': Company_Tel2,
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        username,
        avatar,
        email,
        password,
        birthDate,
        token,
        salesNotification,
        newArrivalsNotification,
        deliveryStatusChanges,
        tenantCode,
        isAdmin,
        address,
        mobile,
        Company_Tel1,
        Company_Tel2,
      ];
}
