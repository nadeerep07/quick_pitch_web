import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickpitch_wwwweb/admin/view/components/delete_confirmation_dialog.dart';
import 'package:quickpitch_wwwweb/admin/view/components/skill_card.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/skill_viewmodel.dart';

class SkillList extends StatelessWidget {
  final SkillViewModel vm;

  const SkillList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: vm.skillsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(
            child: Text("No skills added yet."),
          );
        }

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = docs[index];
            final skillName = data['name'] as String? ?? 'Unnamed';
            final docId = data.id;

            return SkillCard(
              skillName: skillName,
              docId: docId,
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (_) => DeleteConfirmationDialog(
                    itemName: skillName,
                    onConfirm: () {
                      vm.deleteSkill(docId);
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
