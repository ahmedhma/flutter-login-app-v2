import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey to uniquely identify the Form widget and perform validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to capture user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- ADDED: Constant credentials for testing ---
  final String _validEmail = "user@gmail.com";
  final String _validPassword = "password123";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // --- ADDED: Check if the input matches our constant credentials ---
      if (_emailController.text == _validEmail && _passwordController.text == _validPassword) {
        
        // Clear the text fields
        _emailController.clear();
        _passwordController.clear();

        // Navigate to the Profile Screen and pass the email
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(email: _validEmail),
          ),
        );
      } else {
        // Show an error message if credentials don't match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Use user@gmail.com / password123 to login", 
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ADDED: Simple User Profile Screen ---
class UserProfileScreen extends StatelessWidget {
  final String email;
  
  const UserProfileScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    // Extract the name from the email (everything before the '@')
    String extractedName = email.split('@')[0];
    
    // Capitalize the first letter for a nicer display
    if (extractedName.isNotEmpty) {
      extractedName = extractedName[0].toUpperCase() + extractedName.substring(1);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome, $extractedName!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Registered Email: $email',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Log out by going back to the login screen
                Navigator.pop(context);
              },
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}