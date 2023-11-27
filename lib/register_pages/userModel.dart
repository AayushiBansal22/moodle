class UserModel {
  String? uid;
  String? email;
  String? fullName;
  List<String>? role;

  UserModel({this.uid, this.email, this.fullName, this.role});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      role: List<String>.from(map['role']), // convert the role from map to list
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role,
    };
  }
}
