import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth2/presentation/main_pages/images_page.dart';
import 'package:flutter/material.dart';

import '../data/models/profile.dart';
import 'main_pages/add_page.dart';
import 'main_pages/profile_page.dart';
import 'main_pages/view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ViewPage(),
    AddPage(),
    ImagesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Profile?;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomNavBar(context, args),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavBar(BuildContext context, Profile? profile) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      //selectedItemColor: Theme.of(context).colorScheme.tertiary,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Добавить',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_outlined),
          label: 'Картинки',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin_outlined),
          label: 'Профиль',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
