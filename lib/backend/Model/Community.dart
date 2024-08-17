class Community{
  String id;
  String name;
  int membersCount;

  Community({required this.id, required this.name, required this.membersCount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'membersCount': membersCount,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map){
    return Community(
      id: map['id'],
      name: map['name'],
      membersCount: map['membersCount'],
    );
  }
}