import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? initialText;
  final String hintText;
  final double fontSize;
  final Color textColor;
  final Color hintTextColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry contentPadding;
  final ValueNotifier<String>? textNotifier;
  final ValueChanged<String>? onTextChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  const CustomTextField({
    Key? key,
    this.initialText,
    this.hintText = '请输入内容',
    this.fontSize = 16.0,
    this.textColor = Colors.black,
    this.hintTextColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.contentPadding = const EdgeInsets.all(12.0),
    this.textNotifier,
    this.onTextChanged,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  ValueNotifier<String>? _externalNotifier;
  bool _isExternalUpdate = false;

  @override
  void initState() {
    super.initState();
    _externalNotifier = widget.textNotifier;

    // 初始化值优先级: textNotifier.value > initialText > ''
    final initialValue = _externalNotifier?.value ?? widget.initialText ?? '';
    _controller = TextEditingController(text: initialValue);

    // 如果initialText有值但textNotifier没有，则同步到textNotifier
    if (widget.initialText != null && _externalNotifier != null && _externalNotifier!.value.isEmpty) {
      _externalNotifier!.value = widget.initialText!;
    }

    _externalNotifier?.addListener(_handleExternalUpdate);
  }

  void _handleExternalUpdate() {
    if (!_isExternalUpdate) {
      final newValue = _externalNotifier?.value ?? '';
      if (_controller.text != newValue) {
        _controller.text = newValue;
      }
    }
    _isExternalUpdate = false;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textNotifier != widget.textNotifier) {
      oldWidget.textNotifier?.removeListener(_handleExternalUpdate);
      _externalNotifier = widget.textNotifier;
      _externalNotifier?.addListener(_handleExternalUpdate);

      // 更新控制器文本为新notifier的值
      final newValue = _externalNotifier?.value ?? widget.initialText ?? '';
      if (_controller.text != newValue) {
        _controller.text = newValue;
      }
    } else if (oldWidget.initialText != widget.initialText && _externalNotifier == null) {
      // 如果没有使用textNotifier且initialText变化，则更新
      _controller.text = widget.initialText ?? '';
    }
  }

  @override
  void dispose() {
    _externalNotifier?.removeListener(_handleExternalUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintTextColor,
          fontSize: widget.fontSize,
        ),
        filled: true,
        fillColor: widget.backgroundColor,
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: widget.textColor,
        fontSize: widget.fontSize,
      ),
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      onChanged: (text) {
        _isExternalUpdate = true;
        _externalNotifier?.value = text;
        widget.onTextChanged?.call(text);
      },
    );
  }
}
