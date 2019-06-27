import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import './Models/AppModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Components/utils/route_generator.dart';
import './Components/Auth/LoginPage.dart';
import './Components/Supervisor/Supervisor.dart';
import './Components/Admin/Admin.dart';

Future<void> main() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var savedToken = await prefs.getString('token');
  var savedUserId = await prefs.getString('userId');
  var savedUserType = await prefs.getString('userType');

  runApp(
    ScopedModel<AppModel>(
      model: AppModel(),
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => MyApp(token: savedUserType != null ? savedToken : model.token, id: savedUserType != null ? savedUserId : model.id, loggedIn: savedUserType != null ? true : false, userType: savedUserType)
      )
    )
  );
}

class MyApp extends StatelessWidget {

  final String token;
  final String id;
  final bool loggedIn;
  final String userType;
  MyApp({this.token, this.id, this.loggedIn, this.userType});

  @override
  Widget build(BuildContext context) {
    HttpLink link;
    String graphqlUri = 'https://dmrc-attendance-app.herokuapp.com/graphql';
    if (token == null) {
      link = HttpLink(uri: graphqlUri);
    } else {
      link = HttpLink(
        uri: graphqlUri, headers: {"authorization": "Bearer $token"});
    }

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: link as Link,
        cache: InMemoryCache())
    );

    return GraphQLProvider(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: loggedIn ? (userType  == 'Supervisor' ? Supervisor() : Admin()) : LoginPage(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
      client: client,
    );
  }
}