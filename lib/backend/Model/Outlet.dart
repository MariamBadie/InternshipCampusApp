class Outlet{

  String id;
  String name;

  Outlet({ required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Outlet.fromMap(Map<String, dynamic> map){
    return Outlet(
      id: map['id'],
      name: map['name'],
    );
  }

}