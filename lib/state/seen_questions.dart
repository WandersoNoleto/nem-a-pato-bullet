/// Ids of the questions already shown, shared by every game in the app so
/// a question never comes back.
///
/// Kept in memory for now; persisted on the device in a later step.
class SeenQuestions {
  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool contains(String id) => _ids.contains(id);

  void add(String id) => _ids.add(id);
}
