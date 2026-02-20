import 'package:flutter/material.dart';
import 'package:group4_chat_app/services/auth/auth_service.dart';
import 'package:group4_chat_app/services/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    setState(() {
      userName = _storageService.getString('user_name');
      userEmail = _storageService.getString('user_email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile icon
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Name
            Text(
              userName ?? 'No Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Email
            Text(
              userEmail ?? 'No Email',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Action button (Placeholder for future features)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListTile(
                title: const Text('Edit Profile'),
                leading: const Icon(Icons.edit),
                onTap: () {
                  // TODO: Add edit profile logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
