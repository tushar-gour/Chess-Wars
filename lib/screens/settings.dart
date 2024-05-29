import 'package:chess/values/colors.dart';
import 'package:chess/values/globals.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int chess_mins = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
        child: Column(
          children: [
            Container(
              height: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: darkTileColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  Text(
                    'Player Time (Mins):',
                    style: TextStyle(
                      color: backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Changa",
                      fontSize: 25,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 80,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        dropdownColor: lightTileColor,
                        value: chess_mins,
                        menuMaxHeight: 300,
                        items: chess_time_list
                            .map((time) {
                              return DropdownMenuItem(
                                value: time,
                                child: Text(
                                  time.toString(),
                                  style: TextStyle(
                                    color: backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Changa",
                                    fontSize: 25,
                                  ),
                                ),
                              );
                            })
                            .toSet()
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            chess_mins = newValue!;
                            CHESS_TIME = newValue * 60;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
