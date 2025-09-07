import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart'; // adapte le chemin selon ton projet

class UserService {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection("users");

  /// Ajouter un utilisateur
  Future<void> createUser(AppUser user) async {
    await usersRef.doc(user.id).set(user.toJson());
  }

  /// se connecter
  Future<void> signIn(String email, String password) async 
  {
    var _user = await usersRef.get();
    var matchedUser = _user.docs.where((doc) => doc['email'] == email && doc['password'] == password);
    if (matchedUser.isNotEmpty) 
    {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email);
      prefs.setString("password", password);
      prefs.setString("id", AppUser.fromDoc(matchedUser.first).id);
    } else {
      // Échec de la connexion
      throw Exception("Échec de la connexion: Email ou mot de passe incorrect.");
    }
  }

  /// Récupérer un utilisateur par ID
  Future<AppUser?> getUserById(String id) async {
    final doc = await usersRef.doc(id).get();
    if (!doc.exists) return null;
    return AppUser.fromDoc(doc);
  }

  /// Mettre à jour un utilisateur
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await usersRef.doc(id).update(data);
  }

  /// Supprimer un utilisateur
  Future<void> deleteUser(String id) async {
    await usersRef.doc(id).delete();
  }

  /// Écouter un utilisateur en temps réel
  Stream<AppUser?> listenToUser(String id) {
    return usersRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromDoc(doc);
    });
  }

  /// Écouter tous les utilisateurs
  Stream<List<AppUser>> listenToAllUsers() {
    return usersRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppUser.fromDoc(doc)).toList();
    });
  }
}
