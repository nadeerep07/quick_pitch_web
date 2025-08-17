import 'package:cloud_firestore/cloud_firestore.dart';

class SkillService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'skills';

  Stream<QuerySnapshot<Object?>> getSkillsStream() {
    return _db.collection(_collection).orderBy('name').snapshots();
  }
  Future<QuerySnapshot<Object?>> getSkillsByName(String name) {
    return _db.collection(_collection).where('name', isEqualTo: name).get();
  }

  Future<void> addSkill(String name) async {
    await _db.collection(_collection).add({'name': name});
  }

  Future<void> deleteSkill(String docId) async {
    await _db.collection(_collection).doc(docId).delete();
  }
}
