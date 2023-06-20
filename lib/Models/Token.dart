class Token {
  String access = "";

  Token();

  Token.fromMap(Map json) {
    print(json.toString());
    access = json['access_token'];
  }
}
