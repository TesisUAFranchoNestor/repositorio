import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex
  });

  void onItemTapped(BuildContext context, int index){
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      elevation: 0,
      selectedItemColor: colors.primary,

      onTap: (value) {
        onItemTapped(context, value);
      },
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Reservas',    
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Perfil'
        ),
      ],
    );
  }
}