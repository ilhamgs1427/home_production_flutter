import 'package:flutter/material.dart';
import 'package:home_production/Pages/beranda.dart';
import 'package:home_production/Pages/profile.dart';
import 'package:home_production/Pages/riwayat.dart';
import 'package:home_production/constans.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  onTapppedItem(int i) {
    setState(() {
      currentIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      // Menu Home

      beranda(),
      // Menu Riwayat Pesanan
      riwayatPage(),

      // Menu Profile
      ProfilePage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        body: widgets[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primaryButtonColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: currentIndex,
          onTap: onTapppedItem,
          unselectedItemColor: whiteColor,
          selectedItemColor: Colors.blue[200],
        ),
      ),
    );
  }
}
