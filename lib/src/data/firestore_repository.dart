import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/users.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  Future<void> addCounter(
      {required String counter,
      required String company,
      required String address}) async {
    final docRef = _firestore.collection('counter').doc(counter);

    await docRef
        .set({'counter': counter, 'company': company, 'address': address});
  }

  Future<void> addUsers(
      {required String uid,
      required String company,
      required String name,
      String role = "entrant",
      String approvedRole = "entrant"}) async {
    final docRef = _firestore.collection('users').doc(uid);
    await docRef.set({
      'uid': uid,
      'company': company,
      'name': name,
      'role': role,
      'approvedRole': approvedRole
    });
  }

  Future<void> updateUsers({
    required String uid,
    required String approvedRole,
  }) async {
    final docRef = _firestore.doc('users/$uid');
    await docRef.update({'approvedRole': approvedRole});
  }

  Query<Users> usersQuery() {
    return _firestore.collection('users').withConverter(
        fromFirestore: (snapshot, _) => Users.fromMap(snapshot.data()!),
        toFirestore: (users, _) => users.toMap());
  }

  Future<Users> oneUserQuery(String uid) async {
    final ref = _firestore.collection('users').doc(uid).withConverter(
        fromFirestore: (snapshot, _) => Users.fromMap(snapshot.data()!),
        toFirestore: (users, _) => users.toMap());
    final docSnap = await ref.get();
    final oneUser = docSnap.data();
    return oneUser!;
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(firestore: FirebaseFirestore.instance);
});
