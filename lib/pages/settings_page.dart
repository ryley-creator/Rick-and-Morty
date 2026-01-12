import 'package:task/imports/imports.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings Page')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              FirebaseAuth.instance.currentUser!.email.toString(),
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout),
                TextButton(
                  onPressed: auth.logout,
                  child: Text('LogOut', style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
