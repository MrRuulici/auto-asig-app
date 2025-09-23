class AuthRepository {
  const AuthRepository(
      // this._authenticationProvider,
      // this._biometricStorageProvider,
      );

  // final SupabaseAuthProvider _authenticationProvider;
  // final BiometricStorageProvider _biometricStorageProvider;

  // String? get membersId => _authenticationProvider.getUserId();

  /// Returns members ID if successful, null otherwise.
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return null;
  }

  /// Returns members ID if successful, null otherwise.
  Future<void> signUp({
    required String firstName,
    required String email,
    required String phoneNumber,
  }) async {
    // await _authenticationProvider.signUp(
    //   firstName,
    //   email,
    //   phoneNumber,
    // );
  }

  Future<void> sendPasswordResetEmail(String email) async {}

  Future<void> signOut() async {
    // await AuthService().saveToken(token: '', email: '');

    // await _authenticationProvider.signOut();

    return;
  }
}
