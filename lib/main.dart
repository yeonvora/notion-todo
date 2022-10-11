import 'package:flutter/material.dart' hide Action;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/constants/colors.dart';

import 'package:noti/features/action/presentation/action_screen.dart';
import 'package:noti/features/profile/presentation/profile_screen.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) => throw UnimplementedError());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  print('🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡');

  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'noti',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: CommonColors.background,
      ),

      // Flutter navigation 1.0
      initialRoute: '/',
      routes: {
        '/': (context) => const ActionScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
