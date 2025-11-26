import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = AuthService();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Crear cuenta'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.medical_services,
                  size: 70, color: Colors.teal),
              const SizedBox(height: 16),

              const Text(
                'Crea tu cuenta en Medify',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const SizedBox(height: 6),
              const Text(
                'Empieza a controlar tus medicamentos fácilmente',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              TextField(
                controller: email,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Correo electrónico',
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Contraseña',
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: 'Confirmar contraseña',
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (password.text != confirmPassword.text) {
                      setState(() {
                        error = 'Las contraseñas no coinciden';
                      });
                      return;
                    }

                    try {
                      await auth.register(
                        email.text.trim(),
                        password.text.trim(),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() {
                        error = 'Error al registrar usuario';
                      });
                    }
                  },
                  child: const Text('Registrarse',
                      style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),

              if (error.isNotEmpty)
                Text(error,
                    style: const TextStyle(color: Colors.red, fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }
}
