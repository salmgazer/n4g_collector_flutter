class AppSetting {
  String currencyName;
  String languageCode;
  int lastLogInDate;

  AppSetting(
    this.currencyName,
    this.languageCode,
    this.lastLogInDate,
  );

  AppSetting.fromMap(Map<String, dynamic> map) {
    this.currencyName = map['currencyName'];
    this.languageCode = map['languageName'];
    this.lastLogInDate = map['lastLogInDate'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "currencyName": currencyName,
      "languageCode": languageCode,
      "lastLogInDate": lastLogInDate
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSetting && runtimeType == other.runtimeType && languageCode == other.languageCode;

  @override
  int get hashCode => languageCode.hashCode;
  
  @override
  String toString() {
    return languageCode;
  }

  static String tableName = 'app_settings';
}
