const String invalid_value = '입력해주세요.';

const String validation_token = '토큰은 "secret_"으로 시작합니다.';

const String minimum_token_length = '올바른 토큰을 입력해주세요.';

const String validation_database_id = '데이터베이스 아이디를 확인해주세요.';

String? validateToken(String? value) {
  if (value == null || value.isEmpty) {
    return invalid_value;
  }

  final tokenPrefix = RegExp(r'secret');
  if (tokenPrefix.matchAsPrefix(value) == null) {
    return validation_token;
  }

  if (value.length < 50) {
    return minimum_token_length;
  }

  return null;
}

String? validateDatabaseId(String? text) {
  if (text == null || text.isEmpty) {
    return invalid_value;
  }

  if (text.length < 32) {
    return validation_database_id;
  }

  return null;
}
