import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Context Extensions
extension BuildContextX on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;

  // Media Query
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Navigation
  NavigatorState get navigator => Navigator.of(this);
  void pop<T>([T? result]) => navigator.pop(result);
  bool get canPop => navigator.canPop();
}

// String Extensions
extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get toCamelCase {
    final words = split(RegExp(r'[_\s-]+'));
    if (words.isEmpty) return this;
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join();
  }

  String get ellipsize {
    if (length <= 20) return this;
    return '${substring(0, 17)}...';
  }

  String get formatCurrency {
    final value = double.tryParse(this);
    if (value == null) return this;
    return NumberFormat.currency(symbol: '$', decimalDigits: 2).format(value);
  }
}

// Number Extensions
extension DoubleX on double {
  String toCurrency({String symbol = '$'}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(this);
  }

  String toCompactCurrency({String symbol = '$'}) {
    return NumberFormat.compactCurrency(symbol: symbol, decimalDigits: 1)
        .format(this);
  }

  double get roundTo2 => double.parse(toStringAsFixed(2));
}

// DateTime Extensions
extension DateTimeX on DateTime {
  String get formattedDate => DateFormat('MMM dd, yyyy').format(this);
  String get formattedTime => DateFormat('hh:mm a').format(this);
  String get formattedDateTime => DateFormat('MMM dd, yyyy • hh:mm a').format(this);
  String get relativeTime => _getRelativeTime(this);

  static String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// List Extensions
extension ListX<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((item) {
      final key = keySelector(item);
      return seen.add(key);
    }).toList();
  }

  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size < length) ? i + size : length));
    }
    return chunks;
  }
}

// Widget Extensions
extension WidgetX on Widget {
  Widget pad(EdgeInsets padding) => Padding(padding: padding, child: this);

  Widget padSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget padAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  Widget padHorizontal(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Widget padVertical(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  Widget centered() => Center(child: this);

  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  Widget positioned({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: this,
      );

  Widget hero(String tag) => Hero(tag: tag, child: this);

  Widget withTooltip(String message) => Tooltip(message: message, child: this);

  Widget ignorePointer({bool ignoring = true}) =>
      IgnorePointer(ignoring: ignoring, child: this);

  Widget absorbPointer({bool absorbing = true}) =>
      AbsorbPointer(absorbing: absorbing, child: this);

  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);

  Widget rotate(double angle) => Transform.rotate(angle: angle, child: this);

  Widget scale(double scale) => Transform.scale(scale: scale, child: this);

  Widget translate({double x = 0, double y = 0}) =>
      Transform.translate(offset: Offset(x, y), child: this);

  Widget clipRRect({double radius = 0}) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);

  Widget clipOval() => ClipOval(child: this);

  Widget withConstraints({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          minHeight: minHeight ?? 0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: this,
      );

  Widget sizedBox({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  Widget animatedContainer({
    required Duration duration,
    Curve curve = Curves.easeInOut,
    double? width,
    double? height,
    Color? color,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) =>
      AnimatedContainer(
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        color: color,
        padding: padding,
        decoration: borderRadius != null
            ? BoxDecoration(borderRadius: borderRadius)
            : null,
        child: this,
      );

  Widget withDecoratedBox({
    Color? color,
    Gradient? gradient,
    BorderRadius? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? shadows,
    DecorationImage? image,
  }) =>
      DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: borderRadius,
          border: border,
          boxShadow: shadows,
          image: image,
        ),
        child: this,
      );
}

// Color Extensions
extension ColorX on Color {
  Color withDarkness(double amount) => Color.lerp(this, Colors.black, amount)!;

  Color withLightness(double amount) => Color.lerp(this, Colors.white, amount)!;

  Color get onColor => computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
