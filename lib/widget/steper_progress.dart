import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:flutter/material.dart';

class StepProgressView extends StatefulWidget {
  final double _width;
  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;

  const StepProgressView(
      {super.key,
      required int curStep,
      required List<String> titles,
      required double width,
      required Color color})
      : _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(width > 0);

  @override
  State<StepProgressView> createState() => _StepProgressViewState();
}

class _StepProgressViewState extends State<StepProgressView> {
  final Color _inactiveColor = ColorManager.c28C937;

  final double lineWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width,
      child: Column(
        children: <Widget>[
          Row(
            children: _iconViews(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _titleViews(),
          ),
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    widget._titles.asMap().forEach((i, icon) {
      bool isActive = widget._curStep > i;
      bool isCompleted = widget._curStep > i ;

      var circleColor = isActive ? widget._activeColor : _inactiveColor;
      var lineColor = isCompleted ? widget._activeColor : _inactiveColor;
      var iconColor = isActive ? ColorManager.white : _inactiveColor;

      list.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 20.0,
          height: 20.0,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: isActive ? circleColor : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
            border: Border.all(
              color: circleColor,
              width: 2.0,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isCompleted
                ? Icon(
                    Icons.check,
                    key: ValueKey<int>(i),
                    color:  iconColor,
                    size: 14.0,
                    weight: 4,
                  )
                : Icon(
                    Icons.circle,
                    key: ValueKey<int>(i),
                    color: iconColor,
                    size: 5.0,
                  ),
          ),
        ),
      );

      // Line between icons
      if (i != widget._titles.length - 1) {
        list.add(
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: lineWidth,
              color: lineColor,
            ),
          ),
        );
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    widget._titles.asMap().forEach((i, text) {
      list.add(
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: widget._curStep > i ? 1.0 : 0.5,
          child: Text(
            text,
            style: getSemiBoldStyle(color: ColorManager.textColor, fontSize: 12),
          ),
        ),
      );
    });
    return list;
  }
}
