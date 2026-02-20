import 'package:flutter/material.dart';
import 'package:group4_chat_app/services/auth/auth_service.dart';
import 'package:group4_chat_app/components/my_button.dart';
import 'package:group4_chat_app/components/my_textfield.dart';

class LoginPage extends StatelessWidget {

  //email and password text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //tap
  late final Function()? onTap;


  LoginPage({super.key,
  required this.onTap,
  });

  // login method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    }

    //catch error
catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
      );
}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Icon(Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 50),
          //welcome back
          Text("Welcome back buddy!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
          ),
          ),
          const SizedBox(height: 25),
          //email text field
          MyTextField(
            hintText: 'Email',
            obscureText: false,
            controller: emailController,
          ),

          const SizedBox(height: 10),

          //password text field
          MyTextField(
            hintText: 'Password',
            obscureText: true,
            controller: passwordController,
          ),

          const SizedBox(height: 25),

          //login button
          MyButton(
            text: 'Login',
            isBold: true,
            onTap:() => login(context),
          ),

          const SizedBox(height: 25),

          //register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text('Don\'t have an account?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          GestureDetector(
            onTap: onTap,
          child: Text('Register here!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      ),
          ],
          ),
        ],
      )
      ),
      backgroundColor: Theme. of(context).colorScheme.surface,
    );
  }
}
