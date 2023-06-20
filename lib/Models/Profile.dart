class Profile {
  String id = "";
  String name = "";
  String email = "";
  String profile_img = "";
  String about_me = "";
  List<dynamic> more_image = <dynamic>[];
  String birthdate = "";
  String gender = "";
  List<dynamic> following_applies = <dynamic>[];
  String notification = "";
  String mode = "";
  String address = "";

  bool isPrime = false;
  bool isVerified = false;
  List<dynamic> personality = <dynamic>[];
String neurologicalstatus = "";
  String latitude = "";
  String longitude = "";
  List<DemoSourceEntity> sourceList = <DemoSourceEntity>[];
  int sourceIndex = 0;

  Profile();

  Profile.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      email = jsonMap['email'].toString();
      neurologicalstatus = jsonMap['neurologicalstatus'].toString();
      if (jsonMap['image'] != null &&
          jsonMap['image'] != "" &&
          (jsonMap['image'] as List<dynamic>).length > 0) {
        more_image = jsonMap['image'] as List<dynamic>;
      }
      sourceList.add(DemoSourceEntity(sourceIndex++, 'image', jsonMap['profile_img'].toString()));
      if(more_image.length > 0){
        more_image.forEach((element) {
          sourceList.add(DemoSourceEntity(sourceIndex++, 'image', element));
        });
      }
      if (jsonMap['following_applies'] != null && jsonMap['following_applies'].toString() != "") {
        following_applies = jsonMap['following_applies'] as List<dynamic>;
      }
      if (jsonMap['birthdate'] != null) {
        birthdate = jsonMap['birthdate'].toString();
      } else {
        birthdate = "0";
      }
      gender = jsonMap['gender'].toString();
      profile_img = jsonMap['profile_img'].toString();
      if (jsonMap['address'] != null) {
        address = jsonMap['address'].toString();
      } else {
        address = "";
      }
      about_me = jsonMap['about_me'].toString();
      notification = jsonMap['notification'].toString();
      mode = jsonMap['mode'].toString();
      isPrime = jsonMap['isPrime'];
      isVerified = jsonMap['isVerified'];
      if (jsonMap['personality'] is List<dynamic>) {
        personality = jsonMap['personality'] as List<dynamic>;
      }
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['user_id'] = id;
    return map;
  }

  Map toMapMode() {
    var map = new Map<String, dynamic>();
    map['mode'] = mode;
    return map;
  }

  Map toMapLocation() {
    var map = new Map<String, dynamic>();
    map['address'] = address;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}

class DemoSourceEntity {
  int id;
  String url;
  String? previewUrl;
  String type;

  DemoSourceEntity(this.id, this.type, this.url, {this.previewUrl});
}
