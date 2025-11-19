class User {
  final String name;
  final String email;
  final String profileImage;

  User({
    required this.name,
    required this.email,
    required this.profileImage,
  });
}

final User dummyUser = User(
  name: "Nazzar",
  email: "user@coffee.com",
  profileImage: "assets/images/profile_pic.jpeg",
);