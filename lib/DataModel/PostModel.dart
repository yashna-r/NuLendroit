/*
* author YR
* NuLendroit application
*
* Data Model for Post
*
*/

class Post{

  final String postId;
  final String description;
  final String date;
  final String time;
  final String postImgURL;
  final String createdBy;
  final String userId;

  Post({
    this.postId,
    this.description,
    this.date,
    this.time,
    this.postImgURL,
    this.createdBy,
    this.userId,
  });


}