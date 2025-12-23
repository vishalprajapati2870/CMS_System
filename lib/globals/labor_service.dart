import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/models/labor_model.dart';
import 'package:provider/provider.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class LaborService extends ChangeNotifier {
  LaborService() {
    _initializeService();
  }

  factory LaborService.of(BuildContext context, {bool listen = false}) {
    return Provider.of<LaborService>(context, listen: listen);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LaborModel> _labors = [];
  bool _isLoading = false;

  List<LaborModel> get labors => _labors;
  bool get isLoading => _isLoading;

  void _initializeService() {
    _firestore
        .collection('labors')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _labors = snapshot.docs
          .map((doc) => LaborModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      notifyListeners();
    });
  }

  Future<bool> createLabor({
    required String laborName,
    required String work,
    required String siteName,
    required double salary,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final docRef = _firestore.collection('labors').doc();
      final newLabor = LaborModel(
        id: docRef.id,
        laborName: laborName,
        work: work,
        siteName: siteName,
        salary: salary,
        createdAt: DateTime.now(),
      );

      await docRef.set(newLabor.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating labor: $e');
      return false;
    }
  }

  /// Assign a labor to a site
  Future<bool> assignLaborToSite({
    required String laborId,
    required String siteName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('labors').doc(laborId).update({
        'siteName': siteName,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error assigning labor to site: $e');
      return false;
    }
  }

  Future<bool> deleteLabors(List<String> laborIds) async {
    try {
      _isLoading = true;
      notifyListeners();

      final batch = _firestore.batch();
      for (final id in laborIds) {
        batch.delete(_firestore.collection('labors').doc(id));
      }
      await batch.commit();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error deleting labors: $e');
      return false;
    }
  }
}