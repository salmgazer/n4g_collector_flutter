import 'package:collector/middleware/AppDb.dart';
import 'package:collector/models/community.dart';
import 'package:collector/models/currency.dart';
import 'package:collector/models/language.dart';
import 'package:collector/models/models.dart';
import 'package:collector/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'components/my-drawer.dart';
import 'models/country.dart';
import 'models/region.dart';
import 'models/district.dart';
import './utils/strings.dart';
import 'app_state_container.dart';
import 'middleware/Api.dart';
import 'dart:convert';
import 'dart:async';


// Create a Form Widget
class DownloadSitesPage extends StatefulWidget {
  static String tag = 'download-sites-page';

  @override
  _DownloadSitesPageState createState() {
    return _DownloadSitesPageState();
  }
}

class _DownloadSitesPageState extends State<DownloadSitesPage> {

  final _downloadSitesFormKey = GlobalKey<FormState>();

  List<Country> _countries = <Country>[];
  List<Region> _regions = <Region>[];
  List<District> _districts = <District>[];

  var _communities = [];

  static final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  Country nullCountry = Country('-- Select Country --', '', currentTime, currentTime);
  Region nullRegion = Region('-1', '-- Select Region --', currentTime, currentTime);
  District nullDistrict = District('-1', '-- Select District --', '-1', currentTime, currentTime);
  
  Country _country;
  Region _region;
  District _district;

  List<Language> _languages = <Language>[];

  var _selectedCommunities;

  @override
  void initState() {
    print("About to initialize");
    Api().filter(Country.tableName, {}).then((fetchedCountries) => setState(() {
      List<dynamic> countriesBody = json.decode(fetchedCountries.body)[Country.tableName];
      print(countriesBody);
      _countries = countriesBody.map((country) => new Country.fromMap(country)).toList();
      _countries.insert(0, nullCountry);
    }));   

    super.initState();
  }

  void fetchRegions() {
    if (_country.code != '-1') {
      final path = Country.tableName + '/' + _country.code.toString() + '/' + Region.tableName;
      Api().filter(path, {})
        .then((fetchedRegions) => setState(() {
          List <dynamic> regionsBody = json.decode(fetchedRegions.body)[Region.tableName];
          _regions = regionsBody.map((region) => new Region.fromMap(region)).toList();
          _regions.insert(0, nullRegion);
        }));
    }
  }

  void fetchDistricts() {
    if (_region.id != '-1') {
      final path = Country.tableName + '/' + _country.code.toString() + '/' + Region.tableName + '/' + _region.id + '/' + District.tableName;
      Api().filter(path, {})
        .then((fetchedDistricts) => setState(() {
          List <dynamic> districtsBody = json.decode(fetchedDistricts.body)[District.tableName];
          _districts = districtsBody.map((district) => new District.fromMap(district)).toList();
          _districts.insert(0, nullDistrict);
        }));
    }
  }

  void fetchCommunities() {
    if (_district.id != '-1') {
      final path = Country.tableName + '/' + _country.code.toString() + '/' + Region.tableName + '/' + _region.id + '/' + District.tableName + '/' + _district.id + '/' + Community.tableName;
      Api().filter(path, {})
        .then((fetchedCommunities) => setState(() {
          json.decode(fetchedCommunities.body)[Community.tableName]
            .forEach((comm) => _communities.insert(0, comm));
        }));
    }
  }


  getCurrenciesFromApi() async {
    return Api().filter(Currency.tableName, {});
  }

  getSuppliesFromSelectedCommunities() async {
    var suppliersQueryString = new Map<String, dynamic>();
    suppliersQueryString['community_ids'] = _selectedCommunities;
    return Api().filter(Supplier.tableName, suppliersQueryString);
  }


  getOrganizationsFromSelectedCommunities() async {
    var organizationsQueryString = new Map<String, dynamic>();
    organizationsQueryString['community_ids'] = _selectedCommunities;
    return Api().filter(Organization.tableName, organizationsQueryString);
  }

  Future<dynamic> downloadSites() async {
    final existingCountry = await AppDb.findCountryByCode(_country.code);
    if (existingCountry == null) {
      print("About to create country");
      await AppDb.createOne(Country.tableName, _country.toMap());
    }

    final existingRegion = await AppDb.findRegionById(_region.id);
    if (existingRegion == null) {
      print("About to create region");
      await AppDb.createOne(Region.tableName, _region.toMap());
    }

    final existingDistrict = await AppDb.findDistrictById(_district.id);
    if (existingDistrict == null) {
      print("About to create district");
      await AppDb.createOne(District.tableName, _district.toMap());
    }

    // var fetchedCommunities = await getCommunitiesFromSelectedDistrict();
    // fetchedCommunities = json.decode(fetchedCommunities.body)[Community.tableName];
    if (_communities.length > 0) {
      final sups = await AppDb.filterCommunities();
      print(sups);
      await AppDb.batchInsert(Community.tableName, _communities);
    }

    var fetchedSuppliers = await getSuppliesFromSelectedCommunities();
    fetchedSuppliers = json.decode(fetchedSuppliers.body)[Supplier.tableName];
    if (fetchedSuppliers.length > 0) {
      await AppDb.batchInsert(Supplier.tableName, fetchedSuppliers);
    }

    var fetchedOrganizations = await getOrganizationsFromSelectedCommunities();
    fetchedOrganizations= json.decode(fetchedOrganizations.body)[Organization.tableName];
    if (fetchedOrganizations.length > 0) {
      await AppDb.batchInsertWithError(Organization.tableName, fetchedOrganizations);
    }

    var fetchedCurrencies = await getCurrenciesFromApi();
    fetchedCurrencies = json.decode(fetchedCurrencies.body)[Currency.tableName];
    if (fetchedCurrencies.length > 0) {
      await AppDb.batchInsert(Currency.tableName, fetchedCurrencies);
    }

    _country = nullCountry;
    _region = nullRegion;
    _district = nullDistrict;
  }

  @override
  Widget build(BuildContext context) {

    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['download_sites'];

    void _showDialog(title, body, buttonText) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title, style: TextStyle(color: Colors.red)),
            content: new Text(body),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                color: Colors.red,
                child: new Text(buttonText, style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showSuccessDialog(title, body, buttonText) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title, style: TextStyle(color: Colors.green)),
            content: new Text(body),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                color: Colors.green,
                child: new Text(buttonText, style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final country = new FormField(
      builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select country',
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          icon: const Icon(Icons.flag),
          // labelText: 'Country',
        ),
        isEmpty: _country == nullCountry,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _country == null ? nullCountry : _country,
            isDense: true,
            onChanged: (Country newCountry) {
              setState(() {
                _country = newCountry;
                state.didChange(newCountry);
                _regions = [];
                _region = null;
                _districts = [];
                _district = null;
                _communities = [];
                _selectedCommunities = [];
                fetchRegions();
              });
            },
            items: _countries.map((Country country) {
              return new DropdownMenuItem(
                value: country,
                child: new Text(country.name),
              );
            }).toList(),
          ),
        ),
      );
    },
    );

    final region = new FormField(
      builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select region',
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          icon: const Icon(Icons.my_location),
          // labelText: 'Region',
        ),
        isEmpty: _region == nullRegion,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _region == null ? nullRegion : _region,
            isDense: true,
            onChanged: (Region newRegion) {
              setState(() {
                _region= newRegion;
                state.didChange(newRegion);
                _districts = [];
                _district = null;
                _communities = [];
                _selectedCommunities = [];
                fetchDistricts();
                
              });
            },
            items: _regions.map((Region region) {
              return new DropdownMenuItem(
                value: region,
                child: new Text(region.name),
              );
            }).toList(),
          ),
        ),
      );
    },
    );

    final district = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select district',
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.location_city),
            // labelText: 'District',
          ),
          isEmpty: _district == nullDistrict,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _district == null ? nullDistrict : _district,
              isDense: true,
              onChanged: (District newDistrict) {
                setState(() {
                  _district= newDistrict;
                  state.didChange(newDistrict);
                  _communities = []; // empty communities
                  _selectedCommunities = []; // empty selected communities
                  fetchCommunities();
                });
              },
              items: _districts.map((District district) {
                return new DropdownMenuItem(
                  value: district,
                  child: new Text(district.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final communities = new MultiSelect(
      autovalidate: true,
      titleText: 'Selected communities',
      validator: (value) {
        if (value == null) {
          return 'Please select one or more communities';
        }
      },
      errorText: 'Please select one or more communities',
      dataSource: _communities,
      textField: 'name',
      valueField: 'id',
      filterable: true,
      required: true,
      value: null,
      onSaved: (value) {
        _selectedCommunities = value;
        print('The value is $value');
    },
  );

    final saveButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.greenAccent[700],
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () async {
            final FormState form = _downloadSitesFormKey.currentState;
            form.save();
            if (_country == null || _region == null || _district == null || _selectedCommunities == null) {
              _showDialog('Incompelete', 'You need to select country, region, district, and communities', 'Ok');
            } else {
              _showDialog('About to download', 'Downloading content', 'Close');
              await downloadSites();
              _showSuccessDialog('Successfully downloaded', 'Successfully downloaded', 'Ok');
              _selectedCommunities = [];
            }
          },
          child: Text('Download', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ),
      ),
    );

    final formLabel = new Center(
    child: Text(
    'Fill form to download sites',
    style: TextStyle(color: Colors.green[700], fontSize: 22, fontFamily: 'Roboto'),
  ));


    return new Scaffold(
      drawer: MyDrawer(),
      appBar: new AppBar(
        title: new Text(displayName, style: new TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[500],
        iconTheme: new IconThemeData(color: Colors.white)
      ),
      body:
      Form(
        key: _downloadSitesFormKey,
        child:
          Container(
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
            child: new Column(
              children: <Widget>[
                formLabel,
                SizedBox(height: 20.0),
                country,
                SizedBox(height: 20.0),
                region,
                SizedBox(height: 20.0),
                district,
                SizedBox(height: 20.0),
                communities,
                SizedBox(height: 20.0),
                saveButton,
              ],
            ),
          ),
      ),
    );
  }
}
