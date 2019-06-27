import 'package:flutter/material.dart';
import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/AppModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Supervisor extends StatefulWidget {
  @override
  _SupervisorState createState() => _SupervisorState();
}

class _SupervisorState extends State<Supervisor> {

  TextEditingController labourIdController = TextEditingController();
  TextEditingController labourNameController = TextEditingController();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  String date = DateTime.now().toString().split(' ')[0];
  String labourImage;
  String gpsLoc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signupkey = new GlobalKey<FormState>();

  final FocusNode labourIdFocusNode = FocusNode();
  final FocusNode labourNameFocusNode = FocusNode();


  markAttendance () {
    GraphQLProvider.of(context).value.mutate(MutationOptions(document: """
    """, variables: <String, dynamic> {
      "labourName": labourNameController.text,
      "labourId": labourIdController.text,
      "labourImage": labourImage,
      "gpsLoc": gpsLoc,
      "date": date
    }, fetchPolicy: FetchPolicy.noCache)).then((res) {
      if(res.errors != null) {
        print(res.errors);
      }
      else {
        print(res.data);
      }
    });
  }

  getGPSLoc () async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List <Placemark> placemarks = await new Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      gpsLoc = placemarks[0].toString();
    });
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
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
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
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
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
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
                                fontSize: 16.0),
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
                          child: RaisedButton(
                            onPressed: () {

                            }
                          )
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
//                        Padding(
//                          padding: EdgeInsets.only(
//                              top: 0.0, bottom: 20.0, left: 25.0, right: 25.0
//                          ),
//                          child: Row(
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text('College: '),
//                              DropdownButton(
//                                  value: _college,
//                                  items: collegeDropList,
//                                  hint: Text('Select'),
//                                  onChanged: (value) => {selectCollegeDropDown(value)}
//                              )
//                            ],
//                          ),
//                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 415.0),
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
                      'Signup',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "WorkSansBold"
                      ),
                    ),
                  ),
                  onPressed: () {
//                    if(signupPasswordController.text == null || signupPasswordController.text == '' || signupConfirmPasswordController.text == null || signupConfirmPasswordController.text == '' || signupNameController.text == null || signupNameController.text == '' || signupEmailController.text == null || signupEmailController.text == '') {
//                      showInSnackBar('Enter All Details');
//                      return;
//                    }
//                    if(signupPasswordController.text != signupConfirmPasswordController.text) {
//                      showInSnackBar('Passwords Do Not Match');
//                      return;
//                    }
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
      body: Container(
        child: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => Stack(
            children: <Widget>[
              Container(
                child: _buildSignUp(context),
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
              )
            ],
          )
        )
      ),
    );
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