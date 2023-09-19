class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String avatar;
  final String background;
  final String state;
  final List favoriteList;
  final List saveList;
  final List follow;
  final String role;
  final String gender;
  final String dob;

  UserModel(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.userName,
      required this.phoneNumber,
      required this.background,
      required this.avatar,
      required this.favoriteList,
      required this.saveList,
      required this.state,
      required this.follow,
      required this.role,
      required this.gender,
      required this.dob});

  factory UserModel.fromDocument(Map<String, dynamic> doc) {
    return UserModel(
        avatar: doc['avatar'],
        background: doc['background'],
        email: doc['email'],
        favoriteList: doc['favoriteList'],
        fullName: doc['fullName'],
        phoneNumber: doc['phonenumber'],
        saveList: doc['saveList'],
        state: doc['state'],
        id: doc['userId'],
        userName: doc['userName'],
        role: doc['role'],
        gender: doc['gender'],
        follow: doc['follow'],
        dob: doc['dob']);
  }
}
