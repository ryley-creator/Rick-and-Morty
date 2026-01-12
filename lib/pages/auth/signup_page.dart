import 'package:task/imports/imports.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key, required this.function});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final void Function()? function;
  void signUp(BuildContext context) async {
    final AuthService auth = AuthService();
    if (passwordConfirmController.text == passwordController.text) {
      try {
        await auth.signUp(emailController.text, passwordController.text);
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password do not match')));
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
                      'Welcome on Board!',
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
                    SizedBox(height: 10),
                    AuthTextfield(
                      labelText: 'Confirm password...',
                      controller: passwordConfirmController,
                    ),
                  ],
                ),
                Column(
                  children: [
                    AuthButton(text: 'Sign up', onTap: () => signUp(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: function,
                          child: Text(
                            'Login!',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
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
