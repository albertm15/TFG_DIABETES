import 'package:diabetes_tfg_app/pages/DayChartsPage.dart';
import 'package:diabetes_tfg_app/pages/WeekChartsPage.dart';
import 'package:diabetes_tfg_app/pages/monthChartsPage.dart';
import 'package:diabetes_tfg_app/pages/trimesterChartsPage.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class AllChartsPage extends StatefulWidget {
  @override
  _AllChartsPageState createState() => _AllChartsPageState();
}

class _AllChartsPageState extends State<AllChartsPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Graficos"),
      body: ScreenMargins(
          child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                Center(child: DayChartsPage()),
                Center(child: WeekChartsPage()),
                Center(child: MonthChartsPage()),
                Center(child: TrimesterChartsPage()),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          PageIndicator(selectedPage: currentIndex)
        ],
      )),
      bottomNavigationBar: LowerNavBar(selectedSection: "glucose"),
      backgroundColor: Colors.transparent,
    );
  }
}

class PageIndicator extends StatelessWidget {
  final selectedPage;
  const PageIndicator({required this.selectedPage});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: selectedPage == 0 ? 16 : 10,
          height: selectedPage == 0 ? 16 : 10,
          decoration: BoxDecoration(
            color: selectedPage == 0
                ? Color.fromARGB(255, 85, 42, 196)
                : Color.fromARGB(255, 143, 143, 143),
            shape: BoxShape.circle,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: selectedPage == 1 ? 16 : 10,
          height: selectedPage == 1 ? 16 : 10,
          decoration: BoxDecoration(
            color: selectedPage == 1
                ? Color.fromARGB(255, 85, 42, 196)
                : const Color.fromARGB(255, 143, 143, 143),
            shape: BoxShape.circle,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: selectedPage == 2 ? 16 : 10,
          height: selectedPage == 2 ? 16 : 10,
          decoration: BoxDecoration(
            color: selectedPage == 2
                ? Color.fromARGB(255, 85, 42, 196)
                : Color.fromARGB(255, 143, 143, 143),
            shape: BoxShape.circle,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: selectedPage == 3 ? 16 : 10,
          height: selectedPage == 3 ? 16 : 10,
          decoration: BoxDecoration(
            color: selectedPage == 3
                ? Color.fromARGB(255, 85, 42, 196)
                : Color.fromARGB(255, 143, 143, 143),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
