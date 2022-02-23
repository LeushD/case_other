import 'package:flutter/material.dart';

class NavigationDrawerScreen extends StatefulWidget {
  const NavigationDrawerScreen({Key? key}) : super(key: key);

  @override
  _NavigationDrawerScreenState createState() => _NavigationDrawerScreenState();
}

class _NavigationDrawerScreenState extends State<NavigationDrawerScreen> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/cart': (context) => const SecondScreen(),
      },
      scaffoldMessengerKey: _messengerKey,
//        home: Scaffold(
//          appBar: AppBar(),
//          drawer: navDrawer(context),
//          body: Center(child: Text("Содержимое экрана")),
//        )
    );
  }
}

final _messengerKey = GlobalKey<ScaffoldMessengerState>();

void showSnackBar(String snackText) {
  _messengerKey.currentState!.showSnackBar(
      SnackBar(content: Text(snackText))
  );
}

Widget navDrawer(context) => Drawer(

  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0))
              ),
              child: Image.network(""),
            ),
            const Text("Навигация"),
          ],
        ),
      ),
      ListTile(
        leading: const Icon(Icons.book),
        title: const Text("Каталог"),
        onTap: () {
          //showSnackBar("Вы выбрали каталог");
          Navigator.pushNamed(context, '/');
        },
      ),
      ListTile(
        leading: const Icon(Icons.shopping_cart),
        title: const Text("Корзина"),
        onTap: () {
          //showSnackBar("Вы выбрали корзину");
          Navigator.pushNamed(context, '/cart');
        },
      ),
      const Divider(),
      const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text("Профиль"),
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("Настройки"),
        onTap: () {
          showSnackBar("Тут должны быть настройки");
        },
      ),
    ],
  ),
);

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Главная'),
          actions: <Widget>[
            TextButton(
              style: buttonStyle,
              onPressed: () {
                showSnackBar("Вы нажали кнопку профиля");
              },
              child: const Text("Профиль"),
            ),
            IconButton(
                tooltip: "Уведомления",
                onPressed: () {
                  showSnackBar("Вы нажали кнопку уведомлений");
                },
                icon: const Icon(Icons.notifications)),
          ]
      ),
      drawer: navDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Case 2.3"),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      drawer: navDrawer(context),
      body: const Center(
          child: Text("Тут должна быть корзина, и в ней нет кнопок в AppBar")
      ),
    );
  }
}
