import 'package:flutter/cupertino.dart';

// Modelo de Tarea
class Task {
  final String description;
  final DateTime createdAt;

  Task({required this.description, required this.createdAt});
}

List<Task> globalTasks = [];

// Pantalla principal para registrar tareas
class RegisterTaskScreen extends StatefulWidget {
  const RegisterTaskScreen({super.key});

  @override
  State<RegisterTaskScreen> createState() => _RegisterTaskScreenState();
}

class _RegisterTaskScreenState extends State<RegisterTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _tempPickedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
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
                minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                maximumDate: DateTime.now().add(const Duration(days: 365)),
                onDateTimeChanged: (date) => _tempPickedDate = date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addTask() async {
    final text = _taskController.text.trim();
    if (text.isEmpty) {
      await _showAlert(
        'Campo requerido',
        'Por favor ingresa una descripción para la tarea',
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      globalTasks.add(Task(description: text, createdAt: _selectedDate));
      _taskController.clear();
      _selectedDate = DateTime.now();
      _isLoading = false;
    });

    await _showAlert(
      'Tarea agregada',
      'Tu tarea se ha registrado exitosamente',
    );
  }

  Future<void> _showAlert(String title, String message) async {
    if (!mounted) return;
    await showCupertinoDialog(
      context: context,
      builder: (modalContext) => CupertinoAlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: CupertinoColors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: CupertinoColors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: const Text(
          'Nueva Tarea',
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
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
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
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B67CA), Color(0xFF8A64D0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.add_circled_solid,
                        color: CupertinoColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agregar nueva tarea',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Completa los detalles de tu tarea',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
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
                    // Campo de descripción
                    const Text(
                      'Descripción',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _taskController,
                      placeholder: 'Escribe la descripción de la tarea...',
                      maxLines: 3,
                      maxLength: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selector de fecha
                    const Text(
                      'Fecha',
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

              // Botón de acción
              Container(
                margin: const EdgeInsets.only(top: 24),
                height: 50,
                width: double.infinity,
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF5B67CA),
                  disabledColor: const Color(0xFF5B67CA).withOpacity(0.6),
                  onPressed: _isLoading ? null : _addTask,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : const Text(
                          'Guardar Tarea',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),

              // Estadísticas
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B67CA), Color(0xFF8A64D0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5B67CA).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: CupertinoIcons.list_bullet,
                      value: globalTasks.length.toString(),
                      label: 'Total tareas',
                    ),
                    _buildStatItem(
                      icon: CupertinoIcons.calendar_today,
                      value: globalTasks
                          .where(
                            (task) =>
                                task.createdAt.day == DateTime.now().day &&
                                task.createdAt.month == DateTime.now().month &&
                                task.createdAt.year == DateTime.now().year,
                          )
                          .length
                          .toString(),
                      label: 'Para hoy',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
