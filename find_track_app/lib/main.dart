import 'package:find_track_app/auth/bloc/auth_bloc.dart';
import 'package:find_track_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:find_track_app/pages/favorites.dart';
import 'package:find_track_app/pages/home_page.dart';
import 'package:find_track_app/pages/song_information.dart';
import 'package:find_track_app/provider/music_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent()))
      ],
      child: ChangeNotifierProvider(
        create: (context) => Music_Provider(),
        child: MyApp()
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicFindApp',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0x303030),
      ),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      // initialRoute: "/login",
      routes: {
        "/login": (context) => LoginPage(),
        "/homePage": (context) => HomePage(),
        "/favorites": (context) => Favorites(),
        "/songInformation": (context) => SongInformation(),
      },
    );
  }
}
