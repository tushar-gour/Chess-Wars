import 'package:chess/screens/main_game.dart';
import 'package:chess/screens/settings.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  void navigateToGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameBoard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/gamelogo.png'),
          SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: navigateToGame,
              child: Ink(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    'P L A Y',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Changa",
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: navigateToSettings,
              child: Ink(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Changa",
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
