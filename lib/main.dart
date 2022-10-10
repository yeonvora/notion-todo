import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:noti/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noti/domain/action_repository.dart';
import 'package:noti/domain/action_service.dart';

import 'package:noti/screens/home_screen.dart';
// import 'package:noti/screens/setting_screen.dart';

GetIt sl = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton<ActionRepositoryPort>(() => ActionRepository(sl()));
  sl.registerLazySingleton<ActionUsecase>(() => ActionService(sl()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'noti',
      home: const HomeScreen(),
      theme: ThemeData(
        fontFamily: 'Pretendard',
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: CommonColors.background,
      ),
    );
  }
}
