import 'package:flutter/cupertino.dart';
import '../models/user.dart';

class RegisterUserScreen extends StatefulWidget {
  final String username;
  final String password;

  const RegisterUserScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _tempPickedDate = DateTime.now();
  User? registeredUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _tempPickedDate = _selectedDate;
  }

  void _showDatePicker() {
    _tempPickedDate = _selectedDate;
    showCupertinoModalPopup(
      context: context,
      builder: (modalContext) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEDF2F7), width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Color(0xFF5B67CA)),
                    ),
                    onPressed: () => Navigator.of(modalContext).pop(),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        color: Color(0xFF5B67CA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      setState(() => _selectedDate = _tempPickedDate);
                      Navigator.of(modalContext).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (date) => _tempPickedDate = date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() => _isLoading = true);
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulación de carga

    if (!mounted) return;
    setState(() {
      registeredUser = User(
        name: widget.username,
        password: widget.password,
        birthDate: _selectedDate,
      );
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFEDF2F7), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header con avatar
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B67CA), Color(0xFF8A64D0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          widget.username.isNotEmpty
                              ? widget.username[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Completa tu perfil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Usuario: ${widget.username}',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),

              // Formulario
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de credenciales
                    const Text(
                      'Tus credenciales',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nombre de usuario
                    _buildInfoRow(
                      icon: CupertinoIcons.person_fill,
                      label: 'Nombre de usuario',
                      value: widget.username,
                    ),
                    const SizedBox(height: 16),

                    // Contraseña
                    _buildInfoRow(
                      icon: CupertinoIcons.lock_fill,
                      label: 'Contraseña',
                      value: '*' * widget.password.length,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),

                    // Fecha de nacimiento
                    const Text(
                      'Fecha de nacimiento',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.calendar,
                              color: Color(0xFF5B67CA),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Botón de registro
              Container(
                margin: const EdgeInsets.only(top: 24),
                height: 50,
                width: double.infinity,
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF5B67CA),
                  disabledColor: const Color(0xFF5B67CA).withOpacity(0.6),
                  onPressed: registeredUser != null || _isLoading
                      ? null
                      : _registerUser,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : const Text(
                          'Registrar Usuario',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),

              // Confirmación de registro
              if (registeredUser != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF48BB78), Color(0xFF38A169)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF48BB78).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: 40,
                        color: CupertinoColors.white,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Registro exitoso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bienvenido, ${registeredUser!.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha de nacimiento: ${_formatDate(registeredUser!.birthDate)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF5B67CA), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isPassword ? '*' * value.length : value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
