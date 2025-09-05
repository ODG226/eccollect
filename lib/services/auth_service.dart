import 'package:ecocollect/src/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_provider.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _users = UserProvider();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = AppUser(
      id: cred.user!.uid,
      email: email,
      displayName: displayName, // ✅ cohérent maintenant
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _users.createUser(user);

    // On met aussi à jour le profil Firebase Auth
    await cred.user!.updateDisplayName(displayName);

    return user;
  }

  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _users.getUser(cred.user!.uid);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  User? get currentUser => _auth.currentUser;
}
