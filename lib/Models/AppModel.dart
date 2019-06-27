import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {

  String _token;
  String _id;

  String get token => _token;
  String get id => _id;

  void setToken(String t) {
    _token = t;

    notifyListeners();
  }

  void setId(String t) {
    _id = t;

    notifyListeners();
  }

}