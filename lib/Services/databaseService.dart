import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';

class DatabaseService {

  final CollectionReference eventCollection = Firestore.instance.collection('events');
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference postCollection = Firestore.instance.collection('posts');
  final CollectionReference favouriteCollection = Firestore.instance.collection('favourites');

  final String userId, eventId, postId, favouriteId;
  DatabaseService({this.userId, this.eventId, this.postId, this.favouriteId});

  /*-------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------User Collection--------------------------------------------*/
  /*-------------------------------------------------------------------------------------------------------*/

  // Updata user data
  Future updateUserData(String uid, String username, String role, List preferences,
      String imgURL) async {
    return await userCollection.document(userId).setData({
      'userId': userId,
      'username': username,
      'role': role,
      'preferences': preferences,
      'userImage': imgURL,
    });
  }

  // Get user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: userId,
      username: snapshot.data['username'] ?? "New user",
      role: snapshot.data['role'] ?? 'General',
      preferences: snapshot.data['preferences'],
      userImgURL: snapshot.data['userImage'],
    );
  }

  // Get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(userId).snapshots().map(
        _userDataFromSnapshot);
  }

  /*--------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------Event Collection--------------------------------------------*/
  /*--------------------------------------------------------------------------------------------------------*/

  // Get event data from snapshot
  EventData _eventDataFromSnapshot(DocumentSnapshot snapshot) {
    return EventData(
      eventId: eventId,
      category: snapshot.data['category'],
      eventTitle: snapshot.data['eventTitle'],
      description: snapshot.data['description'],
      date: snapshot.data['date'],
      startTime: snapshot.data['startTime'],
      endTime: snapshot.data['endTime'],
      organiser: snapshot.data['organiser'],
      location: snapshot.data['location'],
      latitude: snapshot.data['latitude'],
      longitude: snapshot.data['longitude'],
      imgURL: snapshot.data['imgURL'],
      dateCreated: snapshot.data['dateCreated'],
      createdBy: snapshot.data['createdBy'],

    );
  }

  // Get event list from snapshot
  List<EventData> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return EventData(

        eventId: doc.data['eventId'],
        category: doc.data['category'] ?? '',
        eventTitle: doc.data['eventTitle'] ?? '',
        description: doc.data['description'] ?? '',
        date: doc.data['date'] ?? '',
        startTime: doc.data['startTime'] ?? '',
        endTime: doc.data['endTime'] ?? '',
        organiser: doc.data['organiser'] ?? '',
        location: doc.data['location'] ?? '',
        latitude: doc.data['latitude'] ?? '',
        longitude: doc.data['longitude'] ?? '',
        imgURL: doc.data['imgURL'] ?? '',
        dateCreated: doc.data['dateCreated'] ?? '',
        createdBy: doc.data['createdBy'],

      );
    }).toList();
  }

  Stream<EventData> get eventData {
    return eventCollection.document(eventId).snapshots().map(
        _eventDataFromSnapshot);
  }

  // get events stream
  Stream<List<EventData>> get events {
    return eventCollection.snapshots().map(_eventListFromSnapshot);
  }


  /*-------------------------------------------------------------------------------------------------------*/
  /*--------------------------------------------Post Collection--------------------------------------------*/
  /*-------------------------------------------------------------------------------------------------------*/

  // Get event data from snapshot
  Post _postDataFromSnapshot(DocumentSnapshot snapshot) {
    return Post(
      postId: postId,
      description: snapshot.data['description'],
      date: snapshot.data['date'],
      time: snapshot.data['time'],
      postImgURL: snapshot.data['image'],
      createdBy: snapshot.data['createdBy'],
      userId: snapshot.data['userId'],

    );
  }

  // Get event list from snapshot
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Post(
        postId: doc.data['postId'],
        description: doc.data['description'],
        date: doc.data['date'],
        time: doc.data['time'],
        postImgURL: doc.data['image'],
        createdBy: doc.data['createdBy'],
        userId: doc.data['userId'],

      );
    }).toList();
  }

  Stream<Post> get postData {
    return postCollection.document(postId).snapshots().map(
        _postDataFromSnapshot);
  }

  // get events stream
  Stream<List<Post>> get posts {
    return postCollection.orderBy(('date'), descending: true).orderBy('time', descending: true).snapshots().map(_postListFromSnapshot);
  }


/*--------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------Favourite Collection--------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------*/


// Get event data from snapshot
  FavouriteData _favouriteDataFromSnapshot(DocumentSnapshot snapshot) {
    return FavouriteData(
      favouriteId: snapshot.data['favouriteId'],
      eventId: snapshot.data['eventId'],
      userId: snapshot.data['userId'],
      likeState: snapshot.data['likeState'],

    );
  }

// Get event list from snapshot
  List<FavouriteData> _favouriteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return FavouriteData(
        favouriteId: doc.data['favouriteId'],
        eventId: doc.data['eventId'],
        userId: doc.data['userId'],
        likeState: doc.data['likeState'],

      );
    }).toList();
  }

  Stream<FavouriteData> get favouriteData {
    return favouriteCollection.document(favouriteId).snapshots().map( _favouriteDataFromSnapshot);
  }

// get events stream
  Stream<List<FavouriteData>> get favourites {
    return favouriteCollection.snapshots().map(_favouriteListFromSnapshot);
  }

}