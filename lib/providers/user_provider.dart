import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocollect/src/models/app_user.dart';

class UserProvider {
  final _db = FirebaseFirestore.instance.collection("users");

  /// 🔹 Créer un utilisateur
  Future<void> createUser(AppUser user) async {
    await _db.doc(user.id).set(user.toJson());
  }

  /// 🔹 Récupérer un utilisateur par son ID
  Future<AppUser?> getUser(String id) async {
    final doc = await _db.doc(id).get();
    if (!doc.exists) return null;
    return AppUser.fromDoc(doc);
  }

  /// 🔹 Mettre à jour un utilisateur
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    data["updatedAt"] = DateTime.now();
    await _db.doc(id).update(data);
  }

  /// 🔹 Supprimer un utilisateur
  Future<void> deleteUser(String id) async {
    await _db.doc(id).delete();
  }

  /// 🔹 Stream temps réel pour un utilisateur
  Stream<AppUser?> streamUser(String id) {
    return _db.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromDoc(doc);
    });
  }

  /// 🔹 Stream temps réel pour toute la collection users
  Stream<List<AppUser>> streamAllUsers() {
    return _db.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppUser.fromDoc(doc)).toList();
    });
  }

  /// 🔹 Récupérer tous les utilisateurs (one-time)
  Future<List<AppUser>> getAllUsers() async {
    final snapshot = await _db.get();
    return snapshot.docs.map((doc) => AppUser.fromDoc(doc)).toList();
  }
}
