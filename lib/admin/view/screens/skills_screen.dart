import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickpitch_wwwweb/admin/view/components/add_skill_section.dart';
import 'package:quickpitch_wwwweb/admin/view/components/skill_list.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/skill_viewmodel.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SkillViewModel>(context);
    final theme = Theme.of(context);
    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Text(
            'Manage Skills',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          /// Add New Skill
          AddSkillSection(vm: vm),

          const SizedBox(height: 40),

          /// Existing Skills
          Text(
            'Existing Skills',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          /// Skill List
          Expanded(
            child: SkillList(vm: vm),
          ),
        ],
      ),
    );
  }
}
