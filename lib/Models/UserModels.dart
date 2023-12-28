class UserModels {
  String uid;
  String email;
  String userName;
  String profilePhoto;
  String collegeName;
  String branch;
  bool isOnline;
  bool isEmail;
  List<String> groups;

  UserModels({
    required this.uid,
    required this.email,
    required this.userName,
    required this.profilePhoto,
    required this.collegeName,
    required this.branch,
    required this.isOnline,
    required this.isEmail,
    required this.groups,
  });

  factory UserModels.fromJson(Map<String, dynamic> json) {
    return UserModels(
      uid: json['uid'],
      email: json['email'],
      userName: json['userName'],
      profilePhoto: json['profilePhoto'],
      collegeName: json['collegeName'],
      branch: json['branch'],
      isOnline: json['isOnline'],
      isEmail: json['isEmail'],
      groups: (json['groups'] as List<dynamic>?)
              ?.map((tags) => tags.toString())
              .toList() ??
          [],
    );
  }
}
