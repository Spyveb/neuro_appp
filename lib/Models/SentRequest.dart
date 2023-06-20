import 'package:intl/intl.dart';

class SentRequest {
  String id = "";
  String user_id = "";
  String name = "";
  String birthdate = "";
  String profile_img = "";
  String address = "";
  Duration? time;

  SentRequest();

  List<SentRequest> list_request = <SentRequest>[];

  String user_budge = "";

  SentRequest.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      user_budge = jsonMap['user_budge'].toString();
      list_request = (jsonMap['items'] as List)
          .map((e) => SentRequest.fromJSONDETAILS(e))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  SentRequest.fromJSONDETAILS(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      String create_at = jsonMap['date'].toString();
      String server_time = jsonMap['servertime'].toString();
      DateTime CreateAtDateTime =
          new DateFormat("yyyy-MM-dd hh:mm:ss").parse(create_at);
      DateTime SeverDateTime =
          new DateFormat("yyyy-MM-dd hh:mm:ss").parse(server_time);

      time = daysBetween(CreateAtDateTime, SeverDateTime);
      var user = jsonMap['user'];
      user_id = user['id'].toString();
      name = user['name'].toString();
      birthdate = user['birthdate'].toString();
      profile_img = user['profile_img'].toString();
      address = user['address'].toString();
    } catch (e) {
      print(e);
    }
  }

  Duration daysBetween(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    var seconds = to.difference(from).inSeconds;
    var houre48second = Duration(hours: 48).inSeconds;
    /**
     * need to minus 48 hours second
     */
    var finalSecond = (houre48second - seconds);

    var duration = new Duration(seconds: finalSecond);
    print(duration);
    return duration;
  }

  Map toMap(){
    var map = new Map<String,dynamic>();
    map['user_id'] = id;
    return map;
  }
}
