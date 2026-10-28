({String value, String unit}) dashboardTrafficValue(num bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var index = 0;
  while (value >= 1024 && index < units.length - 1) {
    value /= 1024;
    index++;
  }
  final text = value.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');
  return (value: text, unit: units[index]);
}
