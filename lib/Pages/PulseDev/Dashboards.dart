import 'package:flutter/material.dart';

class Dashboards extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  const Dashboards({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  State<Dashboards> createState() => _DashboardsState();
}

class _DashboardsState extends State<Dashboards> {
  final TransformationController _contoller = TransformationController();
  BoxConstraints? _constraints;

  @override
  void dispose() {
    _contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: _resetWidth, child: Text("reset scale")),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final view = InteractiveViewer(
                transformationController: _contoller,
                constrained: false,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: widget.child,
                ),
              );
              _initializeWidth(constraints);
              return view;
            },
          ),
        ),
      ],
    );
  }

  void _initializeWidth(BoxConstraints constraints) {
    if (_constraints == null) {
      _constraints = constraints;
      _resetWidth();
    }
  }

  void _resetWidth() {
    if (_constraints == null) {
      return;
    }
    final scale = _constraints!.maxWidth / widget.width;
    _contoller.value = Matrix4.identity()..scaleByDouble(scale, scale, 1, 1);
  }
}
