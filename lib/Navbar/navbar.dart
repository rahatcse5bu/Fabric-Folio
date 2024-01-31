import 'package:flutter/material.dart';
import 'package:nuriya_tailers/constants/colors.dart';

import '../About Us/aboutUs.dart';
import '../Orders/Orders.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [

    //  Orders(),
    //  Orders(),
   const  Orders(),
     AboutUs(),
    // const addOrder(),
    // const Customers(),
    //  AboutUs(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

@override
void initState() {
    // TODO: implement initState
    super.initState();
    // print("Page=================>");
    // print(_page.toString());
    // print(pages[_page].toString());
    setState(() {
      _page=0 ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.primaryColor,
        unselectedItemColor: GlobalVariables.secondaryColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.primaryColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.line_style_outlined,
              ),
            ),
            label: '',
          ),

          //Analytics
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.primaryColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.people_outline_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
