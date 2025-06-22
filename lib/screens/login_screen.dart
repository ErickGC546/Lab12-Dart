import 'package:flutter/cupertino.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_isLoading) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(
        "Campos requeridos",
        "Por favor completa todos los campos",
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulamos un pequeño delay para el login
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            HomeScreen(username: username, password: password),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animado
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B67CA), Color(0xFF8A64D0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B67CA).withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.checkmark_seal_fill,
                    size: 60,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Título
                const Text(
                  'TaskMaster',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organiza tus tareas de forma inteligente',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Campo de Usuario
                _buildTextField(
                  controller: _usernameController,
                  icon: CupertinoIcons.person_fill,
                  placeholder: 'Usuario',
                ),
                const SizedBox(height: 20),

                // Campo de Contraseña
                _buildTextField(
                  controller: _passwordController,
                  icon: CupertinoIcons.lock_fill,
                  placeholder: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Botón de Login
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String placeholder,
    bool obscureText = false,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Icon(icon, color: const Color(0xFF5B67CA), size: 22),
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.extraLightBackgroundGray,
          width: 1,
        ),
      ),
      style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
      placeholderStyle: TextStyle(
        color: CupertinoColors.systemGrey.withOpacity(0.7),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF5B67CA),
        disabledColor: const Color(0xFF5B67CA).withOpacity(0.6),
        onPressed: _isLoading ? null : _login,
        child: _isLoading
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
