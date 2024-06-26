import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class PlutoMenuBar extends StatefulWidget {
  /// Pass [MenuItem] to List.
  /// create submenus by continuing to pass MenuItem to children as a List.
  ///
  /// ```dart
  /// MenuItem(
  ///   title: 'Menu 1',
  ///   children: [
  ///     MenuItem(
  ///       title: 'Menu 1-1',
  ///       onTap: () => print('Menu 1-1 tap'),
  ///     ),
  ///   ],
  /// ),
  /// ```
  final List<MenuItem> menus;

  /// Text of the back button. (default. 'Go back')
  final String goBackButtonText;

  /// menu height. (default. '45')
  final double height;

  /// BackgroundColor. (default. 'white')
  final Color backgroundColor;

  /// Border color. (default. 'black12')
  final Color borderColor;

  /// menu icon color. (default. 'black54')
  final Color menuIconColor;

  /// menu icon size. (default. '20')
  final double menuIconSize;

  /// more icon color. (default. 'black54')
  final Color moreIconColor;

  /// Enable gradient of BackgroundColor. (default. 'true')
  final bool gradient;

  /// [TextStyle] of Menu title.
  final TextStyle textStyle;

  PlutoMenuBar({
    this.menus,
    this.goBackButtonText = 'Go back',
    this.height = 45,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black12,
    this.menuIconColor = Colors.black54,
    this.menuIconSize = 20,
    this.moreIconColor = Colors.black54,
    this.gradient = true,
    this.textStyle = const TextStyle(),
  })  : assert(menus != null),
        assert(menus.length > 0);

  @override
  _PlutoMenuBarState createState() => _PlutoMenuBarState();
}

class _PlutoMenuBarState extends State<PlutoMenuBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) {
        return Container(
          width: size.minWidth,
          height: widget.height,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.menus.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return _MenuWidget(
                widget.menus[index],
                goBackButtonText: widget.goBackButtonText,
                height: widget.height,
                backgroundColor: widget.backgroundColor,
                menuIconColor: widget.menuIconColor,
                menuIconSize: widget.menuIconSize,
                moreIconColor: widget.moreIconColor,
                textStyle: widget.textStyle,
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItem {
  /// Menu title
  final String title;

  final IconData icon;

  /// Callback executed when a menu is tapped
  final Function() onTap;

  /// Passing [MenuItem] to a [List] creates a sub-menu.
  final List<MenuItem> children;

  MenuItem({
    this.title,
    this.icon,
    this.onTap,
    this.children,
  }) : _key = GlobalKey();

  MenuItem._back({
    this.title,
    this.icon,
    this.onTap,
    this.children,
  })  : _key = GlobalKey(),
        _isBack = true;

  GlobalKey _key;

  bool _isBack = false;

  Offset get _position {
    RenderBox box = _key.currentContext.findRenderObject();

    return box.localToGlobal(Offset.zero);
  }

  bool get _hasChildren => children != null && children.length > 0;
}

class _MenuWidget extends StatelessWidget {
  final MenuItem menu;

  final String goBackButtonText;

  final double height;

  final Color backgroundColor;

  final Color menuIconColor;

  final double menuIconSize;

  final Color moreIconColor;

  final TextStyle textStyle;

  _MenuWidget(
      this.menu, {
        this.goBackButtonText,
        this.height,
        this.backgroundColor,
        this.menuIconColor,
        this.menuIconSize,
        this.moreIconColor,
        this.textStyle,
      }) : super(key: menu._key);

  Widget _buildPopupItem(MenuItem _menu) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_menu.icon != null) ...[
          Icon(
            _menu.icon,
            color: menuIconColor,
            size: menuIconSize,
          ),
          SizedBox(
            width: 5,
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              _menu.title,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        if (_menu._hasChildren && !_menu._isBack)
          Icon(
            Icons.arrow_right,
            color: moreIconColor,
          ),
      ],
    );
  }

  Future<MenuItem> _showPopupMenu(
      BuildContext context,
      List<MenuItem> menuItems,
      ) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    final Offset position = menu._position + Offset(0, height - 11);

    return await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width,
        overlay.size.height,
      ),
      items: menuItems.map((menu) {
        return PopupMenuItem<MenuItem>(
          value: menu,
          child: _buildPopupItem(menu),
        );
      }).toList(),
      // elevation: 2.0,
      color: backgroundColor,
    );
  }

  Widget _getMenu(
      BuildContext context,
      MenuItem menu,
      ) {
    Future<MenuItem> _getSelectedMenu(
        MenuItem menu, {
          MenuItem previousMenu,
          int stackIdx,
          List<MenuItem> stack,
        }) async {
      if (!menu._hasChildren) {
        return menu;
      }

      final items = [...menu.children];

      if (previousMenu != null) {
        items.add(MenuItem._back(
          title: goBackButtonText,
          children: previousMenu.children,
        ));
      }

      MenuItem _selectedMenu = await _showPopupMenu(
        context,
        items,
      );

      if (_selectedMenu == null) {
        return null;
      }

      MenuItem _previousMenu = menu;

      if (!_selectedMenu._hasChildren) {
        return _selectedMenu;
      }

      if (_selectedMenu._isBack) {
        --stackIdx;
        if (stackIdx < 0) {
          _previousMenu = null;
        } else {
          _previousMenu = stack[stackIdx];
        }
      } else {
        if (stackIdx == null) {
          stackIdx = 0;
          stack = [menu];
        } else {
          stackIdx += 1;
          stack.add(menu);
        }
      }

      return await _getSelectedMenu(
        _selectedMenu,
        previousMenu: _previousMenu,
        stackIdx: stackIdx,
        stack: stack,
      );
    }

    return InkWell(
      onTap: () async {
        if (menu._hasChildren) {
          MenuItem selectedMenu = await _getSelectedMenu(menu);

          if (selectedMenu?.onTap != null) {
            selectedMenu.onTap();
          }
        } else if (menu?.onTap != null) {
          menu.onTap();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (menu.icon != null) ...[
              Stack(
                clipBehavior: Clip.none, children: [
                Icon(menu.icon, size: menuIconSize,color: menuIconColor,),
                menu.title.isEmpty? Positioned(
                  top: -7, right: -7,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        Provider.of<CartProvider>(context).cartList.length.toString(),
                        style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: 8),
                      ),
                    ),
                  ),
                ):SizedBox()
              ],
              ),

              SizedBox(
                width: 5,
              ),
            ],
            Text(
              menu.title,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getMenu(context, menu);
  }
}
