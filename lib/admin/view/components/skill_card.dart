import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final String skillName;
  final String docId;
  final VoidCallback onDelete;

  const SkillCard({super.key, 
    required this.skillName,
    required this.docId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        title: Text(
          skillName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
