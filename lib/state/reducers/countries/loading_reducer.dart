import 'package:redux/redux.dart';
import '../../actions/countries.dart';

final countriesLoadingReducer = combineReducers<bool>([
  TypedReducer<bool, CountriesLoadedAction>(_setLoaded),
  TypedReducer<bool, CountriesNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}