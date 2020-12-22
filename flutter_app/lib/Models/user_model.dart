class UserModel {
  final int id;
  final String username;
  final String password;
  final String address;
  final String fullName;
  final String phoneNumber;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.address,
    this.fullName,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      address: json['address'],
      password: json['password'],
      fullName: json['name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['address'] = this.address;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
