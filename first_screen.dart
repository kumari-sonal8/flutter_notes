import 'package:blogs_flutter/login_screen.dart';
import 'package:blogs_flutter/setting_file.dart';
import 'package:blogs_flutter/setting_provider.dart';
import 'package:blogs_flutter/splash_screen.dart';
import 'package:blogs_flutter/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().getThemeValue();

    return MaterialApp(
      title: 'Flutter Notes App',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().getThemeValue();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Handle logout logic
              Navigator.pop(context); // or navigate to login screen
            },
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text("Settings"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // Drawer added
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Flutter Notes',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Register User'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
            ),
            ListTile(
              leading:const Icon(Icons.login),
              title:const Text('login'),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder:(context )=>LoginPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder:(context )=>DashboardScreen())); // or navigate to login screen
              },
            ),

          ],
        ),
      ),

      body: Container(width:double.infinity,height:double.infinity,child:Center(
        child:Column(

          children:[
            SizedBox(height:45),
            Text('!!welcome to dashboard!! ',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue,fontSize: 35),),
            SizedBox(height:11),
            Text('Note everything. Forget nothing.',style: TextStyle(fontSize: 25),),
              Text('  Fast. Simple. Reliable.',style: TextStyle(fontSize: 25),)
            
            
          ]
        ) ,
      ),
      ),
    );
  }
}
