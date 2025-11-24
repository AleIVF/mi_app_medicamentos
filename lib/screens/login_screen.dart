import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Ícono y título
                const Icon(Icons.medical_services_rounded,
                    size: 90, color: Color(0xFF1EC8A5)),
                const SizedBox(height: 12),
                const Text(
                  'Medify',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 30),

                // Tarjeta con sombra
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email Input
                      TextField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password Input
                      TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botón moderno
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF1EC8A5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _loading
                              ? null
                              : () async {
                                  setState(() => _loading = true);
                                  try {
                                    await AuthService().login(
                                      _emailCtrl.text.trim(),
                                      _passCtrl.text.trim(),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Error: $e'),
                                          backgroundColor: Colors.redAccent),
                                    );
                                  } finally {
                                    setState(() => _loading = false);
                                  }
                                },
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Crear cuenta (texto)
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1EC8A5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
