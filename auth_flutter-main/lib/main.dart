import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uilogin/provider/berita_provider.dart';
import 'package:flutter_uilogin/provider/dosen_provider.dart';
import 'package:flutter_uilogin/provider/fasilitas_provider.dart';
import 'package:flutter_uilogin/provider/galeri_provider.dart';
import 'package:flutter_uilogin/provider/imagepick_provider.dart';
import 'package:flutter_uilogin/provider/prodi_provider.dart';
import 'package:flutter_uilogin/provider/tentang_provider.dart';
import 'package:flutter_uilogin/provider/testimoni_provider.dart';
import 'package:flutter_uilogin/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_uilogin/screen/dashboard_screen.dart';
import '../provider/auth_provider.dart' as PamAuthProvider;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PamAuthProvider.AuthProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickProvider()),
        ChangeNotifierProvider(create: (_) => ProdiProvider()),
        ChangeNotifierProvider(create: (_) => TentangProvider()),
        ChangeNotifierProvider(create: (_) => BeritaProvider()),
        ChangeNotifierProvider(create: (_) => DosenProvider()),
        ChangeNotifierProvider(create: (_) => GaleriProvider()),
        ChangeNotifierProvider(create: (_) => TestimoniProvider()),
        ChangeNotifierProvider(create: (_) => FasilitasProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fakultas Vokasi',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green
        ),
        themeMode: ThemeMode.dark,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx,snapshot){
            if(snapshot.hasData){
              return Dashboard();
            }
            return const LoginScreen();
          })
       
      ),
    );
  }
}
