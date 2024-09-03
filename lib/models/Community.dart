import 'User.dart';
import '../backend/Model/Post.dart';
class Community{
  String name;
  String pictureUrl;
  List<User>members;
  List<Post>posts;
  int memberCounter;
  String goal;
  Community({
    required this.name,
    required this.pictureUrl,
    required this.members,
    required this.posts,
    required this.memberCounter,
    required this.goal, required String id, required DateTime createdAt
    });
}