class Feed {
  String id = "";
  String name = "";
  String birthdate = "";
  String gender = "";
  String profile_img = "";
  String address = "";
  String about_me = "";
  bool isVerified = false;

  String mindistance = "";
  String maxdistance = "";
  String minage = "";
  String maxage = "";
  String hashtag = "";
  String mode = "";
  List<String> persnalitylist = <String>[];
  String swipe = "";
  String receiver_id = "";

  bool isNext = true;
  List<Feed> list_feeds = <Feed>[];

  Feed();

  Feed.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
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
      isVerified = jsonMap['isVerified'];
      about_me = jsonMap['about_me'].toString();
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['minage'] = minage;
    map['maxage'] = maxage;
    map['gender'] = gender;
    map['hashtag'] = hashtag;
    map['mode'] = mode;
    map['mindistance'] = mindistance;
    map['maxdistance'] = maxdistance;
    if(persnalitylist != null){
      map['personality'] = persnalitylist.join(",");
    }
    return map;
  }

  Map toMapSwipe() {
    var map = new Map<String, dynamic>();
    map['receiver_id'] = receiver_id;
    map['swipe'] = swipe;
    return map;
  }

  @override
  String toString() {
    return 'Feed{id: $id, name: $name, birthdate: $birthdate, gender: $gender, profile_img: $profile_img, address: $address, about_me: $about_me, minage: $minage, maxage: $maxage, hashtag: $hashtag, mode: $mode}';
  }
}
