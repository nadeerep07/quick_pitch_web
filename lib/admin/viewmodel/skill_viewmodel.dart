import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickpitch_wwwweb/admin/repository/skils_service.dart';

class SkillViewModel extends ChangeNotifier {
  final SkillService _service = SkillService();
  final TextEditingController skillController = TextEditingController();

  Stream<QuerySnapshot> get skillsStream => _service.getSkillsStream();

  Future<void> addSkill(BuildContext context) async {
    final name = skillController.text.trim().toLowerCase();
    if (name.isEmpty) return;

    final exists = await checkSkillExists(name);
    if (exists) {
      _showDuplicateDialog(context, name);
      return;
    }

    await _service.addSkill(name);
    skillController.clear();
  }

  Future<void> deleteSkill(String docId) async {
    await _service.deleteSkill(docId);
  }

  Future<bool> checkSkillExists(String name) async {
   final snapshot = await _service.getSkillsByName(name);
    return snapshot.docs.isNotEmpty;
  }

void _showDuplicateDialog(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Duplicate Skill",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("The skill \"$name\" already exists."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    ),
  );
}

}
