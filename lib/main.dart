import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/app_export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/home_screen/provider/home_screen_provider.dart';
import 'presentation/forgot_password_screen/provider/forgot_password_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

   // await ProductService().uploadProducts(Assets.assetsData);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'E-commerce',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
