import 'User.dart';
import 'post.dart';
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
    required this.goal
    });
}