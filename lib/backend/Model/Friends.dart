class Friends{
  String userID1;
  String userID2;

  Friends({required this.userID1, required this.userID2});

  Map<String, dynamic> toMap() {
    return {
      'userID1': userID1,
      'userID2': userID2
    };
  }

  factory Friends.fromMap(Map<String, dynamic> map){
    return Friends(
      userID1: map['userID1'],
      userID2: map['userID2'],
    );
  }
}