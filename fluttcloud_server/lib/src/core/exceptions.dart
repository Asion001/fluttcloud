class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'Unauthorized';
}

class UserNotFoundException implements Exception {
  const UserNotFoundException();

  @override
  String toString() => 'User not found';
}

class NotFoundException implements Exception {
  const NotFoundException();

  @override
  String toString() => 'Not found';
}
