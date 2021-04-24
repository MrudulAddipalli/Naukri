class User {
  String email;
  String name;
  String password;
  String confirmpassword;
  String skills;
  int userRole;
  String createdAt;
  String updatedAt;
  String id;
  String token;

  User(
      {this.email,
      this.name,
      this.password,
      this.confirmpassword,
      this.skills,
      this.userRole,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    password = json['password'];
    password = json['confirmpassword'];
    skills = json['skills'];
    userRole = json['userRole'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['password'] = this.password;
    data['confirmpassword'] = this.confirmpassword;
    data['skills'] = this.skills;
    data['userRole'] = this.userRole;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['token'] = this.token;
    return data;
  }
}
