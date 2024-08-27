import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Community.dart';
import '../widgets/community/community_card_list.dart';
class ForYouPage extends StatelessWidget {
  List<Community> communities;
  ForYouPage({super.key,required this.communities});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[CommunityCardList(communities: communities,) 
      ]

    );
  }
}