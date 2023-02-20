import 'package:firebase_core/firebase_core.dart';
import 'package:tmobi_passenger/firebase_options.dart';

class FirebaseManager {
  static Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Initialized default app $app');
  }

}