import 'package:collector/middleware/AppDb.dart';
import 'package:collector/models/community.dart';
import 'package:collector/models/language.dart';
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

  Country nullCountry = Country(-1, '-- Select Country --', '', DateTime(2000), DateTime(2000)); 
  Region nullRegion = Region(-1, '-- Select Region --', DateTime(2000), DateTime(2000));
  District nullDistrict = District(-1, '-- Select District --', -1, DateTime(2000), DateTime(2000));
  
  Country _country;
  Region _region;
  District _district;

  List<Language> _languages = <Language>[];

  var _selectedCommunities;

  @override
  void initState() {
    Api().filter(Country.tableName, {}).then((fetchedCountries) => setState(() {
      List <dynamic> countriesBody = json.decode(fetchedCountries.body)['data'];
      print(countriesBody);
      _countries = countriesBody.map((country) => new Country.fromMap(country)).toList();
      _countries.insert(0, nullCountry);
    }));   

    super.initState();
  }

  void fetchRegions() {
    if (_country.id != -1) {
      Api().filter(Region.tableName, {'countryId': _country.id.toString()})
        .then((fetchedRegions) => setState(() {
          List <dynamic> regionsBody = json.decode(fetchedRegions.body)['data'];
          _regions = regionsBody.map((region) => new Region.fromMap(region)).toList();
          _regions.insert(0, nullRegion);
        }));
    }
  }

  void fetchDistricts() {
    if (_region.id != -1) {
      Api().filter(District.tableName, {'regionId': _region.id.toString()})
        .then((fetchedDistricts) => setState(() {
          List <dynamic> districtsBody = json.decode(fetchedDistricts.body)['data'];
          _districts = districtsBody.map((district) => new District.fromMap(district)).toList();
          _districts.insert(0, nullDistrict);
        }));
    }
  }

  void fetchCommunities() {
    if (_district.id != -1) {
      Api().filter(Community.tableName, {'districtId': _district.id.toString()})
        .then((fetchedCommunities) => setState(() {
          json.decode(fetchedCommunities.body)['data']
            .forEach((comm) => _communities.insert(0, comm));
        }));
    }
  }


  getCommunitiesFromSelectedDistrict() async {
    var communitiesQueryString = new Map<String, String>();
    var communityResource = Community.tableName;

    if (_selectedCommunities.length == 1) {
      communitiesQueryString['communityId'] = _selectedCommunities[0].toString();
    } else {
      communityResource = communityResource + '?';
      _selectedCommunities.forEach((comm) =>  communityResource + r"&communityId[$in]");
    }
    return Api().filter(Community.tableName, communitiesQueryString);
  }

  getCurrenciesFromApi() async {
    return Api().filter(Language.tableName, {});
  }

  getSuppliesFromSelectedCommunities() async {
    var suppliersQueryString = new Map<String, String>();
    var supplierResource = Supplier.tableName;

    if (_selectedCommunities.length == 1) {
      suppliersQueryString['communityId'] = _selectedCommunities[0].toString();
    } else {
      supplierResource = supplierResource + '?';
      _selectedCommunities.forEach((comm) =>  supplierResource + r"&communityId[$in]");
    }
    return Api().filter(Supplier.tableName, suppliersQueryString);
  }

  void downloadSites() async {
    final existingCountry = await AppDb.findCountryById(_country.id);
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

    var fetchedCommunities = await getCommunitiesFromSelectedDistrict();
    fetchedCommunities = json.decode(fetchedCommunities.body)['data'];
    if (fetchedCommunities.length > 0) {
      await AppDb.batchInsert(Community.tableName, fetchedCommunities);
    }

    var fetchedSuppliers = await getSuppliesFromSelectedCommunities();
    fetchedSuppliers = json.decode(fetchedSuppliers.body)['data'];
    if (fetchedSuppliers.length > 0) {
      await AppDb.batchInsert(Supplier.tableName, fetchedSuppliers);
    }

    var fetchedCurrencies = await getCurrenciesFromApi();
    fetchedCurrencies = json.decode(fetchedCurrencies.body)['data'];
    if (fetchedCurrencies.length > 0) {
      await AppDb.batchInsert(Language.tableName, fetchedCurrencies);
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

    final country = new FormField(
      builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
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
          onPressed: () {
            final FormState form = _downloadSitesFormKey.currentState;
            form.save();
            if (_country == null || _region == null || _district == null || _selectedCommunities == null) {
              print(_country);
              print(_region);
              print(_district);
              print(_selectedCommunities);
              _showDialog('Incompelete', 'You need to select country, region, district, and communities', 'Ok');
            } else {
              print(_country);
              print(_region);
              print(_district);
              print(_selectedCommunities);
              downloadSites();
              _showDialog('About to download', 'About to download', 'Close');
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
