import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all users with fixer roles
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection("users").snapshots();
  }

  // Get specific fixer data for a user
  Future<DocumentSnapshot> getFixerData(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("roles")
        .doc("fixer")
        .get();
  }

  // Update certificate status
  Future<void> updateCertificateStatus(String userId, String status) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("roles")
          .doc("fixer")
          .update({
        "fixerData.certificateStatus": status,
        "fixerData.lastUpdated": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update certificate status: $e');
    }
  }

  // Ban user - updates both certificate status and user status
  Future<void> banUser(String userId) async {
    try {
      final batch = _firestore.batch();
      
      // Update fixer role status
      final fixerRef = _firestore
          .collection("users")
          .doc(userId)
          .collection("roles")
          .doc("fixer");
      
      batch.update(fixerRef, {
        "fixerData.certificateStatus": "Banned",
        "fixerData.lastUpdated": FieldValue.serverTimestamp(),
      });

      // Update user status
      final userRef = _firestore.collection("users").doc(userId);
      batch.update(userRef, {
        "status": "banned",
        "bannedAt": FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to ban user: $e');
    }
  }

  // Request new certificate - resets status to pending
  Future<void> requestNewCertificate(String userId) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("roles")
          .doc("fixer")
          .update({
        "fixerData.certificateStatus": "Pending",
        "fixerData.lastUpdated": FieldValue.serverTimestamp(),
        "fixerData.resubmissionRequested": true,
      });
    } catch (e) {
      throw Exception('Failed to request new certificate: $e');
    }
  }
}