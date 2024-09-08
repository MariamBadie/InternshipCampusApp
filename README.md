# Internship project
You will be building an application to be used by GUC students and staff. The app serves many useful purposes. You should target the virality of the app among the students so your UI/UX should take this into consideration.

## A. Sign up:
1. OnlyGUCemailsareallowed(@student.guc.edu.eg).Email verification is required via firebase. User has to create a username (a handle)
2. Create 1 admin account of your choice.
   
## B. App functionalities:
1. Confessions: you can post as yourself or anonymous.Other users can comment. No image upload is allowed.
a. Bonus: tag people using their usernames and they shall receive a notification.
2. Academic related questions: questions about courses, books, professors,ratings... Image upload allowed. Rating can be done in a separate part.
3. Post Managment Features: You should have the ability to delete any posts that are visible in the "My Profile" section. Additionally, you should be able to edit the content of your post as well as modify the privacy settings.
4. Lost and found: for lost and found items. Images allowed.
5. Offices and outlets: Users can search for professors, TAs, officese, finance, food outlets and so on. The app should provide their locations and possible directions or distance using your current location.
6. Important phone numbers(clinic,ambulance,...). Also search should be supported and direct 1-click call from within the app.
7. News, events and clubs. Posts can contain images. This tab can only be edited (adding content) by users who are approved by the admin. Users should be able to ask for approval from within the app.
8. Notes with Attachments: Users can create notes with various types of attachments (images, documents). Attachments can be added from the file system, photo gallery, or camera. The app supports preview, full-size viewing, and downloading of attachments.
9. Reporting Offensive Content: Users should be able to report any Post,Comment or Contnet that they find offensive and they should be also able to submit the complaint with the suitable reason
10. Points Reward System: When contributing to the community by assisting others, you should earn points, referred to as "Karma," which will be displayed in the "My Profile" section.
### Notes:
• Not all the pages should be visible on the home page (in tabs). You might embed some in other pages, or hide them in app bar icons.

• Push notifications are required. You can choose when to push a notification (new posts, new announcement, tag and so on).

• The admin part could be done either via the app (by a special login of your choice) or via a web app.

## C. Usability dataset building:
You need to keep track of where the user is clicking (which buttons, tabs,) and what kind of activity is he/she doing in the app.
For example, which feature is he/she using now? And so on. In a certain page, is he/she scrolling and how much time did he/she spend before navigating back.
In brief, the elements of behavior that needs to be captured are: clicks, scrolls, time spent in each widget. You can add any other behavior you deem appropriate.
All this info needs to be stored in the database, per user, every time he/she visits the app.
