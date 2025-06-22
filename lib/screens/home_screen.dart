import 'package:flutter/cupertino.dart';
import 'register_user_screen.dart';
import 'register_task_screen.dart';
import 'task_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String password;

  const HomeScreen({super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Color de fondo más suave
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.white,
        activeColor: const Color(0xFF5B67CA), // Color azul más vibrante
        inactiveColor: const Color(0xFFA0AEC0), // Color gris más claro
        border: const Border(
          top: BorderSide(
            color: Color(0xFFEDF2F7), // Borde más suave
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person_alt_circle_fill,
            ), // Icono más moderno
            activeIcon: Icon(
              CupertinoIcons.person_alt_circle_fill,
              size: 28,
            ), // Icono más grande cuando está activo
            label: 'Usuario',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.plus_circle_fill,
            ), // Icono más consistente
            activeIcon: Icon(CupertinoIcons.plus_circle_fill, size: 28),
            label: 'Nueva Tarea',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.checkmark_seal_fill,
            ), // Icono más representativo
            activeIcon: Icon(CupertinoIcons.checkmark_seal_fill, size: 28),
            label: 'Mis Tareas',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return RegisterUserScreen(
                  username: username,
                  password: password,
                );
              case 1:
                return const RegisterTaskScreen();
              case 2:
                return const TaskListScreen();
              default:
                return Center(
                  child: Text(
                    'Pantalla no encontrada',
                    style: TextStyle(
                      fontSize: 18,
                      color: CupertinoColors.systemGrey,
                      fontWeight: FontWeight.w500, // Texto un poco más grueso
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
