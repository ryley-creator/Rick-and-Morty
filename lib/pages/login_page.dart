import 'package:task/imports/imports.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.function});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final void Function()? function;
  void login(BuildContext context) async {
    final AuthService auth = AuthService();
    try {
      await auth.login(emailController.text, passwordController.text);
      context.read<FavoriteBloc>().add(
        FavoritesLoaded(FirebaseAuth.instance.currentUser!.uid),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 30),
                    AuthTextfield(
                      labelText: 'Enter email...',
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    AuthTextfield(
                      labelText: 'Enter password...',
                      controller: passwordController,
                    ),
                  ],
                ),
                AuthButton(text: 'Login', onTap: () => login(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account yet?"),
                    TextButton(
                      onPressed: function,
                      child: Text(
                        'Register now',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
