import 'package:flutter/cupertino.dart';
import 'register_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _searchQuery = '';

  List<Task> get filteredTasks {
    if (_searchQuery.isEmpty) {
      return globalTasks;
    }
    return globalTasks.where((task) =>
      task.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _deleteTask(int originalIndex) {
    showCupertinoDialog(
      context: context,
      builder: (modalContext) => CupertinoAlertDialog(
        title: const Text("Eliminar Tarea"),
        content: const Text("¿Estás seguro de que quieres eliminar esta tarea?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Eliminar"),
            onPressed: () {
              Navigator.of(modalContext).pop();
              if (mounted) {
                setState(() {
                  globalTasks.removeAt(originalIndex);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getPriorityColor(DateTime taskDate) {
    final now = DateTime.now();
    final taskDay = DateTime(taskDate.year, taskDate.month, taskDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = taskDay.difference(today).inDays;

    if (difference < 0) return const Color(0xFFE53E3E); // Pasada - Rojo
    if (difference == 0 || difference == 1) return const Color(0xFFED8936); // Hoy/Mañana - Naranja
    if (difference <= 7) return const Color(0xFFECC94B); // Próxima - Amarillo
    return const Color(0xFF48BB78); // Normal - Verde
  }

  String _getPriorityText(DateTime taskDate) {
    final now = DateTime.now();
    final taskDay = DateTime(taskDate.year, taskDate.month, taskDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = taskDay.difference(today).inDays;

    if (difference < 0) return 'Pasada';
    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Mañana';
    if (difference <= 7) return 'Esta semana';
    return 'Programada';
  }

  int _getCompletedTasksCount() {
    final today = DateTime.now();
    return globalTasks.where((task) {
      final taskDate = DateTime(task.createdAt.year, task.createdAt.month, task.createdAt.day);
      final nowDate = DateTime(today.year, today.month, today.day);
      return taskDate.isBefore(nowDate);
    }).length;
  }

  int _getUpcomingTasksCount() {
    final today = DateTime.now();
    return globalTasks.where((task) {
      final taskDate = DateTime(task.createdAt.year, task.createdAt.month, task.createdAt.day);
      final nowDate = DateTime(today.year, today.month, today.day);
      return taskDate.isAfter(nowDate);
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFFF8F9FA),
        middle: Text(
          'Mis Tareas',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Barra de búsqueda y estadísticas
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Estadísticas rápidas
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                CupertinoIcons.list_bullet,
                                color: CupertinoColors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${globalTasks.length}',
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Total',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF48BB78), Color(0xFF38A169)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                CupertinoIcons.checkmark_circle_fill,
                                color: CupertinoColors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_getCompletedTasksCount()}',
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Pasadas',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFED8936), Color(0xFFDD6B20)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                CupertinoIcons.clock_fill,
                                color: CupertinoColors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_getUpcomingTasksCount()}',
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Futuras',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Barra de búsqueda
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CupertinoTextField(
                      placeholder: 'Buscar tareas...',
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(
                          CupertinoIcons.search,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Lista de tareas
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              CupertinoIcons.doc_text,
                              size: 50,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            globalTasks.isEmpty ? 'No hay tareas registradas' : 'No se encontraron tareas',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF718096),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            globalTasks.isEmpty 
                                ? 'Agrega tu primera tarea en la pestaña "Nueva Tarea"'
                                : 'Intenta con otra búsqueda',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final originalIndex = globalTasks.indexOf(task);
                        final priorityColor = _getPriorityColor(task.createdAt);
                        final priorityText = _getPriorityText(task.createdAt);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.systemGrey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CupertinoListTile(
                            padding: const EdgeInsets.all(20),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: priorityColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.doc_text_fill,
                                color: priorityColor,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              task.description,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.calendar,
                                      size: 14,
                                      color: Color(0xFF718096),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(task.createdAt),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF718096),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    priorityText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: priorityColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFED7D7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  CupertinoIcons.trash,
                                  size: 16,
                                  color: Color(0xFFE53E3E),
                                ),
                              ),
                              onPressed: () => _deleteTask(originalIndex),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}