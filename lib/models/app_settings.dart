class AppSetting {
  String currencyCode;
  String languageName;

  AppSetting(
    this.currencyCode,
    this.languageName,
  );

  AppSetting.fromMap(Map<String, dynamic> map) {
    this.currencyCode = map['currencyCode'];
    this.languageName = map['languageName'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSetting && runtimeType == other.runtimeType && languageName == other.languageName;

  @override
  int get hashCode => languageName.hashCode;
  
  @override
  String toString() {
    return languageName;
  }

  static String tableName = 'app_settings';
}
