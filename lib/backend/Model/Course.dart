enum Faculty { MET , IET, EMS, PBT, Management, Law,  ASA}
// ASA => Faculty of Applied Sciences and Arts
// EMS => Engineering and Materials Science
// PBT => Pharmacy and Biotechnology
// IET => Information Engineering and Technology
// MET => Media Engineering and Technology

class Course{

  String id;
  String name;
  Faculty faculty;

  Course({ required this.id, required this.name, required this.faculty});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'faculty': faculty,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map){
    return Course(
      id: map['id'],
      name: map['name'],
      faculty: map['faculty'],
    );
  }
}