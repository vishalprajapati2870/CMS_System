import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/models/labor_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class SiteWiseSalaryDetailsScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SiteWiseSalaryDetailsScreen({
    super.key,
    required this.siteName,
    required this.fromDate,
    required this.toDate,
  });

  final String siteName;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  State<SiteWiseSalaryDetailsScreen> createState() =>
      _SiteWiseSalaryDetailsScreenState();
}

@NowaGenerated()
class _SiteWiseSalaryDetailsScreenState
    extends State<SiteWiseSalaryDetailsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _salaryData = [];
  double _totalPayableSalary = 0;

  @override
  void initState() {
    super.initState();
    _fetchAndCalculateSalary();
  }

  Future<void> _fetchAndCalculateSalary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final laborsSnapshot = await FirebaseFirestore.instance
          .collection('labors')
          .where('siteName', isEqualTo: widget.siteName)
          .get();

      final labors = laborsSnapshot.docs
          .map((doc) => LaborModel.fromJson(doc.data()))
          .toList();

      List<Map<String, dynamic>> calculatedData = [];
      double totalPayable = 0;
      final random = Random();

      for (var labor in labors) {
        // Mock Attendance Logic
        int totalDays = widget.toDate.difference(widget.fromDate).inDays + 1;
        int presentDays = 0;
        int halfDays = 0;

        // Simple mock: Randomly assign full/half days ensuring it doesn't exceed totalDays
        // This is just for demo visualization as requested
        presentDays = random.nextInt(totalDays + 1); 
        // halfDays = random.nextInt(totalDays - presentDays + 1); // Remaining days could be half

        // Let's make it a bit more realistic for the screenshot demo
        // e.g. 80-90% attendance
        if (totalDays > 5) {
           presentDays = (totalDays * 0.8).toInt() + random.nextInt((totalDays * 0.1).toInt() + 1);
           int remaining = totalDays - presentDays;
           if (remaining > 0) {
             halfDays = random.nextInt(remaining + 1);
           }
        }
        
        double dailySalary = labor.salary;
        double totalSalary =
            (presentDays * dailySalary) + (halfDays * dailySalary * 0.5);

        totalPayable += totalSalary;

        calculatedData.add({
          'labourName': labor.laborName,
          'work': labor.work, // Added for subtitle (e.g. Mason)
          'rate': dailySalary,
          'fullDays': presentDays,
          'halfDays': halfDays,
          'totalSalary': totalSalary,
        });
      }

      setState(() {
        _salaryData = calculatedData;
        _totalPayableSalary = totalPayable;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching salary data: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f7fa),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Salary Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Information Card
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xffeaf1fb),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.apartment,
                                  color: Color(0xff003a78)),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PROJECT SITE',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.siteName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xffeaf1fb),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_today,
                                  color: Color(0xff003a78)),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DURATION',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${dateFormat.format(widget.fromDate)} - ${dateFormat.format(widget.toDate)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Table Header
                Container(
                  color: const Color(0xff003a78),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 40,
                        child: Text(
                          'NO.',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'LABOUR NAME',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'RATE',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'ATTEN.',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'TOTAL',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // List Data
                Expanded(
                  child: _salaryData.isEmpty
                      ? const Center(child: Text('No Labors found for this site'))
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: _salaryData.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            color: Color(0xffecedee),
                          ),
                          itemBuilder: (context, index) {
                            final item = _salaryData[index];
                            return Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      (index + 1).toString().padLeft(2, '0'),
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['labourName'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        if (item['work'] != null)
                                          Text(
                                            item['work'],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '₹${item['rate'].toInt()}',
                                      style: const TextStyle(
                                        color: Color(0xff607286),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: RichText(
                                      text: TextSpan(
                                        style: DefaultTextStyle.of(context).style,
                                        children: [
                                          TextSpan(
                                            text: '${item['fullDays']} ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'F',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (item['halfDays'] > 0) ...[
                                            const TextSpan(text: '\n'),
                                            TextSpan(
                                              text: '+${item['halfDays']} ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: 'H',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '₹${NumberFormat('#,##0').format(item['totalSalary'])}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        color: Color(0xff003a78),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                // Footer Total
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'TOTAL PAYABLE SALARY',
                              style: TextStyle(
                                color: Color(0xff607286),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'For selected duration',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${NumberFormat('#,##0').format(_totalPayableSalary)}',
                          style: const TextStyle(
                            color: Color(0xff003a78),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
