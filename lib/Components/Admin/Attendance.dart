import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';

class Attendance extends StatefulWidget {

  final data;
  Attendance({Key key, this.data});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  String focusImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Attendance Args');
    print(widget.data);
  }

  Widget ImageZoom() {
    if(focusImage != null) {
      return Center(
        child: Stack(
          children: <Widget>[
            Image.memory(base64Decode(focusImage)),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      focusImage = null;
                    });
                  },
                  child: Text('Back'),
                )
              ],
            )
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("DMRC Attendance Manager"),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Query(
            options: QueryOptions(
              document: """
                query attendanceByDateAndSupervisorId (\$date: String!, \$supervisorId: String!) {
                  attendanceByDateAndSupervisorId (date: \$date, supervisorId: \$supervisorId) {
                    labourName
                    labourId
                    labourImage
                    gpsLoc
                    validated
                    rejected
                  }
                }
              """,
              variables: <String, dynamic> {
                "date": widget.data[1],
                "supervisorId": widget.data[0]
              },
              fetchPolicy: FetchPolicy.noCache, pollInterval: 1000
          ),
            builder: (QueryResult res, {VoidCallback refetch}) {
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
              List attendance = res.data['attendanceByDateAndSupervisorId'];

              if(attendance.length == 0) {
                return Center(
                  child: Text('No Attendance yet'),
                );
              }

              return ListView.builder(
                itemCount: attendance.length,
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

                            },
                            onLongPress: () {

                            },
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
                                                '${attendance[index]["labourName"]}',
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
                                                '${attendance[index]["labourId"]}',
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
                                                    '${attendance[index]["gpsLoc"]}',
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
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            focusImage = attendance[index]['labourImage'];
                                          });
                                        },
                                        child: Image.memory(base64Decode(attendance[index]['labourImage'])),
                                      )
                                    )
                                  ]
                              ),
                            )
                          )
                        ),
                      );
                    },
                  );
                }
              ),
          ImageZoom()
        ],
      )
    );
  }
}
