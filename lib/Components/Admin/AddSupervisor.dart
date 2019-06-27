import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../Models/AppModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddSupervisor extends StatefulWidget {
  @override
  _AddSupervisorState createState() => _AddSupervisorState();
}

class _AddSupervisorState extends State<AddSupervisor> {

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupPhoneController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signupkey = new GlobalKey<FormState>();

  final FocusNode signUpNameFocusNode = FocusNode();
  final FocusNode signUpEmailFocusNode = FocusNode();
  final FocusNode signUpPhoneFocusNode = FocusNode();
  final FocusNode signUpPasswordFocusNode = FocusNode();
  final FocusNode signUpPasswordConfirmFocusNode = FocusNode();

  addSupervisor () {
    GraphQLProvider.of(context).value.mutate(MutationOptions(document: """
      mutation createSupervisor (\$name: String!, \$email: String!, \$phoneNumber: String!, \$password: String!) {
        createSupervisor (supervisorInput: { name: \$name, email: \$email, phoneNumber: \$phoneNumber, password: \$password }) {
          typeUser
        }
      }
    """, variables: <String, dynamic> {
      "name": signupNameController.text,
      "email": signupEmailController.text,
      "phoneNumber": signupPhoneController.text,
      "password": signupPasswordController.text
    })).then((res) {
      if(res.data != null ) {
        showInSnackBar('Added Supervisor');
      }
      else {
        showInSnackBar('Email Already Exosts');
      }
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
                            focusNode: signUpNameFocusNode,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            controller: signupNameController,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              ),
                              hintText: "Name",
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
                          child: TextFormField(
                            focusNode: signUpEmailFocusNode,
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                              hintText: "Email Address",
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
                          child: TextFormField(
                            focusNode: signUpPhoneFocusNode,
                            controller: signupPhoneController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                              hintText: "Phone Number",
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
                            focusNode: signUpPasswordFocusNode,
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
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
                            focusNode: signUpPasswordConfirmFocusNode,
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText: "Confirmation",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
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
                    if(signupPasswordController.text == null || signupPasswordController.text == '' || signupConfirmPasswordController.text == null || signupConfirmPasswordController.text == '' || signupNameController.text == null || signupNameController.text == '' || signupEmailController.text == null || signupEmailController.text == '') {
                      showInSnackBar('Enter All Details');
                      return;
                    }
                    if(signupPasswordController.text != signupConfirmPasswordController.text) {
                      showInSnackBar('Passwords Do Not Match');
                      return;
                    }
                    addSupervisor();
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(
          child: Text("DMRC Attendance Manager"),
        ),
      ),
      body: Container(
        child: Center(
          child: _buildSignUp(context),
        ),
      )

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

//Query(options: QueryOptions(document: """
//                query courseSessions ( \$courseId: String! ){
//                  courseSessions ( courseId: \$courseId ) {
//                    _id
//                    name
//                    attendance
//                    sessionToken
//                    dateCreated
//                  }
//                }
//                """, variables: <String, dynamic> {
//"courseId": model.courseId
//}, pollInterval: 100, fetchPolicy: FetchPolicy.noCache), builder: (QueryResult result, {VoidCallback refetch}) {
//if(result.errors != null) {
//return Center(
//child: Text(result.errors.toString()),
//);
//}
//if(result.loading) {
//return Center(
//child: Text("Loading"),
//);
//}
//List sessions = result.data["courseSessions"];
//print(sessions);
//return ListView.builder(
//itemCount: result.data["courseSessions"].length,
//itemBuilder: (context, index) {
//return Padding(
//padding: EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
//child: Material(
//elevation: 14.0,
//borderRadius: BorderRadius.circular(12.0),
//shadowColor: Color(0x802196F3),
//color: Colors.white,
//child: InkWell(
//// Do onTap() if it isn't null, otherwise do print()
//onTap: () => { goToSession(model, sessions[index]["_id"], context) },
//child: Padding (
//padding: const EdgeInsets.all(24.0),
//child: Row (
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget> [
//Column (
//mainAxisAlignment: MainAxisAlignment.center,
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget> [
//Text('${sessions[index]["name"]}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)),
//Text('Attendance: ${sessions[index]["attendance"]}', style: TextStyle(color: Colors.redAccent)),
//SafeArea(child: Text('Date Created: ${sessions[index]["dateCreated"]}'.split('GMT')[0], style: TextStyle(color: Colors.redAccent))),
//Text('Token: ${sessions[index]["sessionToken"]}', style: TextStyle(color: Colors.redAccent)),
//],
//),
//Material (
//
