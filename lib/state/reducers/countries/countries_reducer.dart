import 'package:redux/redux.dart';
import '../../actions/countries.dart';
import '../../../models/country.dart';

final countriesReducer = combineReducers<List<Country>>([
  TypedReducer<List<Country>, AddCountryAction>(_addCountry),
  TypedReducer<List<Country>, DeleteCountryAction>(_deleteCountry),
  TypedReducer<List<Country>, UpdateCountryAction>(_updateCountry),
  TypedReducer<List<Country>, ClearCompletedAction>(_clearCompleted),
  TypedReducer<List<Country>, CountriesLoadedAction>(_setLoadedCountries),
  TypedReducer<List<Country>, CountriesNotLoadedAction>(_setNoCountries),
]);

List<Country> _addCountry(List<Country> countries, AddCountryAction action) {
  return List.from(countries)..add(action.country);
}

List<Country> _deleteCountry(List<Country> countries, DeleteCountryAction action) {
  return countries.where((country) => country.code != country.code).toList();
}

List<Country> _updateCountry(List<Country> countries, UpdateCountryAction action) {
  return countries
      .map((country) => country.code == action.code ? action.updatedCountry : country)
      .toList();
}

List<Country> _clearCompleted(List<Country> countries, ClearCompletedAction action) {
  return countries.toList();
}

List<Country> _setLoadedCountries(List<Country> countries, CountriesLoadedAction action) {
  return action.countries;
}

List<Country> _setNoCountries(List<Country> countries, CountriesNotLoadedAction action) {
  return [];
}