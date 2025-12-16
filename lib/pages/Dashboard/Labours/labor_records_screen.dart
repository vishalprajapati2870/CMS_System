import 'package:cms/pages/Dashboard/Labours/add_labor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/globals/labor_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:intl/intl.dart';

@NowaGenerated()
class LaborRecordsScreen extends StatefulWidget {
  const LaborRecordsScreen({super.key});

  @override
  State<LaborRecordsScreen> createState() => _LaborRecordsScreenState();
}

@NowaGenerated()
class _LaborRecordsScreenState extends State<LaborRecordsScreen> {
  final Set<String> _selectedLaborIds = {};
  bool _isSelectionMode = false;

  void _toggleSelection(String laborId) {
    setState(() {
      if (_selectedLaborIds.contains(laborId)) {
        _selectedLaborIds.remove(laborId);
      } else {
        _selectedLaborIds.add(laborId);
      }
      _isSelectionMode = _selectedLaborIds.isNotEmpty;
    });
  }

  void _enterSelectionMode(String laborId) {
    setState(() {
      _isSelectionMode = true;
      _selectedLaborIds.add(laborId);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedLaborIds.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _handleDelete(BuildContext context) async {
    if (_selectedLaborIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Are you sure?'),
          ],
        ),
        content: Text(
          'This action cannot be undone. You are about to permanently delete ${_selectedLaborIds.length} selected labor(s).',
          style: const TextStyle(color: Color(0xff607286)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xff607286),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final laborService = context.read<LaborService>();
      final success = await laborService.deleteLabors(_selectedLaborIds.toList());

      if (context.mounted) {
        _clearSelection();
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  const Text('Labors deleted successfully'),
                ],
              ),
              backgroundColor: const Color(0xff22a340),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to delete labors'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7eff6),
      appBar: AppBar(
        backgroundColor: const Color(0xff093e86),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isSelectionMode) {
              _clearSelection();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: _isSelectionMode
            ? Text('${_selectedLaborIds.length} Selected')
            : const Text('Labors'),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _handleDelete(context),
            ),
        ],
      ),
      body: Consumer<LaborService>(
        builder: (context, laborService, child) {
          final labors = laborService.labors;

          if (laborService.isLoading && labors.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (labors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: const Color(0xff607286).withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No labors added yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xff607286),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first labor',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xff607286).withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: labors.length,
            itemBuilder: (context, index) {
              final labor = labors[index];
              final isSelected = _selectedLaborIds.contains(labor.id);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: const Color(0xff093e86), width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _isSelectionMode
                      ? () => _toggleSelection(labor.id)
                      : null,
                  onLongPress: () => _enterSelectionMode(labor.id),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (_isSelectionMode)
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xff093e86)
                                    : const Color(0xffc4c4c4),
                                width: 2,
                              ),
                              color: isSelected
                                  ? const Color(0xff093e86)
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labor.laborName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: const Color(0xff0a2342),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                labor.work,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xff607286),
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                labor.siteName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: const Color(0xff607286),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatCurrency(labor.salary),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: const Color(0xff093e86),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddLaborScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xff093e86),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}