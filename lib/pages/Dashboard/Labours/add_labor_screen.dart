import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cms/globals/labor_service.dart';
import 'package:cms/globals/auth_service.dart';
import 'package:cms/globals/site_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class AddLaborScreen extends StatefulWidget {
  const AddLaborScreen({super.key});

  @override
  State<AddLaborScreen> createState() => _AddLaborScreenState();
}

@NowaGenerated()
class _AddLaborScreenState extends State<AddLaborScreen> {
  final _laborNameController = TextEditingController();
  final _workController = TextEditingController();
  final _salaryController = TextEditingController();
  String? _selectedSiteName;
  bool _isLoading = false;

  @override
  void dispose() {
    _laborNameController.dispose();
    _workController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (_selectedSiteName == null || _selectedSiteName!.isEmpty) {
      _showErrorSnackBar('Please select a site');
      return false;
    }

    final laborName = _laborNameController.text.trim();
    if (laborName.isEmpty) {
      _showErrorSnackBar('Labor name is required');
      return false;
    }
    if (laborName.length < 3) {
      _showErrorSnackBar('Labor name must be at least 3 characters');
      return false;
    }

    final work = _workController.text.trim();
    if (work.isEmpty) {
      _showErrorSnackBar('Work/job role is required');
      return false;
    }

    final salaryText = _salaryController.text.trim();
    if (salaryText.isEmpty) {
      _showErrorSnackBar('Salary is required');
      return false;
    }

    final salary = double.tryParse(salaryText);
    if (salary == null || salary <= 0) {
      _showErrorSnackBar('Please enter a valid salary amount');
      return false;
    }

    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = context.read<AuthService>();
    final laborService = context.read<LaborService>();
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('User not found. Please login again.');
      }
      return;
    }

    final success = await laborService.createLabor(
      laborName: _laborNameController.text.trim(),
      work: _workController.text.trim(),
      siteName: _selectedSiteName!,
      salary: double.parse(_salaryController.text.trim()),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
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
              const Text('Labor added successfully'),
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
      _showErrorSnackBar('Failed to add labor. Please try again.');
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add New Labor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Site Name Dropdown
              Text(
                'Select Site Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xff0a2342),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Consumer<SiteService>(
                builder: (context, siteService, child) {
                  final sites = siteService.sites;

                  if (sites.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffe0e0e0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xff607286),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No sites available. Please add a site first.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xff607286),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedSiteName,
                      hint: Text(
                        'e.g., Downtown Tower Project',
                        style: TextStyle(
                          color: const Color(0xffa0a0a0),
                          fontSize: 16,
                        ),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xff093e86),
                      ),
                      dropdownColor: Colors.white,
                      items: sites.map((site) {
                        return DropdownMenuItem<String>(
                          value: site.siteName,
                          child: Text(
                            site.siteName,
                            style: const TextStyle(
                              color: Color(0xff0a2342),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSiteName = value;
                        });
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Labor Name
              Text(
                'Labor Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xff0a2342),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _laborNameController,
                decoration: InputDecoration(
                  hintText: 'Enter full name',
                  hintStyle: const TextStyle(color: Color(0xffa0a0a0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xff0a2342),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Work
              Text(
                'Work',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xff0a2342),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _workController,
                decoration: InputDecoration(
                  hintText: 'e.g., Electrician, Mason',
                  hintStyle: const TextStyle(color: Color(0xffa0a0a0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xff0a2342),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Salary
              Text(
                'Salary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xff0a2342),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: '25000',
                  hintStyle: const TextStyle(color: Color(0xffa0a0a0)),
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    color: Color(0xff0a2342),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xff0a2342),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff093e86),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor:
                        const Color(0xff093e86).withValues(alpha: 0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}