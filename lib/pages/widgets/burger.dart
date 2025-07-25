import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';

class BurgerMenu extends StatefulWidget implements PreferredSizeWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const BurgerMenu(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  _BurgerMenuState createState() => _BurgerMenuState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _BurgerMenuState extends State<BurgerMenu> {
  static double imgSize = 22;

  final List<String> _titles = [
    'Ogłoszenia',
    'Aktualnie grane',
    'Lista piosenek',
    'Informator',
    'Kontakt',
    'Zdjęcia',
    'Użytkownicy',
    'Pomoc'
  ];

  final List<String> _imagePaths = [
    './images/announcement.png',
    './images/sound.png',
    './images/list.png',
    './images/information.png',
    './images/phone.png',
    './images/images.png',
    './images/users.png',
    './images/about.png'
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;

    Container listTile(isSelected, index) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: isSelected
                          ? Colors.black
                          : LIST_TILE_INACTIVE_COLOR))),
          child: ListTile(
            selected: isSelected,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            leading: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : LIST_TILE_INACTIVE_COLOR,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                _imagePaths[index],
                width: imgSize,
              ),
            ),
            title: Text(
              _titles[index],
              style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.black : LIST_TILE_INACTIVE_COLOR,
                  fontFamily: 'Lexend'),
            ),
            onTap: () {
              widget.onItemTapped(index);
              print(widget.selectedIndex);
            },
          ));
    }

    return Drawer(
        width: 220,
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border:
                        const Border(bottom: BorderSide(color: Colors.black))),
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.062,
                          top: statusBar + 9,
                          bottom: 20),
                      child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            './images/burger-bar-black.png',
                            width: 25,
                          )))
                ])),
            ...List.generate(_titles.length - 1, (index) {
              bool isSelected = widget.selectedIndex == index;
              return listTile(isSelected, index);
            }),
            const Spacer(),
            listTile(widget.selectedIndex == _titles.length - 1 ? true : false,
                _titles.length - 1),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Center(
                    child: Text('Icons by Icons8',
                        style: TextStyle(
                            fontFamily: 'Lexend',
                            color: LIST_TILE_INACTIVE_COLOR,
                            fontSize: 10))))
          ],
        ));
  }
}
