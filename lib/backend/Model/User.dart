
enum UserType {
  student,
  teachingAssistant,
  doctor,
}

class User {

  // Missing the profile picture as the type is according to the implementation
  String id;
  String name;
  String email;
  String password;
  int year;
  DateTime registeredAt;
  double karma;
  UserType type;
  List<Map<String, dynamic>> favorites; // List of maps with 'post' reference and 'timestamp'
  List<String> archived; // archived posts
  List<String> blocked; // blocked users

  User({required this.id, required this.name, required this.email, required this.password,
  required this.year, required this.registeredAt, required this.karma, required this.type,
    this.favorites = const [], this.archived = const[], this.blocked = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'year': year,
      'registrationDate': registeredAt,
      'karma': karma,
      'type': type,
      'favorites': favorites,
      'archived': archived,
      'blocked': blocked
    };
  }

  factory User.fromMap(Map<String, dynamic> map){
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      year: map['year'],
      registeredAt: map['registrationDate'],
      karma: map['karma'],
      type: map['type'],
      favorites: List<Map<String, dynamic>>.from(map['favorites'] ?? []),
      archived: map['archived'],
      blocked: map['blocked']
    );
  }

}