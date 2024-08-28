import 'package:flutter/material.dart';

class KarmaDialog extends StatefulWidget {
  const KarmaDialog({super.key});

  @override
  _KarmaDialogState createState() => _KarmaDialogState();
}

class _KarmaDialogState extends State<KarmaDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: 500, // Adjust height as needed
        width: 300, // Adjust width as needed
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: List.generate(12, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _getPageContent(index),
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(12, (index) {
                return InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _getPageContent(int index) {
    switch (index) {
      case 0:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to our app!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'To make your experience more engaging, we’ve introduced a point system that rewards you for your participation and contributions.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Here’s how you can earn points:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 1:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '1. Post Content',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Create a Post: Share your thoughts, ideas, or questions. Each post you make earns you points.\n\nUpload Images: Add value to your posts by including images. This earns you additional points.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 2:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '2. Engage with Others',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Comment on Posts: Engage with the community by commenting on other users\' posts. You’ll earn points for each comment.\n\nReact to Posts and Comments: Show your support or express your emotions by reacting to posts and comments. Every reaction you give or receive will earn you points.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 3:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '3. Interact with Events',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Join University and Club Events: Participate in events hosted by the university or clubs. You’ll earn points just by attending and sharing your experience.\n\nShare Event Photos: Upload photos from the events you attend to earn even more points.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 4:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '4. Help Others',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Answer Questions: Share your knowledge by answering questions about courses, books, or professors. Helpful answers that get upvoted earn you extra points.\n\nAssist with Lost & Found: Help your fellow students by posting about found items or assisting in finding lost items. Points are rewarded for contributing to the Lost & Found section.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 5:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '5. Participate in Communities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Join and Contribute to Communities: Be an active member of any community you join. Posting content or engaging in discussions within these communities earns you points.\n\nCreate a Community: Start a new community around a shared interest. You’ll receive points for bringing people together.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 6:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '6. Provide Feedback',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Rate Professors and Services: Help improve the community by leaving ratings and reviews for professors, campus services, and shops. Points are awarded for each review.\n\nSubmit App Feedback: Share your suggestions or report bugs to help us improve the app. Your contributions here are also rewarded with points.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 7:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '7. Maintain a Positive Presence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Earn Likes: Gain points whenever someone likes your posts or comments. The more engagement you generate, the more points you earn.\n\nBe Active: Consistent daily activity like posting, commenting, and reacting will earn you bonus points.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 8:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '8. Invite Friends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Send Invites: Invite your friends to join the app. Points are awarded for each friend who signs up using your referral.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 9:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '9. Earn Points from Highlights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Share Achievements: Post about your achievements, such as awards or project milestones, and earn points for sharing your success with others.\n\nEngage with Highlighted Content: Viewing and interacting with other users\' highlighted achievements can also earn you points.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 10:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '10. Stay Consistent',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Check for Daily Tasks: Look for daily or weekly tasks to complete for additional points.\n\nParticipate Regularly: Regular participation and engagement keep you active in the app and help you earn more points over time.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 11:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start participating and watch your points grow!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Remember, your points are a reflection of your involvement in our community, so get active and enjoy the rewards!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
