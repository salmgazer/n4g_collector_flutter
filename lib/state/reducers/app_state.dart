import 'countries/countries_reducer.dart';
import 'countries/loading_reducer.dart';
import '../app_state_model.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    countriesAreLoading: countriesLoadingReducer(state.countriesAreLoading, action),
    countries: countriesReducer(state.countries, action),
  );
}