import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good morning, let's get stuff done!",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          /// --- OVERVIEW CARDS ---
          Row(
            children: [
              _buildCountCard(
                "Users",
                FirebaseFirestore.instance.collection("users"),
              ),
              const SizedBox(width: 16),
              _buildCountCard(
                "Pending Tasks",
                FirebaseFirestore.instance
                    .collection("poster_tasks")
                    .where("status", isEqualTo: "pending"),
              ),
              const SizedBox(width: 16),
              _buildCountCard(
                "Accepted Tasks",
                FirebaseFirestore.instance
                    .collection("poster_tasks")
                    .where("status", isEqualTo: "accepted"),
              ),
              const SizedBox(width: 16),
              _buildCountCard(
                "Completed Tasks",
                FirebaseFirestore.instance
                    .collection("poster_tasks")
                    .where("status", isEqualTo: "completed"),
              ),
            ],
          ),

          const SizedBox(height: 40),
          Text(
            "Recent Tasks",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          /// --- RECENT TASKS ---
          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection("poster_tasks")
                    .orderBy("createdAt", descending: true)
                    .limit(5)
                    .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No recent tasks");
              }

              return Column(
                children:
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      return _buildActivity(
                        (data["imagesUrl"] != null &&
                                (data["imagesUrl"] as List).isNotEmpty)
                            ? (data["imagesUrl"] as List).first
                            : "No Image",

                        data["title"] ?? "Untitled task",
                        data["status"] ?? "unknown",
                        _formatDate(data["createdAt"]),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Count cards (Users, Pending, Accepted, Completed)
  Widget _buildCountCard(String title, Query query) {
    return Expanded(
      child: StreamBuilder(
        stream: query.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _overviewCard(title, "-", "Loading...", Colors.grey);
          }

          final count = snapshot.data?.docs.length ?? 0;
          return _overviewCard(title, count.toString(), "+0%", Colors.green);
        },
      ),
    );
  }

  Widget _overviewCard(
    String title,
    String value,
    String change,
    Color changeColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(change, style: TextStyle(fontSize: 14, color: changeColor)),
        ],
      ),
    );
  }

  /// Recent task activity
  Widget _buildActivity(
    String image,
    String title,
    String status,
    String time,
  ) {
    final isValidUrl = image.startsWith("http");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: isValidUrl ? NetworkImage(image) : null,
            child:
                !isValidUrl
                    ? const Icon(Icons.image_not_supported, size: 22)
                    : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Status: $status",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.lightBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return "";
    if (createdAt is Timestamp) {
      return createdAt.toDate().toString();
    }
    if (createdAt is String) {
      return createdAt; // already stored as string
    }
    return "";
  }
}
