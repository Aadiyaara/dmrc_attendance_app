import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/AppModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Supervisor extends StatefulWidget {
  @override
  _SupervisorState createState() => _SupervisorState();
}

class _SupervisorState extends State<Supervisor> {

  TextEditingController labourIdController = TextEditingController();
  TextEditingController labourNameController = TextEditingController();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  List <Map<String, dynamic>> deployBuffer = [];

  String date = DateTime.now().toString().split(' ')[0];
  String labourImage;
  String gpsLoc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signupkey = new GlobalKey<FormState>();

  final FocusNode labourIdFocusNode = FocusNode();
  final FocusNode labourNameFocusNode = FocusNode();

  markAttendance () {
    Map<String, dynamic> uploadData = {};
    uploadData['image'] = labourImage;
    uploadData['name'] = labourNameController.text;
    uploadData['id'] = labourIdController.text;
    uploadData['gpsLoc'] = gpsLoc;
    uploadData['date'] = date;
    uploadData['status'] = 'inProgress';
    setState(() {
      deployBuffer.add(uploadData);
    });
    GraphQLProvider.of(context).value.mutate(MutationOptions(document: """
      mutation markAttendance (\$labourName: String!, \$labourImage: String!, \$labourId: String!, \$gpsLoc: String!, \$date: String!) {
        markAttendance (attendanceInput: {labourName: \$labourName, labourId: \$labourId, labourImage: \$labourImage, gpsLoc: \$gpsLoc, date: \$date})
      }
    """, variables: <String, dynamic> {
      "labourName": labourNameController.text,
      "labourId": labourIdController.text,
      "labourImage": labourImage,
      "gpsLoc": gpsLoc,
      "date": date
    }, fetchPolicy: FetchPolicy.noCache)).then((res) {
      if(res.errors != null) {
        print('mark Attendance data');
        print(res.errors);
        showInSnackBar('Please try after sometime');
        setState(() {
          deployBuffer[deployBuffer.length - 1]['status'] = 'retry';
        });
      }
      else {
        print('mark Attendance data');
        print(res.data);
        showInSnackBar(res.data['markAttendance']);
        setState(() {
          deployBuffer[deployBuffer.length - 1]['status'] = 'isComplete';
        });
      }
    });
  }

  markAttendanceRetry (lIm, lId, lNa, lGps, lDate, index) {
    Map<String, dynamic> uploadDataRetrial = {};

    uploadDataRetrial['image'] = lIm;
    uploadDataRetrial['name'] = lNa;
    uploadDataRetrial['id'] = lId;
    uploadDataRetrial['gpsLoc'] = lGps;
    uploadDataRetrial['date'] = lDate;
    uploadDataRetrial['status'] = 'inProgress';

    setState(() {
      deployBuffer[index] = uploadDataRetrial;
    });

    GraphQLProvider.of(context).value.mutate(MutationOptions(document: """
      mutation markAttendance (\$labourName: String!, \$labourImage: String!, \$labourId: String!, \$gpsLoc: String!, \$date: String!) {
        markAttendance (attendanceInput: {labourName: \$labourName, labourId: \$labourId, labourImage: \$labourImage, gpsLoc: \$gpsLoc, date: \$date})
      }
    """, variables: <String, dynamic> {
      "labourName": lNa,
      "labourId": lId,
      "labourImage": lIm,
      "gpsLoc": lGps,
      "date": lDate
    }, fetchPolicy: FetchPolicy.noCache)).then((res) {
      if(res.errors != null) {
        print('mark Attendance data');
        print(res.errors);
        showInSnackBar('Please try after sometime');
        setState(() {
          deployBuffer[index]['status'] = 'retry';
        });
      }
      else {
        print('mark Attendance data');
        print(res.data);
        showInSnackBar(res.data['markAttendance']);
        setState(() {
          deployBuffer[index]['status'] = 'isComplete';
        });
      }
    });
  }

  getGPSLoc () async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List <Placemark> placemarks = await new Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      gpsLoc = placemarks[0].name + ' ' + placemarks[0].subLocality + ' ' + placemarks[0].locality + ' ' + placemarks[0].administrativeArea + ' ' + placemarks[0].isoCountryCode;
    });
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 150.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 300.0,
                      child: Form(
                        key: _signupkey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextFormField(
                                focusNode: labourNameFocusNode,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                controller: labourNameController,
                                style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.user,
                                    color: Colors.black,
                                  ),
                                  hintText: "Labour Name",
                                  hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextFormField(
                                focusNode: labourIdFocusNode,
                                controller: labourIdController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                  ),
                                  hintText: "Labour ID",
                                  hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: ImageInput(),
                            ),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 275.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.blue
                    ],
                    begin: const FractionalOffset(0.2, 0.2),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                  ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.blueAccent,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0
                    ),
                    child: Text(
                      'Mark Attendance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "WorkSansBold"
                      ),
                    ),
                  ),
                  onPressed: () {
                    if(labourIdController.text == null || labourIdController.text == '' || labourNameController.text == null || labourNameController.text == '' || labourImage == null) {
                      showInSnackBar('Enter All Details');
                      return;
                    }
                    markAttendance();
                  }
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget ImageInput () {
    if(labourImage == null) {
      return RaisedButton(
        onPressed: () {
          takeProof();
        },
        child: Text('Attach Image'),
      );
    }
    else return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            takeProof();
          },
          child: Text('Retake Image'),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Image.memory(base64Decode(labourImage)),
        )
      ],
    );
  }

  Widget StatusUpdator (status, lNa, lId, lIm, lGps, lDate, index) {
    if (status == 'inProgress') {
      return Center(
        child: Text('UPLOADING'),
      );
    }
    else if (status == 'isComplete') {
      return Center(
        child: Text('Sent and Marked'),
      );
    }
    else {
      return MaterialButton(
        child: Text('Retry'),
        onPressed: () {markAttendanceRetry(lIm, lId, lNa, lGps, lDate, index);},
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: (600)), () {
      getGPSLoc();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Container(
        child: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => Stack(
            children: <Widget>[
              Center(
                child: _buildSignUp(context),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.75),
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('See Status Here', style: TextStyle(color: Colors.white),),
                    Expanded(
                      child: ListView.builder(
                          itemCount: deployBuffer.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 1.0, left: 12.0, right: 12.0),
                              child: Material(
                                  elevation: 14.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                  shadowColor: Color(0x802196F3),
                                  color: Colors.white,
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child:
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Name ',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      Text(
                                                        '${deployBuffer[index]["name"]}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Labour ID ',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      Text(
                                                        '${deployBuffer[index]["id"]}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'GPS ',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${deployBuffer[index]["gpsLoc"]}',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: StatusUpdator(deployBuffer[index]['status'], deployBuffer[index]['name'], deployBuffer[index]['id'], deployBuffer[index]['image'], deployBuffer[index]['gpsLoc'], deployBuffer[index]['date'], index),
                                            )
                                          ]
                                        ),
                                      )
                                  )
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {
                          model.setToken(null);
                          model.setId(null);
                          SharedPreferences preferences = await SharedPreferences
                              .getInstance();
                          await preferences.setString('token', null);
                          await preferences.setString('userId', null);
                          await preferences.setString('userType', null);
                          Navigator.pushReplacementNamed(context, '/auth');
                        },
                        child: Text('Logout'),
                      ),
                    ]
                  )
                ]
              ),
            ],
          )
        )
      ),
    );
  }

  Future takeProof() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
    String sendString = base64Encode(_image.readAsBytesSync());
    setState(() {
      labourImage = sendString;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"
        ),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
    ));
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

}