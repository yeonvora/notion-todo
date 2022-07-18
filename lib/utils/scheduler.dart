// import 'package:cron/cron.dart';
// import 'package:todolist/domain/repository.dart';
// import 'package:todolist/domain/usecase.dart';
// import 'package:todolist/utils/get_today.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:todolist/api/notion.dart';
// import 'package:todolist/domain/entity.dart';

// void callbackDispatcher(List<Action> _actions, ActionRepository repository) {
//   final cron = Cron();
//   final notion = NotionController();

//   Workmanager().executeTask((taskName, inputData) {
//     // 하루 단위로 작업 실행
//     cron.schedule(Schedule.parse('* * */1 * *'), () async {
//       // 블록으로 변환
//       var actionBlock = _actions
//           .map((action) => checkboxBlock(action.name, action.done))
//           .toList();

//       // 노션 페이지 생성
//       final today = getToday();
//       await notion.createPage(today, actionBlock);

//       // 끝낸 일 제거
//       final usecase = ActionUseCase(_actions, repository);
//       usecase.cleanActions();
//     });

//     return Future.value(true);
//   });
// }
