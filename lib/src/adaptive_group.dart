part of 'adaptive_widget.dart';

class AdaptiveGroup {
  final _listeners = <AdaptiveState, double>{};
  var _widgetsNotified = false;
  var _fontSize = double.infinity;

  void _updateFontSize(AdaptiveState text, double maxFontSize) {
    _listeners[text] = maxFontSize;
    final lastFontSize = _fontSize;
    _fontSize = double.infinity;
    _listeners.forEach((key, value) {
      _fontSize = min(_fontSize, value);
    });
    if (lastFontSize != _fontSize) {
      _widgetsNotified = false;
      scheduleMicrotask(_notifyListeners);
    }
  }

  void _notifyListeners() {
    if (_widgetsNotified) {
      return;
    } else {
      _widgetsNotified = true;
    }

    for (final textState in _listeners.keys) {
      if (textState.mounted) {
        if (textState.fontScale != _fontSize) {
          textState._notifySync();
        }
      }
    }
  }

  void _remove(AdaptiveState text) {
    _listeners.remove(text);
  }
}
