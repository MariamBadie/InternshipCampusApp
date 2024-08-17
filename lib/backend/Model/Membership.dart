class Membership{

  String userID;
  String communityID;

  Membership({ required this.userID, required this.communityID });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'communityID': communityID,
    };
  }

  factory Membership.fromMap(Map<String, dynamic> map){
    return Membership(
      userID: map['userID'],
      communityID: map['communityID'],
    );
  }

}