import 'package:flutter/material.dart';

/// 增强版可折叠导航侧边栏
///
/// 新增功能：
/// 1. 支持监听行点击事件（通过 ValueNotifier<int>）
/// 2. 保留原有的展开/折叠控制功能
/// 3. 整行可点击区域
class CustomNavigationRail extends StatefulWidget {
  /// 导航项配置
  final List<NavigationRailDestination> destinations;

  /// 当前选中索引（双向绑定）
  final ValueNotifier<int> selectedIndexNotifier;

  /// 展开状态控制器
  final ValueNotifier<bool>? isExpandedNotifier;

  /// 折叠状态宽度
  final double collapsedWidth;

  /// 展开状态宽度
  final double expandedWidth;

  /// 初始展开状态
  final bool initiallyExpanded;

  const CustomNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndexNotifier,
    this.isExpandedNotifier,
    this.collapsedWidth = 72,
    this.expandedWidth = 200,
    this.initiallyExpanded = false,
  });

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  late ValueNotifier<bool> _isExpandedNotifier;

  @override
  void initState() {
    super.initState();
    _isExpandedNotifier = widget.isExpandedNotifier ?? ValueNotifier(widget.initiallyExpanded);
  }

  @override
  void dispose() {
    if (widget.isExpandedNotifier == null) {
      _isExpandedNotifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isExpandedNotifier,
      builder: (context, isExpanded, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? widget.expandedWidth : widget.collapsedWidth,
          child: ValueListenableBuilder<int>(
            valueListenable: widget.selectedIndexNotifier,
            builder: (context, selectedIndex, _) {
              return NavigationRail(
                destinations: widget.destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: _handleDestinationSelected,
                extended: isExpanded,
                labelType: isExpanded ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
                leading: InkWell(
                  onTap: _toggleExpansion,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Center(child: Icon(isExpanded ? Icons.arrow_back : Icons.menu)),
                  ),
                ),
                // useIndicator: true,
                elevation: 4,
                indicatorColor: Colors.deepOrangeAccent,
                indicatorShape: const CircleBorder(),
                selectedIconTheme: const IconThemeData(color: Colors.white),
                unselectedIconTheme: const IconThemeData(color: Colors.black),
              );
            },
          ),
        );
      },
    );
  }

  void _handleDestinationSelected(int index) {
    // 更新选中状态
    widget.selectedIndexNotifier.value = index;

    // 如果当前是折叠状态，点击后自动展开
    // if (!_isExpandedNotifier.value) {
    //   _isExpandedNotifier.value = true;
    // }
  }

  void _toggleExpansion() {
    _isExpandedNotifier.value = !_isExpandedNotifier.value;
  }
}
