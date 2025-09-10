import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/certification_viewmodel.dart';

enum CertificateStatus { pending, approved, rejected, banned }

class FixerCertificate {
  final String userId;
  final String name;
  final String certificateUrl;
  final CertificateStatus status;
  final DateTime? lastUpdated;

  FixerCertificate({
    required this.userId,
    required this.name,
    required this.certificateUrl,
    required this.status,
    this.lastUpdated,
  });

  factory FixerCertificate.fromFirestore(String userId, Map<String, dynamic> data) {
    final fixerData = data["fixerData"] as Map<String, dynamic>? ?? {};
    final statusString = fixerData["certificateStatus"] as String? ?? "Pending";
    
    CertificateStatus status;
    switch (statusString.toLowerCase()) {
      case 'approved':
        status = CertificateStatus.approved;
        break;
      case 'rejected':
        status = CertificateStatus.rejected;
        break;
      case 'banned':
        status = CertificateStatus.banned;
        break;
      default:
        status = CertificateStatus.pending;
    }

    return FixerCertificate(
      userId: userId,
      name: data["name"] as String? ?? "Unknown",
      certificateUrl: fixerData["certification"] as String? ?? "",
      status: status,
      lastUpdated: fixerData["lastUpdated"] != null 
          ? (fixerData["lastUpdated"] as Timestamp).toDate()
          : null,
    );
  }
}

class CertificateProvider extends ChangeNotifier {
  final CertificateViewModel _viewModel = CertificateViewModel();
  
  List<FixerCertificate> _certificates = [];
  bool _isLoading = false;
  String? _error;
  String? _processingUserId;

  List<FixerCertificate> get certificates => _certificates;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get processingUserId => _processingUserId;

  Stream<QuerySnapshot> get usersStream => _viewModel.getUsersStream();

  void updateCertificates(List<FixerCertificate> certificates) {
    _certificates = certificates;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void setProcessing(String? userId) {
    _processingUserId = userId;
    notifyListeners();
  }

  Future<void> approveCertificate(String userId) async {
    try {
      setProcessing(userId);
      await _viewModel.updateCertificateStatus(userId, "Approved");
      setProcessing(null);
    } catch (e) {
      setError(e.toString());
      setProcessing(null);
    }
  }

  Future<void> rejectCertificate(String userId) async {
    try {
      setProcessing(userId);
      await _viewModel.updateCertificateStatus(userId, "Rejected");
      setProcessing(null);
    } catch (e) {
      setError(e.toString());
      setProcessing(null);
    }
  }

  Future<void> banUser(String userId) async {
    try {
      setProcessing(userId);
      await _viewModel.banUser(userId);
      setProcessing(null);
    } catch (e) {
      setError(e.toString());
      setProcessing(null);
    }
  }

  Future<void> requestNewCertificate(String userId) async {
    try {
      setProcessing(userId);
      await _viewModel.requestNewCertificate(userId);
      setProcessing(null);
    } catch (e) {
      setError(e.toString());
      setProcessing(null);
    }
  }

  Future<DocumentSnapshot> getFixerData(String userId) {
    return _viewModel.getFixerData(userId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}