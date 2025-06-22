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
    if (_searchQuery.isEmpty) return globalTasks;
    return globalTasks
        .where(
          (task) => task.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  void _deleteTask(int originalIndex) {
    showCupertinoDialog(
      context: context,
      builder: (modalContext) => CupertinoAlertDialog(
        title: const Text("Eliminar Tarea"),
        content: const Text(
          "¿Estás seguro de que quieres eliminar esta tarea?",
        ),
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
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getPriorityColor(DateTime taskDate) {
    final now = DateTime.now();
    final taskDay = DateTime(taskDate.year, taskDate.month, taskDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = taskDay.difference(today).inDays;

    if (difference < 0) return const Color(0xFFE53E3E); // Pasada - Rojo
    if (difference == 0) return const Color(0xFFED8936); // Hoy - Naranja
    if (difference == 1) return const Color(0xFFECC94B); // Mañana - Amarillo
    if (difference <= 7) return const Color(0xFF4299E1); // Esta semana - Azul
    return const Color(0xFF48BB78); // Programada - Verde
  }

  String _getPriorityText(DateTime taskDate) {
    final now = DateTime.now();
    final taskDay = DateTime(taskDate.year, taskDate.month, taskDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = taskDay.difference(today).inDays;

    if (difference < 0) return 'Vencida';
    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Mañana';
    if (difference <= 7) return 'Próximos días';
    return 'Programada';
  }

  int _getCompletedTasksCount() {
    final today = DateTime.now();
    return globalTasks.where((task) {
      final taskDate = DateTime(
        task.createdAt.year,
        task.createdAt.month,
        task.createdAt.day,
      );
      final nowDate = DateTime(today.year, today.month, today.day);
      return taskDate.isBefore(nowDate);
    }).length;
  }

  int _getUpcomingTasksCount() {
    final today = DateTime.now();
    return globalTasks.where((task) {
      final taskDate = DateTime(
        task.createdAt.year,
        task.createdAt.month,
        task.createdAt.day,
      );
      final nowDate = DateTime(today.year, today.month, today.day);
      return taskDate.isAfter(nowDate);
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: const Text(
          'Mis Tareas',
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
        child: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(20),
              child: CupertinoSearchTextField(
                placeholder: 'Buscar tareas...',
                onChanged: (value) => setState(() => _searchQuery = value),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
              ),
            ),

            // Estadísticas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard(
                    icon: CupertinoIcons.list_bullet,
                    value: globalTasks.length.toString(),
                    label: 'Total',
                    color: const Color(0xFF5B67CA),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: CupertinoIcons.checkmark_circle_fill,
                    value: _getCompletedTasksCount().toString(),
                    label: 'Completadas',
                    color: const Color(0xFF38A169),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: CupertinoIcons.clock_fill,
                    value: _getUpcomingTasksCount().toString(),
                    label: 'Pendientes',
                    color: const Color(0xFFED8936),
                  ),
                ],
              ),
            ),

            // Lista de tareas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        itemCount: filteredTasks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          final originalIndex = globalTasks.indexOf(task);
                          final priorityColor = _getPriorityColor(
                            task.createdAt,
                          );
                          final priorityText = _getPriorityText(task.createdAt);

                          return _buildTaskItem(
                            task: task,
                            priorityColor: priorityColor,
                            priorityText: priorityText,
                            onDelete: () => _deleteTask(originalIndex),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem({
    required Task task,
    required Color priorityColor,
    required String priorityText,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoListTile(
        padding: const EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: priorityColor, width: 1.5),
          ),
          child: Icon(
            CupertinoIcons.doc_text_fill,
            size: 18,
            color: priorityColor,
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(task.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priorityText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          child: const Icon(
            CupertinoIcons.trash,
            size: 20,
            color: Color(0xFFE53E3E),
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: const Icon(
              CupertinoIcons.doc_text,
              size: 40,
              color: Color(0xFFA0AEC0),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            globalTasks.isEmpty
                ? 'No hay tareas'
                : 'No se encontraron resultados',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              globalTasks.isEmpty
                  ? 'Presiona el botón "+" para agregar tu primera tarea'
                  : 'Intenta con otro término de búsqueda',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
            ),
          ),
        ],
      ),
    );
  }
}
