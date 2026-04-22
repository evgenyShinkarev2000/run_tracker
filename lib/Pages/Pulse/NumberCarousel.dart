import 'package:flutter/material.dart';
import 'package:run_tracker/Theme/export.dart';

class NumberCarousel extends StatefulWidget {
  final int initialValue;
  final void Function(int value) onChanged;
  final int min;
  final int max;

  const NumberCarousel({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.min,
    required this.max,
  }) : assert(initialValue >= min && initialValue <= max),
       assert(min <= max);

  @override
  State<NumberCarousel> createState() => NumberCarouselState();
}

class NumberCarouselState extends State<NumberCarousel> {
  static const double _itemHeight = 30;
  PageController? _controller;

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initializeController(constraints);

        return PageView.builder(
          onPageChanged: _handlePageChanged,
          scrollDirection: .vertical,
          controller: _controller,
          itemCount: widget.max - widget.min + 1,
          itemBuilder: (context, index) =>
              _buildWidget(context, index, bottomBorder: true),
        );
      },
    );
  }

  void scrollTo(int value) {
    value = value.clamp(widget.min, widget.max);
    _animateToIndex(value - widget.min);
  }

  void _handlePageChanged(int index) {
    widget.onChanged(index + widget.min);
  }

  void _handleTap(int index) {
    _animateToIndex(index);
  }

  void _animateToIndex(int index) {
    _controller?.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _initializeController(BoxConstraints constraints) {
    if (_controller != null) {
      return;
    }

    _controller = PageController(
      initialPage: widget.initialValue - widget.min,
      viewportFraction: _itemHeight / constraints.maxHeight,
    );
  }

  Widget _buildWidget(
    BuildContext borderColor,
    int index, {
    bool topBorder = false,
    bool bottomBorder = false,
  }) {
    return InkWell(
      onTap: () => _handleTap(index),
      child: Container(
        alignment: .center,
        decoration: BoxDecoration(
          border: Border(
            top: topBorder
                ? BorderSide(
                    color: context.themeData.colorScheme.secondaryContainer,
                  )
                : BorderSide.none,
            bottom: bottomBorder
                ? BorderSide(
                    color: context.themeData.colorScheme.secondaryContainer,
                  )
                : BorderSide.none,
          ),
        ),
        child: Text(
          (index + widget.min).toString(),
          textAlign: .center,
          style: context.themeData.textTheme.titleMedium,
        ),
      ),
    );
  }
}
