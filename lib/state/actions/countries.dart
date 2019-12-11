import '../../models/country.dart';
enum VisibilityFilter { all, active, completed }

class LoadCountriesAction {}

class CountriesNotLoadedAction {}

class ClearCompletedAction {}

class CountriesLoadedAction {
  final List<Country> countries;

  CountriesLoadedAction(this.countries);

  @override
  String toString() {
    return 'CountrysLoadedAction{countries: $countries}';
  }
}


class UpdateCountryAction {
  final int id;
  final Country updatedCountry;

  UpdateCountryAction(this.id, this.updatedCountry);

  @override
  String toString() {
    return 'UpdateCountryAction{id: $id, updatedCountry: $updatedCountry}';
  }
}

class DeleteCountryAction {
  final String id;

  DeleteCountryAction(this.id);

  @override
  String toString() {
    return 'DeleteCountryAction{id: $id}';
  }
}


class AddCountryAction {
  final Country country;

  AddCountryAction(this.country);

  @override
  String toString() {
    return 'AddCountryAction{country: $country}';
  }
}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}