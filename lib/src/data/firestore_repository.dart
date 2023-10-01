import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/counter.dart';
import 'package:etar_q/src/data/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  Future<void> addCounter(
      {required num counter,
      required String company,
      required String address}) async {
    final docRef = _firestore.collection('counter').doc(counter.toString());

    await docRef
        .set({'counter': counter, 'company': company, 'address': address});
  }

  Future<void> addUsers(
      {required String uid,
      required String company,
      required String name,
      String role = "entrant",
      String approvedRole = "elbírálás alatt"}) async {
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

  Query<Users> usersQuery(String company) {
    return _firestore
        .collection('users')
        .where('company', isEqualTo: company)
        .withConverter(
            fromFirestore: (snapshot, _) => Users.fromMap(snapshot.data()!),
            toFirestore: (users, _) => users.toMap());
  }

  Future<Users> oneUserQuery(String uid) async {
    final ref = _firestore.collection('users').doc(uid).withConverter(
        fromFirestore: (snapshot, _) => Users.fromMap(snapshot.data()!),
        toFirestore: (users, _) => users.toMap());
    final docSnap = await ref.get();
    if (docSnap.exists) {
      final oneUser = docSnap.data();
      return oneUser!;
    }
    return Users(uid: uid, name: '', company: '', role: '', approvedRole: '');
  }

  Future<bool> isCompany(String company) async {
    final ref = _firestore
        .collection('counter')
        .where('company', isEqualTo: company)
        .limit(1)
        .withConverter(
            fromFirestore: (snapshot, _) => Counter.fromMap(snapshot.data()!),
            toFirestore: (counter, _) => counter.toMap());
    final docSnap = await ref.get();
    if (docSnap.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Query<Counter> countCounter() {
    return _firestore
        .collection('counter')
        .orderBy('counter', descending: true)
        .limit(1)
        .withConverter(
            fromFirestore: (snapshot, _) => Counter.fromMap(snapshot.data()!),
            toFirestore: (counter, _) => counter.toMap());
  }

  Future<Counter> oneCounter(String counter) async {
    final ref = _firestore.collection('counter').doc(counter).withConverter(
        fromFirestore: (snapshot, _) => Counter.fromMap(snapshot.data()!),
        toFirestore: (counter, _) => counter.toMap());
    final docSnap = await ref.get();
    if (docSnap.exists) {
      final oneCounter = docSnap.data();
      return oneCounter!;
    }
    return const Counter(counter: 0, company: '', address: '');
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(firestore: FirebaseFirestore.instance);
});
