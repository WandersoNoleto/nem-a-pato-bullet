/// Ids of the questions already shown, shared by every game so a question
/// never comes back, even after the app is closed.
///
/// [onChanged] receives every change so it can be stored on the device.
class SeenQuestions {
  SeenQuestions({
    Iterable<String> initial = const [],
    void Function(Set<String> ids)? onChanged,
  }) : _ids = {...initial},
       _onChanged = onChanged;

  final Set<String> _ids;
  final void Function(Set<String> ids)? _onChanged;

  Set<String> get ids => Set.unmodifiable(_ids);

  int get count => _ids.length;

  bool contains(String id) => _ids.contains(id);

  void add(String id) {
    if (_ids.add(id)) _onChanged?.call(ids);
  }

  /// Lets every question come up again.
  void clear() {
    if (_ids.isEmpty) return;
    _ids.clear();
    _onChanged?.call(ids);
  }
}
