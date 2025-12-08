import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/models/site_model.dart';
import 'package:provider/provider.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class SiteService extends ChangeNotifier {
  SiteService() {
    _initializeService();
  }

  factory SiteService.of(BuildContext context, {bool listen = false}) {
    return Provider.of<SiteService>(context, listen: listen);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SiteModel> _sites = [];
  bool _isLoading = false;

  List<SiteModel> get sites => _sites;
  bool get isLoading => _isLoading;

  void _initializeService() {
    _firestore
        .collection('sites')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _sites = snapshot.docs
          .map((doc) => SiteModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      notifyListeners();
    });
  }

  Future<bool> createSite({
    required String siteName,
    required String createdBy,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final docRef = _firestore.collection('sites').doc();
      final newSite = SiteModel(
        id: docRef.id,
        siteName: siteName,
        createdBy: createdBy,
        createdAt: DateTime.now(),
      );

      await docRef.set(newSite.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating site: $e');
      return false;
    }
  }

  Future<bool> deleteSites(List<String> siteIds) async {
    try {
      _isLoading = true;
      notifyListeners();

      final batch = _firestore.batch();
      for (final id in siteIds) {
        batch.delete(_firestore.collection('sites').doc(id));
      }
      await batch.commit();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error deleting sites: $e');
      return false;
    }
  }
}