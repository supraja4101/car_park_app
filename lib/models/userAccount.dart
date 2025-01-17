import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/booking.dart';
import '../entities/carpark.dart';
import '../constants/databaseConsts.dart';

class UserAccount {
  late String uid;
  late String fullName = "";
  late String email = "";
  late String phone = "";
  late List<Booking> bookings = [];
  late List<Carpark> favourites = [];

  UserAccount(
      {required this.uid, String? email, String? fullName, String? phone}) {
    if (email != null) this.email = email;
    if (fullName != null) this.fullName = fullName;
    if (phone != null) this.phone = phone;
  }

  UserAccount.fromJson(String uid, Map json) {
    this.uid = uid;
    email = json[userConst.email] as String;
    fullName = json[userConst.fullName] as String;
    phone = json[userConst.phone] as String;
    bookings = json[userConst.bookings] as List<Booking>;
    favourites = json[userConst.favourites] as List<Carpark>;
  }

  Map<String, Object?> userInfoToJson() => {
        userConst.email: email,
        userConst.fullName: fullName,
        userConst.phone: phone
      };

  Map<String, Object?> favouritesToJson() {
    // Convert favourites from list of carparks to list of document references
    List<DocumentReference> favouriteRefs = [
      for (int i = 0; i < favourites.length; i++)
        FirebaseFirestore.instance
            .collection(carparkConst.collectionName)
            .doc(favourites[i].id)
    ];
    return {userConst.favourites: favouriteRefs};
  }

  Map<String, Object?> toJson() {
    Map<String, Object?> json = userInfoToJson();
    json.addAll(favouritesToJson());
    return json;
  }

  String userInfoToString() => [
        "User $uid",
        "-" * (5 + uid.length),
        "Email: $email",
        "Full Name: $fullName",
        "Phone Number: $phone"
      ].join("\n");

  String favouritesToString() => [
        "FAVOURITES",
        "----------",
        for (int i = 0; i < favourites.length; i++) favourites[i].toString()
      ].join("\n");

  String bookingsToString() => [
        "BOOKINGS",
        "--------",
        for (int i = 0; i < bookings.length; i++) bookings[i].toString()
      ].join("\n");

  String toString() =>
      [userInfoToString(), favouritesToString(), bookingsToString()].join("\n");

  String get id => uid;

  String getEmail() {
    return this.email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  String getFullName() {
    return this.fullName;
  }

  void setFullName(String fullName) {
    this.fullName = fullName;
  }

  String getPhone() {
    return this.phone;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }
}
