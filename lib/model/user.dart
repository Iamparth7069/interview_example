class User{
  String fName;
  String lName;
  String contactNumber;
  String email;
  int? id;
  String profileImages;
  String designation;
  String password;

  User(
      {required this.fName,
        required this.password,
      required this.lName,
      required this.contactNumber,
      required this.email,
      this.id,
      required this.profileImages,
      required this.designation});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      password: json["password"],
      fName: json["fName"],
      lName: json["lName"],
      contactNumber: json["contactNumber"],
      email: json["email"],
      id: json["id"],
      profileImages: json["profileImages"],
      designation: json["designation"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "password" : this.password,
      "fName": this.fName,
      "lName": this.lName,
      "contactNumber": this.contactNumber,
      "email": this.email,
      "profileImages": this.profileImages,
      "designation": this.designation,
    };
  }

  User.WithId(
      {required this.fName,
      required this.lName,
      required this.contactNumber,
      required this.email,
      this.id,
      required this.profileImages,
      required this.designation,
      required this.password});

//
}