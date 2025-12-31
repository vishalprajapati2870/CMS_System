import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class LabourSalaryDetailsScreen extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const LabourSalaryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeaf1fb),
      appBar: AppBar(
        title: const Text(
          'Labour Salary Details',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xff0a2342)),
        ),
        backgroundColor: const Color(0xffeaf1fb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0a2342)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSalaryCard(
            context,
            icon: Icons.money,
            title: 'Salary Details',
            subtitle:
                'View detailed breakdown of labour earnings based on attendance.',
            color: const Color(0xffe3f2fd),
            iconColor: const Color(0xff1565c0),
            onTap: () {
              // TODO: Navigate to Salary Details
            },
          ),
          const SizedBox(height: 16),
          _buildSalaryCard(
            context,
            icon: Icons.money_off,
            title: 'Withdrawn Salary',
            subtitle:
                'Check records of salary amounts already withdrawn by workers.',
            color: const Color(0xffffebee),
            iconColor: const Color(0xffc62828),
            onTap: () {
              // TODO: Navigate to Withdrawn Salary
            },
          ),
          const SizedBox(height: 16),
          _buildSalaryCard(
            context,
            icon: Icons.warning_amber_rounded,
            title: 'Excess Withdrawal Salary',
            subtitle: 'Review advance payments exceeding earned salary.',
            color: const Color(0xfffff3e0),
            iconColor: const Color(0xffef6c00),
            onTap: () {
               // TODO: Navigate to Excess Withdrawal Salary
            },
          ),
          const SizedBox(height: 16),
          _buildSalaryCard(
            context,
            icon: Icons.account_balance_wallet,
            title: 'Credit Salary',
            subtitle: 'Track remaining salary credits payable to workers.',
            color: const Color(0xffe8f5e9),
            iconColor: const Color(0xff2e7d32),
            onTap: () {
               // TODO: Navigate to Credit Salary
            },
          ),
          const SizedBox(height: 16),
          _buildSalaryCard(
            context,
            icon: Icons.check_circle_outline,
            title: 'Paid Salary',
            subtitle: 'Final payable amounts processed for this period.',
            color: const Color(0xfff3e5f5),
            iconColor: const Color(0xff7b1fa2),
            onTap: () {
               // TODO: Navigate to Paid Salary
            },
          ),
          const SizedBox(height: 16),
          _buildSalaryCard(
            context,
            icon: Icons.functions,
            title: 'Total',
            subtitle:
                'Site-wise Attendance + Withdrawn + Salary calculations.',
            color: const Color(0xffe8eaf6),
            iconColor: const Color(0xff283593),
            onTap: () {
               // TODO: Navigate to Total
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0a2342),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
