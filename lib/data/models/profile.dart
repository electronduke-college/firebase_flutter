class Profile {
  final String authUid;
  final String email;
  final String name;
  final String password;
  final String surname;

  Profile({
    required this.email,
    required this.name,
    required this.surname,
    required this.authUid,
    required this.password,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      password: json['password'],
      authUid: json['authUid'],
      surname: json['surname'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'email' : email,
      'surname' : surname,
      'name' : name,
      'authUid' : authUid,
      'password' : password,
    };
  }
}
