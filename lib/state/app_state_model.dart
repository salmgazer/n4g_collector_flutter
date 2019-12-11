import 'package:meta/meta.dart';
import '../models/models.dart';

@immutable
class AppState {
  final bool countriesAreLoading;
  final List<Country> countries;

  AppState({
    this.countriesAreLoading = false,
    this.countries = const [],
  });

  factory AppState.loading() => AppState(countriesAreLoading: true);

  AppState copyWith({
    bool countriesAreLoading,
    List<Country> countries,
  }) {
    return AppState(
      countriesAreLoading: countriesAreLoading ?? this.countriesAreLoading,
      countries: countries ?? this.countries,
    );
  }

  @override
  int get hashCode =>
      countriesAreLoading.hashCode ^
      countries.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          countriesAreLoading == other.countriesAreLoading &&
          countries == other.countries;

  @override
  String toString() {
    return 'AppState{countriesAreLoading: $countriesAreLoading, countries: $countries}';
  }
}