import 'package:flutter/material.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/skill_viewmodel.dart';
import 'package:quickpitch_wwwweb/core/config/app_colors.dart';

class AddSkillSection extends StatelessWidget {
  final SkillViewModel vm;

  const AddSkillSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: vm.skillController,
              decoration: InputDecoration(
                labelText: 'Enter skill name',
                hintText: 'e.g., Plumbing, Painting',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => vm.addSkill(context),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
