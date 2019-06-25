import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/bubble_indication_painter.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/AppModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginkey = new GlobalKey<FormState>();
  bool invalidDialogAllowed = true;

  bool isLoading = false;

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  String _mode = "Supervisor";

  bool loggedIn = false;

  bool _obscureTextLogin = true;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  ScrollController singleChildScrollViewController = ScrollController();

  PageController flowController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    flowController = PageController();
  }

  Widget Loader () {
    if(isLoading) {
      return Container(
        color: Color(0x22000000),
        child: SpinKitRing(
          color: Colors.white,
        ),
      );
    }
    else return Container();
  }

  Widget TypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/img/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 250.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(1.0), BlendMode.dstATop),
                    image: AssetImage('assets/img/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed:(){ _onSupervisorButtonPress(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Teacher",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed:(){ _onAdminButtonPress(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Student",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: singleChildScrollViewController,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.blueAccent
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                  ),
                ),
                child: PageView(
                  controller: flowController,
                  children: <Widget>[
                    TypeSelector(),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 175.0),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildSignIn(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Loader()
          ],
        )
      ),
    );
  }


  @override
  void dispose() {
    flowController?.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
    ));
  }

  Future setSupervisor(String token, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
    preferences.setString('userId', id);
    preferences.setString('userType', 'Supervisor');
  }

  Future setAdmin(String token, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
    preferences.setString('userId', id);
    preferences.setString('userType', 'Admin');
  }

  Widget _buildSignIn(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        padding: EdgeInsets.only(top: 20.0),
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
                      key: _loginkey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              controller: loginEmailController,
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
                                  size: 22.0,
                                ),
                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0
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
                              focusNode: myFocusNodePasswordLogin,
                              controller: loginPasswordController,
                              obscureText: _obscureTextLogin,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleLogin,
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 160.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.blueAccent,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blue
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: _initLogIn(context),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                onPressed: () {
                  flowController.animateToPage(0, duration: Duration(milliseconds: 750), curve: Curves.decelerate);
                },
                child: Text(
                  "Go Back",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSansMedium"
                  ),
                )
              ),
            ),
          ],
        ),
      )
    );
  }

  _initLogIn(context) {
    if (_mode == 'Teacher') {
      return ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => Mutation(
            options: MutationOptions(document: """
            mutation loginTeacher(\$method: String!, \$password: String!){
              loginTeacher(method: \$method, password: \$password) {
                userId
                token
              }
            }
          """),
            builder: (
                RunMutation runMutation,
                QueryResult result,
                ){
              return MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.blueAccent,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0
                    ),
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () => logIn(runMutation, null, null)
              );
            },
            onCompleted: (dynamic resultData) {
              if(resultData != null) {
                print("See Next");
                print(resultData);
                model.setToken(resultData["loginTeacher"]["token"]);
                model.setId(resultData["loginTeacher"]["userId"]);
                setSupervisor(resultData["loginTeacher"]["token"], resultData["loginTeacher"]["userId"]);
                Navigator.pushReplacementNamed(context, '/teacher');
              }
              else {
                setState(() {
                  isLoading = false;
                });
                showInSnackBar("Invalid Credentials");
              }
            },
          )
      );
    } else {
      return ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => Mutation(
            options: MutationOptions(document: """
            mutation loginStudent(\$method: String!, \$password: String!){
              loginStudent(method: \$method, password: \$password) {
                userId
                token
              }
            }
          """),
            builder: (
                RunMutation runMutation,
                QueryResult result,
                ){
              return MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.blueAccent,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0
                    ),
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () => logIn(runMutation, null, null)
              );
            },
            onCompleted: (dynamic resultData) {
              if(resultData != null) {
                print(resultData);
                model.setToken(resultData["loginStudent"]["token"]);
                model.setId(resultData["loginStudent"]["userId"]);
                setAdmin(resultData["loginStudent"]["token"], resultData["loginStudent"]["userId"]);
                Navigator.pushReplacementNamed(context, '/student');
              }
              else {
                setState(() {
                  isLoading = false;
                });
                showInSnackBar("Invalid Credentials");
              }
            },
          )
      );
    }
  }

  void logIn (runMutation, String method, String password) {
    setState(() {
      isLoading = true;
    });
    if(runMutation == null) {
      print(method);
      runMutation({
        "method": method,
        "password": password,
      });
    }
    else {
      print(loginEmailController.text);
      runMutation({
        "method": loginEmailController.text,
        "password": loginPasswordController.text,
      });
    }
  }

  void _onSupervisorButtonPress() {
    _mode = 'Supervisor';
    flowController.animateToPage(1, duration: Duration(milliseconds: 750), curve: Curves.decelerate);

  }

  void _onAdminButtonPress() {
    _mode = 'Admin';
    flowController?.animateToPage(1, duration: Duration(milliseconds: 750), curve: Curves.decelerate);
  }

  void goBackToSelector () {
    flowController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

}
