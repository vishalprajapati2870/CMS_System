import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:provider/provider.dart';
import 'package:cms/globals/auth_service.dart';
import 'package:cms/pages/login_screen.dart';
import 'package:cms/admin_status.dart';
import 'package:cms/user_role.dart';

@NowaGenerated()
class AdminDashboard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const AdminDashboard({super.key});

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: const Color(0xff003a78),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xff003a78),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xff607286),
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final currentUser = authService.currentUser;
        if (currentUser == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isRejected = currentUser.status == AdminStatus.rejected;

        return Scaffold(
          backgroundColor: const Color(0xffeaf1fb),
          appBar: AppBar(
            backgroundColor: const Color(0xff003a78),
            foregroundColor: Colors.white,
            title: Text('Admin Dashboard - ${currentUser.name}'),
            // NO drawer icon for regular admins
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
          // NO drawer for regular admins
          body: Column(
            children: [
              if (isRejected)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your access request has been rejected by Super Admin. Limited access only.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      _buildDashboardCard(
                        context,
                        icon: Icons.business,
                        title: 'Sites',
                        subtitle: 'Manage all project sites',
                        onTap: () {
                          // TODO: Navigate to Sites page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sites feature coming soon')),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.people,
                        title: 'Labours',
                        subtitle: 'View and edit labour profiles',
                        onTap: () {
                          // TODO: Navigate to Labours page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Labours feature coming soon')),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Daily Attendance',
                        subtitle: 'Track and log attendance',
                        onTap: () {
                          // TODO: Navigate to Daily Attendance page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Attendance feature coming soon')),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.account_balance_wallet,
                        title: 'Labour Salary',
                        subtitle: 'Process and manage salaries',
                        onTap: () {
                          // TODO: Navigate to Labour Salary page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Salary feature coming soon')),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.receipt_long,
                        title: 'Site-wise Expense',
                        subtitle: 'Record extra site expenses',
                        onTap: () {
                          // TODO: Navigate to Site-wise Expense page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Expense feature coming soon')),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.bar_chart,
                        title: 'Admin Paid Money',
                        subtitle: 'Generate and view reports',
                        onTap: () {
                          // TODO: Navigate to Reports page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reports feature coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}