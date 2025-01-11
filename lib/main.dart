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

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()..loadLoginState()),
      ChangeNotifierProvider(create: (_) => DrillProvider()),
      ChangeNotifierProvider(create: (context) => UserDrillInfoProvider()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Provider.of<AuthProvider>(context, listen: false).isLoggedIn
            ? HomeScreen()
            : LoginScreen(),
      ),
    );
  }
}