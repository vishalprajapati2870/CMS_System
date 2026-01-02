import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/models/site_model.dart';
import 'package:cms/components/animated_dropdown.dart';
import 'package:cms/pages/Dashboard/Salary/site_wise_salary_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class SiteWiseSalaryFilterScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SiteWiseSalaryFilterScreen({super.key});

  @override
  State<SiteWiseSalaryFilterScreen> createState() =>
      _SiteWiseSalaryFilterScreenState();
}

@NowaGenerated()
class _SiteWiseSalaryFilterScreenState
    extends State<SiteWiseSalaryFilterScreen> {
  SiteModel? _selectedSite;
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _onOkPressed() {
    if (_selectedSite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a site'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both from and to dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_fromDate!.isAfter(_toDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('From date cannot be after To date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SiteWiseSalaryDetailsScreen(
          siteName: _selectedSite!.siteName,
          fromDate: _fromDate!,
          toDate: _toDate!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeaf1fb),
      appBar: AppBar(
        title: const Text(
          'Site-Wise Salary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffeaf1fb),
        foregroundColor: const Color(0xff0a2342),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Site Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff607286),
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('sites').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error loading sites');
                }
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final sites = snapshot.data!.docs.map((doc) {
                  return SiteModel.fromJson(
                      doc.data() as Map<String, dynamic>);
                }).toList();

                return AnimatedDropdown<SiteModel>(
                  value: _selectedSite,
                  items: sites,
                  hintText: 'Select Construction Site',
                  itemLabelBuilder: (site) => site.siteName,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSite = newValue;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff607286),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _fromDate == null
                                    ? 'mm/dd/yyyy'
                                    : DateFormat('MM/dd/yyyy')
                                        .format(_fromDate!),
                                style: TextStyle(
                                  color: _fromDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Color(0xff003a78), size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'To Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff607286),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _toDate == null
                                    ? 'mm/dd/yyyy'
                                    : DateFormat('MM/dd/yyyy')
                                        .format(_toDate!),
                                style: TextStyle(
                                  color: _toDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Color(0xff003a78), size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onOkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff003a78),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
