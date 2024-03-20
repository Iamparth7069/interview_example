class Contact{

  String email;
  String password;
  int? id;
  int? uid;
  String name;
  Contact({this.uid, required this.name,this.id, required this.email, required this.password});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json["cid"],
      name: json["name"],
      uid: json["uid"],
      email: json["email"],
      password: json["pass"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name":this.name,
      "email": this.email,
      "pass": this.password,
      "uid" : this.uid,
    };
  }

}