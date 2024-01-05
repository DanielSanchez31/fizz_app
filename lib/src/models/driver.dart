import 'dart:convert';

Driver clientFromJson(String str) => Driver.fromJson(json.decode(str));

String clientToJson(Driver data) => json.encode(data.toJson());

class Driver {

  String id;
  String username;
  String email;
  String password;
  String plate;
  String token;
  String auto;
  String model;
  String image;
  String identification;
  String inter;
  String card;
  String account;

  Driver({
    this.id,
    this.username,
    this.email,
    this.password,
    this.plate,
    this.token,
    this.auto,
    this.model,
    this.image,
    this.identification,
    this.inter,
    this.card,
    this.account
  });


  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    plate: json["plate"],
    token: json["token"],
    auto: json["auto"],
    model: json["model"],
    image: json["image"],
    identification: json["identification"],
    inter: json["inter"],
    card: json["card"],
    account: json["account"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "plate": plate,
    "token": token,
    "auto": auto,
    "model": model,
    "image": image,
    "identification": identification,
    "inter" : inter,
    "card" : card,
    "account" : account
  };
}