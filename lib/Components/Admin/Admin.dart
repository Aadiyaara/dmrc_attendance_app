import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/AppModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatelessWidget {
  
  DateTime _date = DateTime.now();

  Future<Null> _selectDate (supervisorId, context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2099)
    );
    List data = [];
    data.add(supervisorId);
    data.add(picked.toString().split(' ')[0]);
    Navigator.pushNamed(context, '/attendance', arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("DMRC Attendance Manager"),
        ),
      ),
      body: Container(
        child: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) =>Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Query(options: QueryOptions(document: """
                query supervisors {
                  supervisors {
                    _id
                    name
                    phoneNumber
                  }
                }
              """, variables: <String, dynamic> {

                }, fetchPolicy: FetchPolicy.noCache, pollInterval: 5), builder: (QueryResult res, {VoidCallback refetch}) {
                  print(res.data);

                  if (res.errors != null) {
                    return Text(res.errors.toString());
                  }

                  if (res.loading) {
                    return Center(
                      child: Text('Loading'),
                    );
                  }

                  // it can be either Map or List
                  List supervisors = res.data['supervisors'];

                  if(supervisors.length == 0) {
                    return Center(
                      child: Text('No Supervisors yet'),
                    );
                  }

                  return ListView.builder(
                    itemCount: supervisors.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 16.0, left: 12.0, right: 12.0
                        ),
                        child: Material(
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(12.0),
                          shadowColor: Color(0x802196F3),
                          color: Colors.white,
                          child: InkWell(
                            // Do onTap() if it isn't null, otherwise do print()
                            onTap: () {
                              _selectDate(supervisors[index]['_id'], context);
                            },
                            onLongPress: () {

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${supervisors[index]["name"]}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        )
                                      ),
                                    ],
                                  ),
                                ]
                              ),
                            )
                          )
                        ),
                      );
                    },
                  );
                }),
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
                        onPressed: () { Navigator.pushNamed(context, '/addsupervisor'); },
                        child: Text('Add'),
                      ),
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
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}