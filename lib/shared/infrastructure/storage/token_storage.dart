import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Used for storing ids and token for fast access through the application.
class TokenStorage {
    final _storage = FlutterSecureStorage();
    final _key = 'token';
    final _accountId = 'account_id';
    final _userId = 'user_id';
    final _branchId = 'branch_id';
    final _isFirstLogin = 'is_first_login';

    /// Method for saving data into the storage.
    Future<void> save(String token, String accountId, { String? userId, String? branchId }) async {
        await _storage.write(key: _key, value: token);
        await _storage.write(key: _accountId, value: accountId);

        if (userId != null) {
            await _storage.write(key: _userId, value: userId);
        }

        if (branchId != null) {
            await _storage.write(key: _branchId, value: branchId);
        }

        await _storage.write(key: _isFirstLogin, value: 'true');
    }

    /// Method for reading the token from the storage with a special key.
    Future<String?> readToken() async {
        return await _storage.read(key: _key);
    }

    /// Method for reading the account id from the storage with a special key.
    Future<String?> readAccountId() async {
        return await _storage.read(key: _accountId);
    }

    /// Method for reading the user id from the storage with a special key.
    Future<String?> readUserId() async {
        return await _storage.read(key: _userId);
    }

    /// Method for reading the branch id from the storage with a special key.
    Future<String?> readBranchId() async {
        return await _storage.read(key: _branchId);
    }

    /// Method for determining a first login situation in the application.
    Future<bool> isFirstLogin() async {
        final value = await _storage.read(key: _isFirstLogin);
        return value == 'true';
    }

    /// Method for marking a login as complete for the application.
    Future<void> markLoginComplete() async {
        await _storage.write(key: _isFirstLogin, value: 'false');
    }

    /// Method for deleting data from the storage.
    Future<void> delete() async {
        await _storage.delete(key: _key);
        await _storage.delete(key: _accountId);
        await _storage.delete(key: _userId);
        await _storage.delete(key: _branchId);
        await _storage.delete(key: _isFirstLogin);
    }
}