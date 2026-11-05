/// Comparison key for labels typed by people: ignores case and extra
/// whitespace, so "Oceano", " oceano " and "OCEANO" are the same.
String textKey(String value) =>
    value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
