

import 'package:campus_app/view_others_profile/activity_list.dart';
import 'package:campus_app/view_others_profile/profile_page.dart';
import 'package:flutter/material.dart';


class RunViewOthersProfile extends StatefulWidget{
  const RunViewOthersProfile({super.key});

  @override
  State<RunViewOthersProfile> createState() {
    return _RunViewOthersProfileState();
  }
}

class _RunViewOthersProfileState extends State<RunViewOthersProfile>{
  @override
  Widget build(BuildContext context) {
    return const ProfilePage(
        profileImageUrl: 'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1722211200&semt=ais_user',
        profilePageUrl: 'drafturl',
        username: 'yas123',
        fullName: 'Yasmeen Yasser',
        bio: 'This is my bio',
        location: 'Cairo, Egypt',
        postCount: 120,
        followerCount: 12000,
        followingCount: 1200,
        body: ActivityList(
          activityData: [
            {
              'profileImageUrl': 'https://media.istockphoto.com/id/1451587807/vector/user-profile-icon-vector-avatar-or-person-icon-profile-picture-portrait-symbol-vector.jpg?s=612x612&w=0&k=20&c=yDJ4ITX1cHMh25Lt1vI1zBn2cAKKAlByHBvPJ8gEiIg=',
              'userName': 'User1',
              'activityDescription': 'Liked "Autumn in my heart"',
              'timestamp': '1 hour ago',
              'isImage': false,
            },
            {
              'profileImageUrl': 'https://media.istockphoto.com/id/1451587807/vector/user-profile-icon-vector-avatar-or-person-icon-profile-picture-portrait-symbol-vector.jpg?s=612x612&w=0&k=20&c=yDJ4ITX1cHMh25Lt1vI1zBn2cAKKAlByHBvPJ8gEiIg=',
              'userName': 'User2',
              'activityDescription': 'Commented on a post',
              'timestamp': '2 hours ago',
              'isImage': false,
            },
            {
              'profileImageUrl': 'https://media.istockphoto.com/id/1451587807/vector/user-profile-icon-vector-avatar-or-person-icon-profile-picture-portrait-symbol-vector.jpg?s=612x612&w=0&k=20&c=yDJ4ITX1cHMh25Lt1vI1zBn2cAKKAlByHBvPJ8gEiIg=',
              'userName': 'User3',
              'activityDescription': 'https://media.istockphoto.com/id/1451587807/vector/user-profile-icon-vector-avatar-or-person-icon-profile-picture-portrait-symbol-vector.jpg?s=612x612&w=0&k=20&c=yDJ4ITX1cHMh25Lt1vI1zBn2cAKKAlByHBvPJ8gEiIg=',
              'timestamp': '1 hour ago',
              'isImage': true,
            },
          ],
        ),
      );
  }

}