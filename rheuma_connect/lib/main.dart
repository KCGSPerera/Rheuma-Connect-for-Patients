import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/patient_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rheumatic Clinic App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
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
