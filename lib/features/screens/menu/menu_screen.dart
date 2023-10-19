import 'package:flutter/material.dart';
import 'package:veler/features/screens/home/home_screen.dart';
import 'package:veler/features/screens/reservations/reservations_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List body = const [HomeScreen(), ReservationScreen()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore_rounded,
                size: 30,
                color: _currentIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.tertiary,
              ),
              label: "Discover"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_rounded,
                size: 30,
                color: _currentIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.tertiary,
              ),
              label: "Reservations"),
        ],
      ),
      body: body[_currentIndex],
    );
  }
}
