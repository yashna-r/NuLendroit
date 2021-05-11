import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ExplorePage/eventInfo.dart';
import 'package:nulendroit/Shared/dialogBox.dart';
import 'package:provider/provider.dart';
import '../Shared/mapLocation.dart';

const kGoogleApiKey = "-- Insert API key here --";
// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class EditEventInfo extends StatefulWidget {

  final EventData event;
  EditEventInfo({this.event});

  @override
  _EditEventInfoState createState() => _EditEventInfoState();
}

class _EditEventInfoState extends State<EditEventInfo> {

  EventData event;
  DialogBox dialogBox = new DialogBox();
  String eventID;
  File sampleImage;
  final eventFormKey = new GlobalKey<FormState>();
  final dateFormat = DateFormat("EEEE, dd MMM yyyy");
  final timeFormat = DateFormat("h:mm a");

  var date ,sTime, eTime;
  String currentUser;

  final CollectionReference eventCollection = Firestore.instance.collection(
      'events');
  final StorageReference eventStorage = FirebaseStorage.instance.ref().child(
      "Event images");
  String category, eventTitle, description, eventDate, startTime, endTime, organiser,
      location, imgURL, latitude, longitude;


  @override
  void initState() {
    super.initState();
    category = '';
  }

  @override
  Widget build(BuildContext context) {

    event = widget.event;
    eventID = event.eventId;

    User user = Provider.of<User>(context);
    currentUser = user.uid;

    final bottom = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    return Scaffold(

      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: new Text('Update Event Info'),
      ),

      body: location == null?

      Container(
        margin: EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            SizedBox(
                height: 50.0,
                child: Icon(Icons.location_on,
                  size: 50.0,
                  color: Colors.black,
                )
            ),

            SizedBox(height: 40.0,),

            Text(
              'Please turn on device location. Then, tap on \'Get current location\'',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                height: 1.5,
              ),
            ),

            SizedBox(height: 40.0,),

            /*------------------Current location------------------*/
            SizedBox(
              height: 60.0,
              width: 200.0,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12.0),
                  color: Colors.teal[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius
                          .circular(30.0)
                  ),

                  onPressed: _getLocation,
                  child: Text("Get current location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  )
              ),
            ),

            SizedBox(height: 20.0,),

            /*------------------Event location button------------------*/
            SizedBox(
              height: 60.0,
              width: 200.0,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12.0),
                  color: Colors.teal[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius
                          .circular(30.0)
                  ),

                  onPressed: _getEventLocation,
                  child: Text("Choose event location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  )
              ),
            ),

          ],
        ),
      )


          :SingleChildScrollView(
          reverse: true,
          child: Padding(

              padding: EdgeInsets.only(
                  bottom: bottom, left: 16.0, right: 16.0),

              child: Form(
                key: eventFormKey,
                child: new Column(

                    children: <Widget>[

                      SizedBox(height: 15.0),

                      /*------------------Category------------------*/

                      DropDownFormField(
                        titleText: 'Category',
                        hintText: 'Please choose one',

                        value: category,
                        onChanged: (value) {
                          setState(() {
                            category = value;
                          });
                          return category;
                        },
                        onSaved: (value) {
                          setState(() {
                            category = value;
                          });
                          return category;
                        },
                        dataSource: [
                          {
                            "display": "Adventure",
                            "value": "Adventure",
                          },
                          {
                            "display": "Art",
                            "value": "Art",
                          },
                          {
                            "display": "Business",
                            "value": "Business",
                          },
                          {
                            "display": "Education",
                            "value": "Education",
                          },
                          {
                            "display": "Entertainment",
                            "value": "Entertainment",
                          },
                          {
                            "display": "Exhibitions",
                            "value": "Exhibitions",
                          },
                          {
                            "display": "Food & Drinks",
                            "value": "Food & Drinks",
                          },
                          {
                            "display": "Health",
                            "value": "Health",
                          },
                          {
                            "display": "Music & Dance",
                            "value": "Music & Dance",
                          },
                          {
                            "display": "Non-profit",
                            "value": "Non-profit",
                          },
                          {
                            "display": "Sports & Fitness",
                            "value": "Sports & Fitness",
                          },

                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),

                      SizedBox(height: 15.0),

                      /*------------------Event Title------------------*/
                      new TextFormField(
                          initialValue: event.eventTitle,
                          onSaved: (value) {
                            eventTitle = value;
                            return eventTitle;
                          },
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Title',
                            border: new OutlineInputBorder(),
                          )
                      ),

                      SizedBox(height: 15.0),

                      /*------------------Description------------------*/
                      new TextFormField(
                          initialValue: event.description,
                          maxLines: null,
                          onSaved: (value) {
                            description = value;
                            return description;
                          },
                          decoration: InputDecoration(
                            hintText: 'Description of event',
                            labelText: 'Description',
                            border: new OutlineInputBorder(),
                          )
                      ),

                      SizedBox(height: 15.0),

                      /*------------------Date and Time------------------*/

                      //BasicDateField(),
                      dateField(),
                      SizedBox(height: 15.0),
                      startTimeField(),
                      SizedBox(height: 15.0),
                      endTimeField(),
                      SizedBox(height: 15.0),

                      /*------------------Organiser------------------*/
                      new TextFormField(
                          initialValue: event.organiser,
                          onSaved: (value) {
                            organiser = value;
                            return organiser;
                          },
                          decoration: InputDecoration(
                            hintText: 'Organiser',
                            labelText: 'Organiser',
                            border: new OutlineInputBorder(),
                          )
                      ),

                      SizedBox(height: 15.0),

                      /*------------------Location------------------*/
                      Row(
                          children: <Widget>[

                            /*------------------Location field------------------*/
                            Expanded(
                                child: new TextFormField(
                                  initialValue: event.location,
                                  onSaved: (value) {
                                    location = value;
                                    return location;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Location',
                                    border: new OutlineInputBorder(),
                                  ),
                                )
                            ),

                            SizedBox(width: 5.0),

                            /*------------------Map button------------------*/
                            SizedBox(
                                width: 60,
                                height: 40,
                                child: IconButton(
                                  color: Colors.purple,
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => MapLocation(location: location, latitude: latitude, longitude: longitude,)));
                                  },
                                  icon: Icon(Icons.map, size: 30),
                                )
                            ),
                          ]
                      ),

                      SizedBox(height: 15.0),

                      /*------------------Image------------------*/

                      SizedBox(
                          height: 250.0,
                          width: double.infinity,

                          child: Container(
                            child: sampleImage == null
                                ? imageButton()
                                : imageUpload(),
                          )
                      ),

                      /*------------------Buttons------------------*/
                      SizedBox(
                        height: 120.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[

                              /*------------------Cancel Button------------------*/
                              SizedBox(
                                height: 50.0,
                                width: 100.0,
                                child: RaisedButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 12.0),
                                    color: Colors.teal[400],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius
                                            .circular(25.0)
                                    ),

                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    )
                                ),
                              ),

                              /*------------------Create Button------------------*/
                              SizedBox(
                                height: 50.0,
                                width: 150.0,
                                child: RaisedButton(
                                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                                    color: Colors.teal[400],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius
                                            .circular(25.0)
                                    ),
                                    onPressed: updateEvent,
                                    child: Text("Update",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    )
                                ),
                              )

                            ]
                        ),
                      )

                    ]
                ),
              )
          )

      )


    );
  }

/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------DESIGN----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/

  /*------------------Date Picker------------------*/
  Widget dateField() {

//    var date = DateTime.parse(event.date);
    return Column(
        children: <Widget>[
          DateTimeField(
//              initialValue: DateFormat("EEEE, dd MMM yyyy").format(date)),
              format: dateFormat,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100)
                );
              },
              onSaved: (value) {
                date = value;
                return date;
              },
              decoration: InputDecoration(
                //hintText: 'dd/mm/yyyy',
                labelText: 'Date',
                border: new OutlineInputBorder(),
              )
          ),
        ]
    );
  }

  /*------------------Time Picker for start time------------------*/
  Widget startTimeField() {
    return Column(
        children: <Widget>[
          DateTimeField(
//              initialValue: DateTime.parse(event.startTime),
              format: timeFormat,
              onShowPicker: (context, currentValue) async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                      currentValue ?? DateTime.now()
                  ),
                );
                return DateTimeField.convert(time);
              },
              onSaved: (value) {
                sTime = value;
                return sTime;
              },
              decoration: InputDecoration(
                //hintText: 'hh:mm',
                labelText: 'Start time',
                border: new OutlineInputBorder(),
              )
          ),
        ]
    );
  }

  /*------------------Time Picker for end time------------------*/
  Widget endTimeField() {
    return Column(
        children: <Widget>[
          DateTimeField(
//              initialValue: DateTime.parse(event.endTime),
              format: timeFormat,
              onShowPicker: (context, currentValue) async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.convert(time);
              },
              onSaved: (value) {
                eTime = value;
                return endTime;
              },
              decoration: InputDecoration(
                hintText: 'hh:mm',
                labelText: 'End time',
                border: new OutlineInputBorder(),
              )
          ),
        ]
    );
  }

  /*------------------Image uploaded------------------*/
  Widget imageUpload() {
    return Container(
      child:
      Image.file(sampleImage, height: 100.0, width: 600.0,),

    );
  }

  /*------------------Image button------------------*/
  Widget imageButton() {
    return SizedBox(
      height: 50.0,
      width: double.infinity,
      child: RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          color: Colors.purple[100],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)
          ),

          onPressed: getImage,
          child: Icon(Icons.add_a_photo,
            color: Colors.white,
            size: 50.0,
          )
      ),
    );
  }


/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------METHODS----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/
  Future getImage() async {

    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = eventFormKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    else
      return false;
  }

  Future<void> updateEvent() async {


    try {
      if (validateAndSave()) {
        var timeKey = new DateTime.now();
//        var formatDate = new DateFormat('EEEE, MMM d, yyyy');

        eventDate = dateFormat.format(date);
        startTime = timeFormat.format(sTime);
        endTime = timeFormat.format(eTime);

        //String dateCreated = formatDate.format(timeKey);
        if (sampleImage != null) {
          final StorageUploadTask uploadTask = eventStorage.child(
              timeKey.toString() + ".jpg").putFile(sampleImage);

          var url = await (await uploadTask.onComplete).ref.getDownloadURL();
          imgURL = url.toString();
        } else {
          imgURL = null;
        }

        print("Image URL = " + imgURL);

        eventCollection.document(eventID).setData({
          'eventId': eventID,
          'category': category ?? '',
          'eventTitle': eventTitle ?? '',
          'description': description ?? '',
          'date': eventDate ?? '',
          'startTime': startTime ?? '',
          'endTime': endTime ?? '',
          'organiser': organiser ?? '',
          'location': location ?? '',
          'latitude': latitude ?? '',
          'longitude': longitude ?? '',
          'imgURL': imgURL ?? '',
          'dateCreated': widget.event.dateCreated,
          'createdBy': widget.event.createdBy,
        });

        moveToMainPage();

        dialogBox.information(context, 'Successful',
            'Your event has been succesfully edited.');
      }
    }catch (e){
      print(e.toString());
      dialogBox.information(context, 'Error', 'Please fill in all details');
    }
  }

  void moveToMainPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventInfoPage(event: widget.event,)));
  }

  //Get location of user
  void _getLocation() async {

    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print('got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');
    var currentAddress = await _getAddress(currentLocation);
    print('Current Address: $currentAddress');
    //return location.toString();

    setState(() {
      location = currentAddress;
    });

    print('Current location GPS: $location');

  }

  Future<String> _getAddress(Position pos) async {

    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  //Get event location
  Future<void> _getEventLocation() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
//      onError: onError,
      mode: Mode.fullscreen,
      language: "en",
      components: [Component(Component.country, "mu")],
    );

    displayPrediction(p/*, homeScaffoldKey.currentState*/);
  }

  Future<Null> displayPrediction(Prediction p/*, ScaffoldState scaffold*/) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
      setState(() {
        location = p.description;
        latitude = lat.toString();
        longitude = lng.toString();
      });
      print("${p.description} - $lat/$lng");
    }
  }
}
