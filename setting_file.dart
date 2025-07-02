import 'dart:async';

import 'package:blogs_flutter/setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Settings'),
      ),
      body: Consumer< ThemeProvider>(
        builder: (_, provider, _) {
          return SwitchListTile.adaptive(
            title:  Text('Dark Mode'),
            subtitle: Text('Change theme mode here'),

              onChanged: (value) {

               provider.updateTheme(value:value);
           },
            value: provider.getThemeValue(),


          );
        },
      ),
    );
  }
}