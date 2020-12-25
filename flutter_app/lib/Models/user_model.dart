class UserModel {
  final int id;
  final String password;
  final String address;
  final String name;
  final String phoneNumber;

  UserModel({
    this.id,
    this.password,
    this.address,
    this.name,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      address: json['address'],
      password: json['password'],
      name: json['name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['password'] = this.password;
    data['full_name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
