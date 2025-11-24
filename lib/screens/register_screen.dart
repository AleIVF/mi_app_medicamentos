import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F6),
        foregroundColor: Colors.black87,
        title: const Text(
          "Crear cuenta",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [

                // Título
                const Text(
                  "Crea tu cuenta para empezar",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 28),

                // Tarjeta
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Nombre
                      TextField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Botón Registrarse
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
                                    await AuthService().register(
                                      _emailCtrl.text.trim(),
                                      _passCtrl.text.trim(),
                                    );

                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  } finally {
                                    setState(() => _loading = false);
                                  }
                                },
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      )
                    ],
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
