import 'package:ecocollect/src/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../src/models/app_user.dart';
import '../src/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // ✅ Singleton
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  factory AuthService() {
    return instance;
  }

  /// Stream de l'utilisateur Firebase natif
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Stream de ton AppUser
  Stream<AppUser?> get appUserStream {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);
      return _userService.listenToUser(user.uid);
    });
  }

  /// S'inscrire avec email + mot de passe
  Future<AppUser?> signUpWithEmail(
      String email, String password, String displayName) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) return null;

    final appUser = AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? "",
      displayName: displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(), password: '',
    );

    await _userService.createUser(appUser);
    return appUser;
  }

  /// Connexion avec email + mot de passe
  Future<AppUser?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) return null;

    return _userService.getUserById(firebaseUser.uid);
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signIn({required String email, required String password}) async 
  {
    await _userService.signIn(email, password);
  }

  Future<void> signUp({required String email, required String password, required String displayName}) async 
  {
    int uniqueId = UniqueKey().hashCode;
    var user = AppUser(
      id: uniqueId.toString(),
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      password: password,
    );
    await _userService.createUser(user);
  }

  Future<void> resetPassword(String trim) async 
  {

  }

  Future<void> updateProfile({String? displayName, String? address, String? sector, bool? notif, String? theme, required String id}) async 
  {
    await _userService.updateUser(id, {
      if (displayName != null) 'displayName': displayName,
      if (address != null) 'address': address,
      if (sector != null) 'sector': sector,
      if (notif != null) 'notif': notif,
      if (theme != null) 'theme': theme,
    });
  }

  Future<void> deleteAccount() async 
  {
    final uid = _auth.currentUser!.uid;
    await _userService.deleteUser(uid);
    await _auth.currentUser!.delete();
  } 
}
  