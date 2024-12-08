import 'package:flutter/material.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/res/app.dart';

class CardButton extends StatefulWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final double? borderRadius;
  final GestureLongPressCallback? onLongPress;

  const CardButton({super.key, this.child, this.onTap, this.borderRadius, this.onLongPress});

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  // final Color _buttonColor = const Color.fromARGB(225, 217, 255, 139);
  final Color _buttonWaterColor = const Color.fromARGB(225, 106, 255, 0);
  final Color _buttonClickColor = const Color.fromARGB(225, 139, 185, 255);

  get _borderRadius => widget.borderRadius;

  @override
  Widget build(BuildContext context) {
    // var brg = getBorderRadiusGeometry();
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      splashColor: _buttonWaterColor,
      highlightColor: _buttonClickColor,
      borderRadius: getBorderRadiusGeometry(),
      child: widget.child,
    );
  }

  BorderRadius? getBorderRadiusGeometry() {
    return null != _borderRadius
        ? BorderRadius.circular(_borderRadius)
        // : BorderRadius.circular(16);
        : null;
  }
}

class WitchExtraRuleView extends StatefulWidget {
  final WitchSelfSaveRuleType defaultValue;
  final bool isPreview;
  final Function(WitchSelfSaveRuleType type) onChange;

  const WitchExtraRuleView({
    super.key,
    this.defaultValue = WitchSelfSaveRuleType.ALL_NOT_SAVE,
    this.isPreview = false,
    required this.onChange,
  });

  @override
  State<WitchExtraRuleView> createState() => _WitchExtraRuleViewState();
}

class _WitchExtraRuleViewState extends State<WitchExtraRuleView> {
  WitchSelfSaveRuleType _select = WitchSelfSaveRuleType.ALL_NOT_SAVE;

  @override
  void initState() {
    super.initState();
    _select = widget.defaultValue;
  }

  // 处理单选按钮的选择
  void _handleRadioValueChange(WitchSelfSaveRuleType value) {
    setState(() {
      _select = value;
      widget.onChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: 200,
      color: Colors.black12,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "女巫:",
              style: App.of(context).font.base.copyWith(fontSize: 20),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "自救规则:",
              style: App.of(context).font.base.copyWith(fontSize: 14),
            ),
          ),
          RadioGroup(
            config: RadioConfig<WitchSelfSaveRuleType>.list(
              selectItem: WitchSelfSaveRuleType.values,
              defaultValue: _select,
              selectable: !widget.isPreview,
              showText: (value) => value.desc,
              callback: (value) => _handleRadioValueChange(value),
            ),
          ),
        ],
      ),
    );
  }
}

/// 圆形按钮
class CircleButton extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final double size;
  final double padding;
  final Color? color;
  final bool clickable;
  final double elevation;

  const CircleButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = 35,
    this.padding = 0,
    this.color,
    this.clickable = true,
    this.elevation = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(size / 2),
          elevation: elevation,
          color: color, // 背景色
          child: InkWell(
            onTap: clickable ? onTap : null,
            borderRadius: BorderRadius.circular(size / 2),
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size / 2), // 圆角
              ),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final double circleSize;
  final Widget child;
  final double elevation;
  final Color? color;

  const Circle({
    super.key,
    required this.child,
    this.circleSize = 35,
    this.elevation = 2.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleSize + elevation,
      width: circleSize + elevation,
      padding: EdgeInsets.all(elevation),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circleSize),
      ),
      child: Material(
        color: color,
        elevation: elevation,
        borderRadius: BorderRadius.circular(circleSize),
        child: Center(child: child),
      ),
    );
  }
}

class SelectConfig<T> {
  final double circleSize;

  /// 可选范围，如果为空，则不设置
  final List<int> selectableList;

  final Callback<T> callback;

  final String selectableListEmptyTip;

  /// 是否可以进行选择
  /// 默认是可以的，但存在一种情况，在用户确认选择后，不允许修改的情况下，需要禁止可选
  final bool selectable;

  /// 默认选择
  /// 如果玩家id小于0 则表示没有选择
  final T defaultSelect;

  /// 如果是多选的情况下，设置最多选择多少个选项
  final int maxSelect;

  /// 多选时，是否显示结果

  SelectConfig({
    required this.selectableList,
    required this.defaultSelect,
    required this.callback,
    this.circleSize = 40,
    this.selectableListEmptyTip = "可选择列表为空。",
    this.selectable = true,
    this.maxSelect = 0,
  });

  factory SelectConfig.forCount({
    required int count,
    required T defaultSelect,
    required Callback<T> callback,
    double circleSize = 40,
    String selectableListEmptyTip = "可选择列表为空。",
    bool selectable = true,
    int maxSelect = 0,
    bool multiShowResultView = true,
  }) {
    return SelectConfig<T>(
      selectableList: List.generate(count, (index) => index + 1),
      defaultSelect: defaultSelect,
      callback: callback,
      circleSize: circleSize,
      selectableListEmptyTip: selectableListEmptyTip,
      selectable: selectable,
      maxSelect: maxSelect,
    );
  }
}

/// 玩家选择按钮
/// 带弹窗
class PlayerSingleSelectButton extends StatefulWidget {
  final SelectConfig<int> selectConfig;

  const PlayerSingleSelectButton({
    super.key,
    required this.selectConfig,
  });

  factory PlayerSingleSelectButton.forPlayerCount({
    required int count,
    required Callback<int> callback,
    double circleSize = 40,
    bool selectable = true,
    int defaultSelect = 0,
  }) {
    return PlayerSingleSelectButton(
      selectConfig: SelectConfig<int>(
        selectableList: List.generate(count, (index) => index + 1),
        callback: callback,
        circleSize: circleSize,
        selectable: selectable,
        defaultSelect: defaultSelect,
      ),
    );
  }

  factory PlayerSingleSelectButton.initConfig({required SelectConfig<int> config}) {
    return PlayerSingleSelectButton(
      selectConfig: config,
    );
  }

  @override
  State<PlayerSingleSelectButton> createState() => PlayerSingleSelectButtonState();
}

class PlayerSingleSelectButtonState extends State<PlayerSingleSelectButton> {
  int selectIndex = 0;

  /// 可选范围，如果为空，则不设置
  List<int> get _selectableList => widget.selectConfig.selectableList;

  Callback<int> get _callback => widget.selectConfig.callback;

  double get _circleSize => widget.selectConfig.circleSize;

  @override
  void initState() {
    super.initState();
    selectIndex = widget.selectConfig.defaultSelect;
  }

  @override
  Widget build(BuildContext context) {
    return widget.selectConfig.selectable
        ? CircleButton(
            size: _circleSize,
            onTap: () => _showDialog(),
            child: _getSelectWidget(),
          )
        : Circle(
            circleSize: _circleSize,
            child: _getSelectWidget(),
          );
  }

  final _isShow = IsShowState();

  void _showDialog() async {
    if (_selectableList.isEmpty) {
      showSnackBarMessage(
        widget.selectConfig.selectableListEmptyTip,
        isShow: _isShow,
      );
      return;
    }
    var state = GamePlayersSingleSelectDialogContentWidgetState();
    var index = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("选择玩家"),
        content: GamePlayersSingleSelectDialogContentWidget(
          playerCount: 10,
          state: state,
          defaultSelectIndex: selectIndex,
          selectList: _selectableList,
        ),
        actions: [
          TextButton(
            onPressed: () {
              state.clear();
              // Navigator.of(context).pop(true);
            },
            child: const Text("清空配置"),
          ),
          TextButton(
            onPressed: () {
              // if (kDebugMode) {
              //   print("返回：${state.selectIndex}");
              // }
              // 关闭选择框
              Navigator.of(context).pop(state.selectIndex);
            },
            child: const Text("确认配置"),
          ),
        ],
      ),
    ) as int?;

    if (index != null) {
      selectIndex = index;
      _callback(selectIndex);
      setState(() {});
    }
  }

  Widget _getSelectWidget() {
    return selectIndex > 0
        ? Text(
            "P$selectIndex",
            style: app.baseFont.copyWith(fontSize: _circleSize * 2 / 5),
          )
        : Icon(Icons.add, size: _circleSize / 2);
  }
}

class PlayerMultiSelectButton extends StatefulWidget {
  final SelectConfig<List<int>> selectConfig;

  const PlayerMultiSelectButton({
    super.key,
    required this.selectConfig,
  });

  factory PlayerMultiSelectButton.forPlayerCount({
    required int playerCount,
    required Callback<List<int>> callback,
    required List<int> defaultSelect,
    int maxSelect = 0,
    double circleSize = 36,
  }) {
    return PlayerMultiSelectButton(
      selectConfig: SelectConfig<List<int>>(
        selectableList: List.generate(playerCount, (index) => index + 1),
        defaultSelect: defaultSelect,
        callback: callback,
        maxSelect: maxSelect,
        circleSize: circleSize,
      ),
    );
  }

  factory PlayerMultiSelectButton.forConfig({
    required SelectConfig<List<int>> config,
  }) {
    return PlayerMultiSelectButton(
      selectConfig: config,
    );
  }

  @override
  State<PlayerMultiSelectButton> createState() => _PlayerMultiSelectButtonState();
}

class _PlayerMultiSelectButtonState extends State<PlayerMultiSelectButton> {
  List<int> get selectableList => widget.selectConfig.selectableList;

  Callback<List<int>> get callback => widget.selectConfig.callback;

  int get maxSelect => widget.selectConfig.maxSelect;

  double get circleSize => widget.selectConfig.circleSize;

  List<int> selectList = [];

  @override
  void initState() {
    super.initState();
    selectList = widget.selectConfig.defaultSelect;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: circleSize + 1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Circle(child: _selectItemWidget(index)),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: widget.selectConfig.maxSelect > 0 ? widget.selectConfig.maxSelect : selectList.length,
          ),
        ),
      ),
      if (widget.selectConfig.selectable)
        Expanded(
          flex: 0,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(60),
            color: Colors.white,
            child: CircleButton(
              size: circleSize,
              onTap: () => _showDialog(),
              child: Icon(Icons.add, size: circleSize / 2),
            ),
          ),
        ),
    ]);
  }

  void _showDialog() async {
    var state = GamePlayersMultiSelectDialogContentWidget.newState();
    state.selectList.addAll(selectList);
    await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("选择玩家"),
            content: GamePlayersMultiSelectDialogContentWidget(
              playerCount: 10,
              state: state,
              selectableList: selectableList,
              selectMax: maxSelect,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  state.clear();
                  // Navigator.of(context).pop(true);
                },
                child: const Text("清空配置"),
              ),
              TextButton(
                onPressed: () {
                  var list = state.selectList;
                  selectList.clear();
                  if (list.isNotEmpty) selectList.addAll(list);
                  selectList.sort();
                  // 通知组件更新
                  callback(selectList);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text("确认配置"),
              ),
            ],
          ),
        ) as List<int>? ??
        List.empty();
  }

  Widget _selectItemWidget(int index) {
    var list = widget.selectConfig.selectable ? selectList : widget.selectConfig.defaultSelect;
    var item = index < list.length ? list[index] : null;
    if (item != null) {
      return Text(
        "P$item",
        style: app.baseFont.copyWith(fontSize: circleSize * 2 / 5),
      );
    } else {
      return Icon(Icons.whatshot, size: circleSize / 2);
    }
  }
}

/// 玩家选择弹窗选择器内容
/// 多选
class GamePlayersMultiSelectDialogContentWidget extends StatefulWidget {
  final int playerCount;
  final _GamePlayersMultiSelectDialogContentWidgetState state;

  /// 选择上限，如果值小于等于0，则表示没有限制
  final int selectMax;
  final List<int> selectableList;

  const GamePlayersMultiSelectDialogContentWidget({
    super.key,
    required this.playerCount,
    required this.state,
    required this.selectableList,
    this.selectMax = -1,
  });

  @override
  State<GamePlayersMultiSelectDialogContentWidget> createState() => state;

  static _GamePlayersMultiSelectDialogContentWidgetState newState() =>
      _GamePlayersMultiSelectDialogContentWidgetState();
}

class _GamePlayersMultiSelectDialogContentWidgetState extends State<GamePlayersMultiSelectDialogContentWidget> {
  List<int> get selectableList => widget.selectableList;
  final List<int> selectList = List<int>.empty(growable: true);

  get isLimit => widget.selectMax > 0;

  @override
  Widget build(BuildContext context) {
    return _checkHasMaxSelectConfigWidget(
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 120,
          maxWidth: double.maxFinite,
        ),
        // min: 300,
        // width: double.maxFinite,
        child: (GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          // 主轴间距
          mainAxisSpacing: 8.0,
          // 交叉轴间距
          crossAxisSpacing: 8.0,
          // 子项边界的内边距
          children: selectableList
              .map(
                (e) => Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(60),
                  child: CircleButton(
                    color: selectList.contains(e) ? Colors.deepOrange : Colors.white,
                    size: 50,
                    onTap: () => _selectItem(e),
                    child: Text('P$e'),
                  ),
                ),
              )
              .toList(growable: false),
        )),
      ),
    );
  }

  /// 根据是否有最大选择数量来配置 widget
  Widget _checkHasMaxSelectConfigWidget(Widget child) {
    if (widget.selectMax > 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("最多选择：(${selectList.length}/${widget.selectMax})"),
          child,
          if (isLimit) const SizedBox(height: 8 * 2),
          if (isLimit)
            Text(
              selectList.length == widget.selectMax ? "已达到最大选择数量!" : "",
              style: App.of(context).font.base.copyWith(color: Colors.red),
            ),
        ],
      );
    } else {
      return child;
    }
  }

  void _selectItem(int value) async {
    int playerId = value;
    // 处理按钮点击事件
    // Navigator.of(context).pop(playerId.toString());
    if (selectList.contains(playerId)) {
      selectList.remove(playerId);
    } else {
      if (widget.selectMax > 0 && selectList.length >= widget.selectMax) {
        // var snackBar = SnackBar(
        //   content: const Text("已达到人数选择上限，无法继续选择。"),
        //   action: SnackBarAction(label: "知道了", onPressed: () {}),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      selectList.add(playerId);
    }
    setState(() {});
  }

  void clear() {
    selectList.clear();
    setState(() {});
  }
}

/// 玩家选择弹窗选择器内容
/// 多选
class GamePlayersSingleSelectDialogContentWidget extends StatefulWidget {
  final int playerCount;
  final GamePlayersSingleSelectDialogContentWidgetState state;
  final List<int> selectList;
  final int defaultSelectIndex;

  const GamePlayersSingleSelectDialogContentWidget({
    super.key,
    required this.playerCount,
    required this.state,
    required this.selectList,
    this.defaultSelectIndex = 0,
  });

  @override
  State<GamePlayersSingleSelectDialogContentWidget> createState() => state;
}

class GamePlayersSingleSelectDialogContentWidgetState extends State<GamePlayersSingleSelectDialogContentWidget> {
  int selectIndex = -1;

  List<int> get selectList => widget.selectList;

  @override
  void initState() {
    super.initState();
    if (selectIndex < 0) {
      selectIndex = widget.defaultSelectIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 120,
        maxWidth: double.maxFinite,
      ),
      // min: 300,
      // width: double.maxFinite,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5,
        // 主轴间距
        mainAxisSpacing: 8.0,
        // 交叉轴间距
        crossAxisSpacing: 8.0,
        // 子项边界的内边距
        children: selectList
            .map((e) => Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(60),
                  child: CircleButton(
                    color: selectIndex == e ? Colors.deepOrange : Colors.white,
                    size: 50,
                    onTap: () => _selectItem(e),
                    child: Text(
                      'P$e',
                      style: app.baseFont.copyWith(
                        color: selectIndex == e ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ))
            .toList(growable: false),
      ),
    );
  }

  void _selectItem(int value) async {
    selectIndex = value;
    setState(() {});
  }

  void clear() {
    selectIndex = -1;
    setState(() {});
  }
}

/// 左滑行组件
class LeftSlideRowWidget extends StatefulWidget {
  final Widget child;
  final Function() onLeftSlideListener;
  final SideType sideType;
  final Widget Function(bool isSidleListener) sideWidget;

  const LeftSlideRowWidget({
    super.key,
    required this.child,
    required this.sideWidget,
    required this.onLeftSlideListener,
    this.sideType = SideType.left,
    // this.sideType = SideType.right,
  });

  @override
  State<LeftSlideRowWidget> createState() => _LeftSlideRowWidgetState();
}

class _LeftSlideRowWidgetState extends State<LeftSlideRowWidget> with SingleTickerProviderStateMixin {
  // 左右系数
  int get _i => widget.sideType == SideType.left ? -1 : 1;

  final double _maxWidget = 90;
  double _offset = 0;
  double _value = 0;

  bool get isSidleListener => _offset > _maxWidget * 2 / 3;

  // TextStyle get _sideTextStyle => app.baseFont.copyWith(color: Colors.white);

  Widget Function(bool isSidleListener) get _sideWidget {
    return widget.sideWidget;
  }

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: Offset(1.0 * _i, 0.0),
      // ).animate(_animationController);
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // _createButtonAnimation = Tween<Offset>(
    //   begin: Offset.zero,
    //   end: const Offset(-1.0, 0.0),
    // ).animate(AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 200),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Positioned.fill(
          child: Container(
            // width: double.maxFinite,
            // height: double.maxFinite,
            alignment: AlignmentDirectional.centerEnd,
            color: isSidleListener ? Colors.green : Colors.red,
            child: Container(
              alignment: AlignmentDirectional.center,
              width: _maxWidget,
              child: _sideWidget(isSidleListener),
            ),
          ),
        ),
        GestureDetector(
          // onPanUpdate: ,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _offset += details.primaryDelta! * _i;
    // if (kDebugMode) {
    //   // print("DragUpdateDetails ${details}");
    //   // print("DragUpdateDetails primaryDelta ${details.primaryDelta}");
    //   print("DragUpdateDetails(${widget.sideType}) offset $_offset");
    //   print("DragUpdateDetails(${widget.sideType}) _value $_value");
    //   // print("DragUpdateDetails delta ${details.delta}");
    //   // print("DragUpdateDetails globalPosition ${details.globalPosition}");
    //   // print("DragUpdateDetails localPosition ${details.localPosition}");
    //   print("\n");
    // }
    if (_offset < -_maxWidget - 0.5 || _offset > _maxWidget + 0.5) {
      return;
    }
    // if (_offset < -2 || _offset > _maxWidget + 0.5) {
    //   return;
    // }
    // _animationController.value +=
    //     (details.primaryDelta! / context.size!.width) * _i;
    _value = _offset;
    _animationController.value = (_value / context.size!.width);

    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    print("DragUpdateDetails(${widget.sideType}) finish_value $_value");
    if (isSidleListener) widget.onLeftSlideListener();
    _animationController.reverse();
    setState(() => _offset = 0);
  }
}

enum SideType {
  // 左滑
  left,
  right,
  ;
}

class AppSelectConfig<T, R> {
  final double circleSize;

  /// 可选范围，如果为空，则不设置
  final List<T> selectableList;

  final Callback<R> callback;

  /// 是否可以进行选择
  /// 默认是可以的，但存在一种情况，在用户确认选择后，不允许修改的情况下，需要禁止可选
  final bool selectable;

  /// 默认选择
  final R? defaultSelect;

  /// 如果是多选的情况下，设置最多选择多少个选项
  final int maxSelect;

  AppSelectConfig({
    required this.selectableList,
    required this.callback,
    this.defaultSelect,
    this.selectable = true,
    this.circleSize = 35,
    this.maxSelect = 0,
  });
}

class MultiSelectConfig<T> extends AppSelectConfig<T, List<T>> {
  MultiSelectConfig({
    required super.selectableList,
    required super.callback,
    super.selectable,
    super.circleSize,
    super.maxSelect,
    super.defaultSelect,
  });
}

/// 多选组件
class MultiSelectWidget<T> extends StatefulWidget {
  final MultiSelectViewConfig<T> viewConfig;

  const MultiSelectWidget({
    super.key,
    required this.viewConfig,
  });

  factory MultiSelectWidget.defaultView(
    MultiSelectConfig<T> config, {
    required Widget Function(T t, bool isSelect) itemBuilder,
    required Widget Function() buttonBuilder,
    String Function(T t)? itemDescBuilder,
  }) {
    return MultiSelectWidget<T>(
      viewConfig: DefaultMultiSelectViewConfig<T>(
        config,
        itemBuilder: itemBuilder,
        buttonBuilder: buttonBuilder,
        itemDescBuilder: itemDescBuilder,
      ),
    );
  }

  @override
  State<MultiSelectWidget<T>> createState() => _MultiSelectWidgetState<T>();
}

class _MultiSelectWidgetState<T> extends State<MultiSelectWidget<T>> {
  MultiSelectViewConfig<T> get _viewConfig => widget.viewConfig;

  List<T>? get _defaultValue => widget.viewConfig.config.defaultSelect;
  List<T> selected = [];

  @override
  void initState() {
    super.initState();
    if (null != _defaultValue) {
      selected.clear();
      selected.addAll(_defaultValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _viewConfig.selectShowView(selected, _viewConfig.selectButton(() {
      _viewConfig.toSelectView(context, (result) {
        setState(() {
          selected = result;
        });
        widget.viewConfig.config.callback(result);
      });
    }));
  }
}

abstract class MultiSelectViewConfig<T> {
  final MultiSelectConfig<T> config;

  MultiSelectViewConfig(this.config);

  Widget selectShowView(List<T> selected, Widget button);

  Widget selectButton(Function() callToSelect);

  void toSelectView(
    BuildContext context,
    Function(List<T> result) resultCallback,
  );
}

/// 默认选择器
class DefaultMultiSelectViewConfig<T> extends MultiSelectViewConfig<T> {
  final Widget Function(T t, bool isSelect) itemBuilder;
  final Widget Function() buttonBuilder;
  final String Function(T t)? itemDescBuilder;

  DefaultMultiSelectViewConfig(
    super.config, {
    required this.itemBuilder,
    this.itemDescBuilder,
    required this.buttonBuilder,
  });

  bool get _isDesc => null != itemDescBuilder;

  /// 展示已选择的项目
  @override
  Widget selectShowView(List<T> alreadySelects, Widget button) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: config.circleSize * 1.8,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = alreadySelects[index];
                  return SizedBox(
                    width: _isDesc ? config.circleSize * 1.4 : 1,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Circle(child: itemBuilder(item, false)),
                        ),
                        if (_isDesc) const SizedBox(height: 4),
                        if (_isDesc)
                          Center(
                            child: Text(
                              itemDescBuilder!(item),
                              style: context.app.baseFont.copyWith(fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: alreadySelects.length,
              ),
            ),
          ),
          button,
        ],
      ),
    );
  }

  /// 选择按钮
  @override
  Widget selectButton(Function() callToSelect) {
    return CircleButton(
      onTap: () => callToSelect(),
      child: buttonBuilder(),
    );
  }

  /// 去选择
  @override
  Future<void> toSelectView(
    BuildContext context,
    Function(List<T> result) resultCallback,
  ) async {
    List<T>? future = await showDialog<List<T>>(
      context: context,
      builder: (context) => _MultiSelectDialogWidget(config, this),
    );

    if (future != null) {
      resultCallback(future);
    } else {
      // 取消、不做任何操作
    }
  }
}

class _MultiSelectDialogWidget<T> extends StatefulWidget {
  final MultiSelectConfig<T> config;
  final DefaultMultiSelectViewConfig<T> viewConfig;

  const _MultiSelectDialogWidget(
    this.config,
    this.viewConfig, {
    super.key,
  });

  @override
  State<_MultiSelectDialogWidget<T>> createState() => _MultiSelectDialogWidgetState<T>();
}

class _MultiSelectDialogWidgetState<T> extends State<_MultiSelectDialogWidget<T>> {
  MultiSelectConfig<T> get _config => widget.config;

  bool get _isDesc => null != widget.viewConfig.itemDescBuilder;

  TextStyle get _font => app.baseFont;

  List<T>? get _defaultValue => _config.defaultSelect;

  final List<T> _selectList = [];

  @override
  void initState() {
    super.initState();
    if (null != _defaultValue) {
      _selectList.clear();
      _selectList.addAll(_defaultValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("选择玩家"),
      content: ListView(
        shrinkWrap: true,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 120,
              maxWidth: double.maxFinite,
            ),
            // min: 300,
            // width: double.maxFinite,
            child: (GridView.count(
              shrinkWrap: true,
              // 主轴间距
              crossAxisCount: 5,
              // 交叉轴间距
              mainAxisSpacing: 8.0,
              // 子项边界的内边距
              crossAxisSpacing: 8.0,
              // w/h
              childAspectRatio: _isDesc ? (9 / 16) : 1,
              children: _config.selectableList.map((item) {
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: CircleButton(
                        color: _selectList.contains(item) ? Colors.deepOrange : Colors.white,
                        size: _config.circleSize,
                        onTap: () => _selectItem(item),
                        child: widget.viewConfig.itemBuilder(item, _selectList.contains(item)),
                      ),
                    ),
                    if (_isDesc) const SizedBox(height: 8),
                    if (_isDesc)
                      SizedBox(
                        width: double.maxFinite,
                        child: Center(
                          child: Text(
                            widget.viewConfig.itemDescBuilder!(item),
                            style: _font.copyWith(fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(growable: false),
            )),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _selectList.clear());
            Navigator.of(context).pop(_selectList);
          },
          child: const Text("清空配置"),
        ),
        TextButton(
          onPressed: () {
            /// 直接返回结果
            Navigator.of(context).pop(_selectList);
          },
          child: const Text("确认配置"),
        ),
      ],
    );
  }

  void _selectItem(T value) async {
    // 处理按钮点击事件
    if (_selectList.contains(value)) {
      _selectList.remove(value);
    } else {
      if (_config.maxSelect > 0 && _selectList.length >= _config.maxSelect) {
        // var snackBar = SnackBar(
        //   content: const Text("已达到人数选择上限，无法继续选择。"),
        //   action: SnackBarAction(label: "知道了", onPressed: () {}),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      _selectList.add(value);
    }
    setState(() {});
  }
}

class RadioConfig<T> {
  List<T> selectItem;
  T? defaultValue;
  Function(T value) callback;

  Widget Function(BuildContext context, T item, bool isSelect) itemBuilder;

  bool isGrid = false;
  int gridCrossAxisCount = 1;
  double gridChildAspectRatio = 1.0;

  Axis listDirection = Axis.vertical;
  bool selectable = true;

  RadioConfig({
    required this.selectItem,
    required this.itemBuilder,
    required this.callback,
    this.defaultValue,
    this.isGrid = false,
    this.selectable = true,
    this.gridCrossAxisCount = 1,
    this.gridChildAspectRatio = 1.0,
  });

  factory RadioConfig.list({
    required List<T> selectItem,
    required String Function(T value) showText,
    required Function(T value) callback,
    T? defaultValue,
    bool selectable = true,
  }) {
    return RadioConfig<T>(
      selectItem: selectItem,
      itemBuilder: (context, item, isSelect) {
        return _defaultListItem(context, item, isSelect, showText);
      },
      callback: callback,
      defaultValue: defaultValue,
      selectable: selectable,
      isGrid: false,
    );
  }

  factory RadioConfig.grid({
    required List<T> selectItem,
    required String Function(T value) showText,
    required Function(T value) callback,
    T? defaultValue,
    int gridCrossAxisCount = 2,
    double gridChildAspectRatio = 1.0,
    double? width,
    double? height,
  }) {
    return RadioConfig(
      selectItem: selectItem,
      itemBuilder: (context, item, isSelect) {
        return _defaultGridItem(context, item, isSelect, showText, width, height);
      },
      callback: callback,
      defaultValue: defaultValue,
      gridCrossAxisCount: gridCrossAxisCount,
      gridChildAspectRatio: gridChildAspectRatio,
      isGrid: true,
    );
  }

  static Widget _defaultListItem<T>(
    BuildContext context,
    T item,
    bool isSelect,
    String Function(T value) showText,
  ) {
    String content = showText(item);
    return Container(
      decoration: BoxDecoration(
          color: isSelect ? Colors.green : null,
          border: Border.all(width: 1, color: Colors.black.withOpacity(0.12)),
          borderRadius: BorderRadius.circular(10)
          // shape: BoxShape.rectangle
          ),
      padding: const EdgeInsets.all(16),
      child: Text(
        content,
        style: context.app.baseFont.copyWith(
          color: isSelect ? Colors.white : null,
        ),
      ),
    );
  }

  static Widget _defaultGridItem<T>(
    BuildContext context,
    T item,
    bool isSelect,
    String Function(T value) showText,
    double? width,
    double? height,
  ) {
    String content = showText(item);
    return Container(
      decoration: BoxDecoration(
          color: isSelect ? Colors.green : null,
          border: Border.all(width: 1, color: Colors.black.withOpacity(0.12)),
          borderRadius: BorderRadius.circular(8)
          // shape: BoxShape.rectangle
          ),
      child: Center(
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: context.app.baseFont.copyWith(
              color: isSelect ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// 单项选择
class RadioGroup<T> extends StatefulWidget {
  final RadioConfig<T> config;

  const RadioGroup({super.key, required this.config});

  @override
  State<RadioGroup<T>> createState() => _RadioGroupState<T>();
}

class _RadioGroupState<T> extends State<RadioGroup<T>> {
  RadioConfig<T> get _config => widget.config;

  int selectIndex = -1;
  final double _interval = 8.0;

  @override
  void initState() {
    super.initState();
    if (null != _config.defaultValue) {
      selectIndex = _config.selectItem.indexOf(_config.defaultValue!);
    }
    // for (var value in _config.selectItem) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_config.isGrid) {
      return _gridSelect();
    } else {
      return _listSelect();
    }
  }

  Widget _itemView(BuildContext context, int index) => InkWell(
        child: _config.itemBuilder(
          context,
          _config.selectItem[index],
          selectIndex == index,
        ),
        onTap: () {
          if (!_config.selectable) return;
          _config.callback(_config.selectItem[index]);
          setState(() => selectIndex = index);
        },
      );

  Widget _listSelect() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: _config.listDirection,
        itemBuilder: _itemView,
        separatorBuilder: (context, index) =>
            _config.listDirection == Axis.vertical ? SizedBox(height: _interval) : SizedBox(width: _interval),
        itemCount: _config.selectItem.length);
  }

  Widget _gridSelect() {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: _config.listDirection,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _config.gridCrossAxisCount,
        childAspectRatio: _config.gridChildAspectRatio,
        mainAxisSpacing: _interval,
        crossAxisSpacing: _interval,
      ),
      itemBuilder: _itemView,
      itemCount: _config.selectItem.length,
    );
  }
}

// /// 多项选择
// class CheckGroup extends StatefulWidget {
//   const CheckGroup({super.key});
//
//   @override
//   State<CheckGroup> createState() => _CheckGroupState();
// }
//
// class _CheckGroupState extends State<CheckGroup> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }
