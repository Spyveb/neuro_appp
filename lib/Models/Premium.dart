class Premium {
  bool status = false;
  String premiumtoken = "";
  String subdevice = "";
  Premium();

  Map toMap(){
    var map = new Map<String,dynamic>();
    map['status'] = status;
    map['premiumtoken'] = premiumtoken;
    map['subdevice'] = subdevice;
    return map;
  }
}
