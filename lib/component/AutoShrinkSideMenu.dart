import 'package:flutter/material.dart';
import 'package:god_helper/extend.dart';

/// 自动侧边收缩菜单
class AutoShrinkSideMenu extends StatefulWidget {
  /// 展开状态控制器
  final ValueNotifier<bool>? isExpandedNotifier;

  /// 当前选中索引（双向绑定）
  final ValueNotifier<int>? selectedIndexNotifier;

  /// 折叠状态宽度
  final double collapsedWidth;

  /// 展开状态宽度
  final double expandedWidth;

  /// 初始展开状态
  final bool initiallyExpanded;

  final List<ShrinkMenuItemData> menuItems;

  /// 合并UI
  final MenuItemInvoke? collapsedWidget;

  /// 展开UI
  final MenuItemInvoke? expandedWidget;

  final Function(ShrinkMenuItemData itemData, int index)? onMenuItemClickListener;

  final Color? selectItemColor;

  const AutoShrinkSideMenu({
    super.key,
    this.isExpandedNotifier,
    required this.selectedIndexNotifier,
    required this.menuItems,
    this.collapsedWidth = 72,
    this.expandedWidth = 180,
    this.initiallyExpanded = false,
    this.collapsedWidget,
    this.expandedWidget,
    this.onMenuItemClickListener,
    this.selectItemColor,
  });

  @override
  State<AutoShrinkSideMenu> createState() => _AutoShrinkSideMenuState();
}

class _AutoShrinkSideMenuState extends State<AutoShrinkSideMenu> {
  late ValueNotifier<bool> _isExpandedNotifier;
  late ValueNotifier<int> _selectedIndexNotifier;

  List<ShrinkMenuItemData> get _menuItems => widget.menuItems;

  Color get _selectColor => widget.selectItemColor ?? Colors.deepOrangeAccent;

  @override
  void initState() {
    super.initState();
    _isExpandedNotifier = widget.isExpandedNotifier ?? ValueNotifier(widget.initiallyExpanded);
    _selectedIndexNotifier = widget.selectedIndexNotifier ?? ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      child: _buildValueBind((isExpanded, selectedIndex) {
        return Column(
          children: [
            InkWell(
              onTap: _toggleExpansion,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Center(child: Icon(isExpanded ? Icons.arrow_back : Icons.menu)),
              ),
            ),
            Expanded(
              child: _buildMenuList(isExpanded, selectedIndex),
            ),
          ],
        );
      }),
    );
  }

  /// 构建和数据绑定，通过数据绑定相应界面变化
  Widget _buildValueBind(Function(bool isExpanded, int selectedIndex) child) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isExpandedNotifier,
      builder: (context, isExpanded, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? widget.expandedWidth : widget.collapsedWidth,
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndexNotifier,
            builder: (context, selectedIndex, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // 这里添加宽度判断，当动画完全展开时，再渲染列表动画的修改
                  var ie = isExpanded && (constraints.maxWidth == widget.expandedWidth);
                  return child(ie, selectedIndex);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _toggleExpansion() {
    _isExpandedNotifier.value = !_isExpandedNotifier.value;
  }

  /// 构建菜单列表
  Widget _buildMenuList(bool isExpanded, int selectedIndex) {
    return ListView.separated(
      itemBuilder: (context, index) => InkWell(
        child: _buildMenuItemWidget(index, isExpanded, selectedIndex == index),
        onTap: () {
          _selectedIndexNotifier.value = index;
          widget.onMenuItemClickListener?.call(_menuItems[index], index);
        },
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemCount: _menuItems.length,
    );
  }

  /// 构建菜单列表的菜单
  /// 根据行id
  Widget _buildMenuItemWidget(int index, bool isExpanded, bool isSelect) {
    var menuItem = _menuItems[index];
    if (isExpanded) {
      /// 展开状态
      return (widget.expandedWidget ?? _buildMenuItemWidgetGen(true)).call(menuItem, isSelect);
    } else {
      /// 合起来时界面
      return (widget.collapsedWidget ?? _buildMenuItemWidgetGen(false)).call(menuItem, isSelect);
    }
  }

  /// 单行界面构建
  MenuItemInvoke _buildMenuItemWidgetGen(bool isExpanded) {
    Widget itemIconWidget(Icon icon, bool isSelect) {
      return Container(
        width: 45,
        height: 45,
        child: Icon(icon.icon, color: isSelect ? Colors.white : Colors.black),
      );
    }

    if (isExpanded) {
      // 展开状态
      return (ShrinkMenuItemData itemData, bool isSelect) {
        return Container(
          color: isSelect ? _selectColor : null,
          child: Row(
            children: [
              itemIconWidget(itemData.icon, isSelect),
              Expanded(
                child: Center(
                  child: Text(
                    itemData.name,
                    style: context.app.baseFont.copyWith(
                      color: isSelect ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      };
    } else {
      // 合并状态
      return (ShrinkMenuItemData itemData, bool isSelect) {
        return Container(
          color: isSelect ? _selectColor : null,
          child: itemIconWidget(itemData.icon, isSelect),
        );
      };
    }
  }
}

typedef MenuItemInvoke = Widget Function(ShrinkMenuItemData itemData, bool isSelect);

class ShrinkMenuItemData {
  final String name;
  final Icon icon;
  final Widget? child;

  ShrinkMenuItemData({
    required this.name,
    required this.icon,
    this.child,
  });
}
