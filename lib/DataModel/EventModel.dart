/*
* author YR
* NuLendroit application
*
* Data Model for Event
*
*/

class Event{

  final String eventId;

  Event({this.eventId});

}

class EventData {
  String eventId;
  String category;
  String eventTitle;
  String description;
  String date;
  String startTime;
  String endTime;
  String organiser;
  String location;
  String latitude;
  String longitude;
  String imgURL;
  String dateCreated;
  String createdBy;


  EventData({
    this.eventId,
    this.category,
    this.eventTitle,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.organiser,
    this.location,
    this.longitude,
    this.latitude,
    this.imgURL,
    this.dateCreated,
    this.createdBy,
  });
}





