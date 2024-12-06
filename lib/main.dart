import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/init/firebase_init.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/viewmodel/auth_view_model.dart';
import 'features/home/viewmodel/home_view_model.dart';

void main() async {
  await FirebaseInit.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Kur-Ye',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const LoginView(),
          );
        },
      ),
    );
  }
} 