import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/certification_provider.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CertificateProvider(),
      child: const _CertificatesView(),
    );
  }
}

class _CertificatesView extends StatelessWidget {
  const _CertificatesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Certificate Management",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ),
      body: Consumer<CertificateProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return _ErrorWidget(
              error: provider.error!,
              onRetry: () => provider.clearError(),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: provider.usersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const _EmptyState();
              }

              return _CertificatesList(users: snapshot.data!.docs);
            },
          );
        },
      ),
    );
  }
}

class _CertificatesList extends StatelessWidget {
  final List<QueryDocumentSnapshot> users;

  const _CertificatesList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final userDoc = users[index];
        return _CertificateCard(
          userId: userDoc.id,
          userData: userDoc.data() as Map<String, dynamic>?,
        );
      },
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final String userId;
  final Map<String, dynamic>? userData;

  const _CertificateCard({
    required this.userId,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CertificateProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<DocumentSnapshot>(
          future: provider.getFixerData(userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const SizedBox.shrink();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data == null || data["fixerData"] == null) {
              return const SizedBox.shrink();
            }

            final certificate = FixerCertificate.fromFirestore(userId, data);
            
            if (certificate.certificateUrl.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(certificate),
                      const SizedBox(height: 16),
                      _buildCertificatePreview(certificate.certificateUrl),
                      const SizedBox(height: 16),
                      _buildActionButtons(context, certificate, provider),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(FixerCertificate certificate) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                certificate.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fixer ID: ${certificate.userId}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(certificate.status),
      ],
    );
  }

  Widget _buildStatusBadge(CertificateStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case CertificateStatus.approved:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        text = 'Approved';
        icon = Icons.check_circle;
        break;
      case CertificateStatus.rejected:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
      case CertificateStatus.banned:
        backgroundColor = Colors.grey[800]!;
        textColor = Colors.white;
        text = 'Banned';
        icon = Icons.block;
        break;
      case CertificateStatus.pending:
      default:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        text = 'Pending';
        icon = Icons.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificatePreview(String certificateUrl) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          certificateUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[100],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.grey, size: 48),
                    SizedBox(height: 8),
                    Text('Failed to load certificate'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FixerCertificate certificate,
    CertificateProvider provider,
  ) {
    final isProcessing = provider.processingUserId == certificate.userId;

    switch (certificate.status) {
      case CertificateStatus.pending:
        return _buildPendingActions(context, certificate, provider, isProcessing);
      case CertificateStatus.approved:
        return _buildApprovedActions();
      case CertificateStatus.rejected:
        return _buildRejectedActions(context, certificate, provider, isProcessing);
      case CertificateStatus.banned:
        return _buildBannedActions();
    }
  }

  Widget _buildPendingActions(
    BuildContext context,
    FixerCertificate certificate,
    CertificateProvider provider,
    bool isProcessing,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isProcessing
                ? null
                : () => provider.approveCertificate(certificate.userId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: isProcessing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check, size: 18),
            label: const Text('Approve'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isProcessing
                ? null
                : () => provider.rejectCertificate(certificate.userId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Reject'),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified, color: Colors.green, size: 24),
          SizedBox(width: 8),
          Text(
            'Certificate Approved',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedActions(
    BuildContext context,
    FixerCertificate certificate,
    CertificateProvider provider,
    bool isProcessing,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text(
                'Certificate Rejected',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () => _showBanConfirmation(context, certificate, provider),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.block, size: 18),
                label: const Text('Ban User'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () => provider.requestNewCertificate(certificate.userId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: isProcessing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: const Text('Request New'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBannedActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text(
            'User Banned',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showBanConfirmation(
    BuildContext context,
    FixerCertificate certificate,
    CertificateProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Ban User'),
          content: Text(
            'Are you sure you want to ban ${certificate.name}? This action will permanently restrict their access to the platform.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                provider.banUser(certificate.userId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Ban User'),
            ),
          ],
        );
      },
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No certificates to review',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Certificates will appear here when fixers upload them',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}