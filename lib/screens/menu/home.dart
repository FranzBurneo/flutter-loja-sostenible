import 'package:flutter/material.dart';
import 'package:loja_sostenible/screens/screens.dart';
import 'package:loja_sostenible/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int _pageIndex = 0;


  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async {
            return await Navigator.maybePop(
              navigatorKeys[_pageIndex]!.currentState!.context
            );
          },
          child: IndexedStack(
            index: _pageIndex,
            children: [
              FeedScreen(
                navigatorKey: navigatorKeys[0]!
              ),
              OdsScreen(
                navigatorKey: navigatorKeys[1]!
              ),
              PerfilScreen(
                navigatorKey: navigatorKeys[2]!
              )
            ],
          ), 
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value){
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: AppTheme.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart_outlined),
            activeIcon: Icon(Icons.bubble_chart),
            label: 'ODS',
            backgroundColor: AppTheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined),
            activeIcon: Icon(Icons.person_pin),
            label: 'Perfil',
            backgroundColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}


