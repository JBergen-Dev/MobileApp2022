import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static List<String> usernames = <String>[];
  static Map<String, User> userMap = <String, User>{};

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();

  DatabaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
  }

  Stream<Map<String, User>> get users => _usersController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  Map<String, User> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      User user = User.fromJson(element.id, element.data());
      userMap[user.id] = user;
      usernames.add(user.displayName);
    }

    return userMap;
  }
}
