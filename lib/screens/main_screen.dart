
import 'package:flutter/material.dart';
import 'package:tasky/screens/home_screen.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';
import 'complete_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

final List<Widget> _screen = [
HomeScreen(name: '',),
TasksScreen(),
CompleteTasksScreen(),
ProfileScreen(),

];

int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // =====================================================
      // Bottom Navigation
      // =====================================================

      bottomNavigationBar:
      BottomNavigationBar(

        backgroundColor:
        const Color(0xFF181818),

        // بنخلي كل الـ items ظاهرين
        type: BottomNavigationBarType.fixed,


        // لون الـ item المختار
        selectedItemColor:
        const Color(0xFF00D084),


        // لون الـ items اللي مش مختارة
        unselectedItemColor:
        Colors.white70,


        currentIndex: _currentIndex,

         onTap: (int? index) {
         setState(() { 
          _currentIndex = index ?? 0;
          });
         },



        showSelectedLabels: true,
        showUnselectedLabels: true,

        selectedFontSize: 9,
        unselectedFontSize: 9,


        // عناصر الـ Bottom Navigation
        items: const [

          // Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon:
            Icon(Icons.home),
            label: "Home",
          ),


          // To Do
          BottomNavigationBarItem(
            icon:
            Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: "To Do",
          ),


          // Completed
          BottomNavigationBarItem(
            icon:
            Icon(Icons.fact_check_outlined),
            activeIcon: Icon(Icons.check_circle),
            label: "Completed",
          ),


          // Profile
          BottomNavigationBarItem(
            icon:
            Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
   
   body: _screen[_currentIndex],
    );
  }
}