import 'package:flutter/material.dart';
import 'package:sistemahospital/consultaPage.dart';
import 'package:sistemahospital/inicioPage.dart';
import 'package:sistemahospital/medicoPage.dart';
import 'package:sistemahospital/pacientePage.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: const Color.fromARGB(255, 232, 234, 222),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int selectedIndex = 0;
  bool _colorful = false;

  final List<Widget> _listOfWidget = <Widget>[
    const InicioPage(),
    const PacientePage(),
    const MedicoPage(),
    const ConsultaPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            child: SwitchListTile(
              title: const Text('APP HOSPITAL'),
              value: _colorful,
              onChanged: (bool value) {
                setState(() {
                  _colorful = !_colorful;
                });
              },
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _listOfWidget,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _colorful
          ? SlidingClippedNavBar.colorful(
              backgroundColor: Colors.white,
              onButtonPressed: onButtonPressed,
              iconSize: 30,
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  icon: Icons.home,
                  title: 'Inicio',
                  activeColor: Colors.blue,
                  inactiveColor: Colors.orange,
                ),
                BarItem(
                  icon: Icons.person,
                  title: 'Paciente',
                  activeColor: const Color.fromARGB(255, 255, 59, 248),
                  inactiveColor: Colors.green,
                ),
                BarItem(
                  icon: Icons.medical_services,
                  title: 'Medico',
                  activeColor: Colors.blue,
                  inactiveColor: Colors.red,
                ),
                BarItem(
                  icon: Icons.calendar_today,
                  title: 'Consulta',
                  activeColor: Colors.cyan,
                  inactiveColor: Colors.purple,
                ),
              ],
            )
          : SlidingClippedNavBar(
              backgroundColor: Colors.white,
              onButtonPressed: onButtonPressed,
              iconSize: 30,
              activeColor: const Color(0xFF01579B),
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  icon: Icons.home,
                  title: 'Inicio',
                ),
                BarItem(
                  icon: Icons.person,
                  title: 'Paciente',
                ),
                BarItem(
                  icon: Icons.medical_services,
                  title: 'Medico',
                ),
                BarItem(
                  icon: Icons.calendar_today,
                  title: 'Consulta',
                ),
              ],
            ),
    );
  }
}

List<Widget> _listOfWidget = <Widget>[
  Container(
    alignment: Alignment.center,
    child: const Icon(
      Icons.event,
      size: 56,
      color: Colors.brown,
    ),
  ),
  Container(
    alignment: Alignment.center,
    child: const Icon(
      Icons.search,
      size: 56,
      color: Colors.brown,
    ),
  ),
  Container(
    alignment: Alignment.center,
    child: const Icon(
      Icons.bolt,
      size: 56,
      color: Colors.brown,
    ),
  ),
  Container(
    alignment: Alignment.center,
    child: const Icon(
      Icons.tune_rounded,
      size: 56,
      color: Colors.brown,
    ),
  ),
];
/*return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('APP HOSPITAL'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.start_outlined),
              ),
              Tab(
                icon: Icon(Icons.person_3_outlined),
              ),
              Tab(
                icon: Icon(Icons.person_outline_sharp),
              ),
              Tab(
                icon: Icon(Icons.date_range),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            PacientePage(),
            PacientePage(),
            MedicoPage(),
            ConsultaPage()
          ],
        ),
      ),
    );*/
