import 'package:flickit/provider/auth_provider.dart';
import 'package:flickit/provider/drill_provider.dart';
import 'package:flickit/provider/user_drill_info_provider.dart';
import 'package:flickit/screens/home_screen.dart';
import 'package:flickit/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthProvider authProvider = AuthProvider();
  await authProvider.loadLoginState();
  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => AuthProvider()..loadLoginState()),
          ChangeNotifierProvider(create: (_) => DrillProvider()),
          ChangeNotifierProvider(create: (context) => UserDrillInfoProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: authProvider.isLoggedIn ? HomeScreen() : LoginScreen(),
        ),
      ),
    );
  }
}
