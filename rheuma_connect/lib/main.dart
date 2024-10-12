import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rheuma_connect/screens/splash_screen.dart';
import 'providers/patient_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/infoHub_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/information_hub_screen.dart';
import 'screens/appointment_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => InfoHubProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rheumatic Clinic App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/information_hub': (context) => InformationHubScreen(),
          '/appointments': (context) => AppointmentScreen(),
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/appointment_screen.dart';
// import 'screens/login_screen.dart';
// import 'providers/auth_provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/login',
//         routes: {
//           '/login': (context) => LoginScreen(),
//           '/appointments': (context) => AppointmentScreen(),
//         },
//         home: Consumer<AuthProvider>(
//           builder: (context, authProvider, _) {
//             return authProvider.isLoggedIn
//                 ? AppointmentScreen()
//                 : LoginScreen();
//           },
//         ),
//       ),
//     );
//   }
// }
