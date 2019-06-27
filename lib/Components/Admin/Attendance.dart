import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Attendance extends StatefulWidget {

  final data;
  Attendance({Key key, this.data});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Attendance Args');
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("DMRC Attendance Manager"),
        ),
      ),
      body: Query(
        options: QueryOptions(
          document: """
            query attendanceByDateAndSupervisorId (\$date: String!, \$supervisorId: String!) {
              attendanceByDateAndSupervisorId (date: \$date, supervisorId: \$supervisorId) {
                labourName
                labourId
                labourImage
                validated
                rejected
              }
            }
          """,
          variables: <String, dynamic> {
            "date": widget.data[1],
            "supervisorId": widget.data[0]
          },
          fetchPolicy: FetchPolicy.noCache, pollInterval: 100
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${attendance[index]["name"]}',
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
        }
      ),
    );
  }
}
