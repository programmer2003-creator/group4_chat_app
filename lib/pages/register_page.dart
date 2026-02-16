import 'package:flutter/material.dart';
import 'package:group4_chat_app/services/auth/auth_service.dart';
import 'package:group4_chat_app/components/my_button.dart';
import 'package:group4_chat_app/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  //email and password text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  //tap to go register page
  final Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  //register method
  void register(BuildContext context) async {
    //get auth service
    final _auth = AuthService();

    // check if password and confirm password are the same
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // await is required here to wait for firebase to respond
        await _auth.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    }
    //if password and confirm password are not the same
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Passwords do not match'),
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
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 50),
          //welcome back
          Text(
            "Create Your Own Account!",
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

          const SizedBox(height: 10),

          //confirm password text field
          MyTextField(
            hintText: 'Confirm Password',
            obscureText: true,
            controller: confirmPasswordController,
          ),

          const SizedBox(height: 25),

          //login button
          MyButton(
            text: 'Register',
            onTap: () => register(context),
          ),

          const SizedBox(height: 25),

          //register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  ' Login Here!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
