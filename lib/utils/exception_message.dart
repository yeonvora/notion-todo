// [Notion Error Reference](https://developers.notion.com/reference/errors)
class ExceptionMessage {
  static String from(int status) {
    String? message;
    switch (status) {
      case 400:
      case 403:
      case 409:
      case 429:
        message = "동기화에 실패했어요.";
        break;
      case 401:
        message = "설정에서 Notion API를 확인해주세요.";
        break;
      case 404:
        message = "데이터베이스를 찾을 수 없어요.";
        break;
      case 500:
        message = "Notion 서버에 문제가 발생했어요.";
        break;
      case 503:
        message = "작업 시간이 지체되어 작업이 취소되었어요.";
        break;
    }

    return message ?? '문제가 발생했어요.';
  }
}
