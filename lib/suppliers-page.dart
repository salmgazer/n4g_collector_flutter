import 'package:collector/download_sites_page.dart';
import 'package:flutter/material.dart';
import 'components/my-drawer.dart';
import 'models/supplier.dart';
import 'models/organization.dart';
import 'models/community.dart';
import 'components/supplier-list-tile.dart';
import './utils/strings.dart';
import 'app_state_container.dart';
import 'middleware/AppDb.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

// Create a Form Widget
class SuppliersPage extends StatefulWidget {
  static String tag = 'suppliers-page';

  @override
  _SuppliersPageState createState() {
    return _SuppliersPageState();
  }
}

class _SuppliersPageState extends State<SuppliersPage> {
  TextEditingController searchController = TextEditingController();
  String filter = '';
  List<Supplier> suppliers = <Supplier>[];

  static final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

  final _registerSupplierFormKey = GlobalKey<FormState>();
  final boxHeight = 20.0;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String _gender = '-- Select Gender --';
  List<String> _genders = ['-- Select Gender --', 'female', 'male'];

  Organization _organization =
      Organization('-1', '-- Select organization --', '-1', currentTime, currentTime);
  List<Organization> _organizations = [];

  Community _community =
      Community('-1', '-- Select community --', currentTime, currentTime);
  List<Community> _communities = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  initState() {
    getCommunities().then((fetchedCommunities) => setState(() {
      if (fetchedCommunities.length < 1) {
        Navigator.of(context).pushNamed(DownloadSitesPage.tag);
      }
      _communities = fetchedCommunities;
    }));

    getSuppliers().then((fetchedSuppliers) => setState(() {
      suppliers = fetchedSuppliers;
    }));

    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });

    getOrganizations().then((fetchedOrganizations) => setState(() {
      print("##################################");
      print(fetchedOrganizations);
      _organizations = fetchedOrganizations;
      _organizations.insert(0, _organization);
    }));

    super.initState();
  }

  getSuppliers() async {
    return AppDb.filterSuppliers();
  }

  getCommunities() async {
    return AppDb.filterCommunities();
  }

  getOrganizations() async {
    return AppDb.filterOrganizations();
  }


  final pageName = new Center(
    child: Text('Suppliers', style: TextStyle(color: Colors.pink)),
  );

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget =
        AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();

    final displayName = labels[appLanguage]['suppliers'];

    final defaultCommunity = _communities
        .firstWhere((community) => community.id == '-1', orElse: () => null);
    if (defaultCommunity == null) {
      _communities.insert(0, _community);
    }

    final defaultOrganization =
        _organizations.firstWhere((organization) => organization.id == '-1', orElse: () => null);
    if (defaultOrganization == null) {
      _organizations.insert(0, _organization);
    }

    // Build a Form widget using the _formKey we created above
    final firstNameField = TextFormField(
      keyboardType: TextInputType.text,
      controller: firstNameController,
      decoration: new InputDecoration(
        hintText: 'Enter first name',
        icon: const Icon(Icons.face),
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'First name',
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.length < 2) {
          return 'Please enter first name';
        }
      },
    );

    final lastNameField = TextFormField(
      keyboardType: TextInputType.text,
      controller: lastNameController,
      decoration: new InputDecoration(
        hintText: 'Enter other name',
        labelStyle: TextStyle(color: Colors.brown),
        icon: const Icon(Icons.face),
        labelText: 'Other names',
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.length < 2) {
          return 'Please enter other name';
        }
      },
    );

    final phoneNumber = TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneNumberController,
      decoration: new InputDecoration(
        hintText: 'Enter phone number',
        labelStyle: TextStyle(color: Colors.brown),
        icon: const Icon(Icons.phone),
        labelText: 'Phone number',
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 10) {
          return 'Please enter phone number';
        }
      },
    );

    final about = TextFormField(
        keyboardType: TextInputType.multiline,
        controller: aboutController,
        decoration: new InputDecoration(
          hintText: 'About supplier',
          labelStyle: TextStyle(color: Colors.brown),
          icon: const Icon(Icons.description),
          labelText: 'About supplier',
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ));

    final age = TextFormField(
      keyboardType: TextInputType.number,
      controller: ageController,
      decoration: new InputDecoration(
        hintText: 'Age',
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Age',
        icon: const Icon(Icons.date_range),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter age';
        }
      },
    );

    final gender = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.people),
            labelText: 'Gender',
          ),
          isEmpty: _gender == '',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _gender,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _gender = newValue;
                  state.didChange(newValue);
                });
              },
              items: _genders.map((String value) {
                return new DropdownMenuItem(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final community = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.location_on),
            labelText: 'Community',
          ),
          isEmpty:
              _community == Community('-1', '', currentTime, currentTime),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _community,
              isDense: true,
              onChanged: (Community newCommunity) {
                setState(() {
                  _community = newCommunity;
                  state.didChange(newCommunity);
                });
              },
              items: _communities.map((Community community) {
                return new DropdownMenuItem(
                  value: community,
                  child: new Text(community.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final organization = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.group),
            labelText: 'Organization',
          ),
          isEmpty: _organization == Organization('-1', '', '-1', currentTime, currentTime),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _organization,
              isDense: true,
              onChanged: (Organization newOrganization) {
                setState(() {
                  _organization = newOrganization;
                  state.didChange(newOrganization);
                });
              },
              items: _organizations.where((org) => org.communityId == _community.id || org.id == '-1').map((Organization organization) {
                return new DropdownMenuItem(
                  value: organization,
                  child: new Text(organization.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final formButton = new Container(
      margin: EdgeInsets.only(left: 45.0, right: 40.0, top: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.greenAccent[700],
        child: MaterialButton(
          minWidth: 300.0,
          height: 42.0,
          onPressed: () async {
            if (_registerSupplierFormKey.currentState.validate()) {
              /*
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
              */
              final firstName = firstNameController.text;
              final otherNames = lastNameController.text;
              final phone = phoneNumberController.text;
              final age = ageController.text;
              final about = aboutController.text;
              final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

              final Map newSupplier = <String, dynamic>{
                "id": uuid.v4(),
                "firstName": firstName,
                "otherNames": otherNames,
                "phone": phone,
                "age": age,
                "communityId": _community.id,
                "gender": _gender,
                "membershipCode": age * 2,
                "about": about,
                "createdAt": currentTime,
                "updatedAt": currentTime
              };

              print(newSupplier);
              await AppDb.createOne(Supplier.tableName, newSupplier);
              Navigator.of(context).pushNamed(SuppliersPage.tag);
            }
          },
          child:
              Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );

    /*
    return filter == null || filter == "" ? supplierCard(SupplierListItem(supplier, context)) :
    (supplier.firstName + " " + supplier.lastName).toLowerCase().contains(filter.toLowerCase())
    || supplier.membershipCode.toLowerCase().contains(filter.toLowerCase()) ? supplierCard(SupplierListItem(supplier, context)) : new Container();
    */

    final List<Supplier> filteredSuppliers = this
        .suppliers
        .where((supplier) =>
            supplier.toString().toLowerCase().contains(filter.toLowerCase()) ||
            supplier.membershipCode.toString().contains(filter))
        .toList();
    filteredSuppliers.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final suppliersTab = new Material(
      child: new Column(
        children: <Widget>[
          new TextField(
            decoration: new InputDecoration(
                icon: const Icon(Icons.search),
                labelText: "  ${labels[appLanguage]['supplier_search_help']}"),
            onChanged: (text) {
              filter = text;
              print(filter);
            },
            controller: searchController,
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: filteredSuppliers == null
                  ? 0
                  : filteredSuppliers.length, //getSuppliers().length,
              itemBuilder: (BuildContext context, int index) {
                final supplier = filteredSuppliers[index];
                return supplierCard(SupplierListItem(supplier, context));
                /*
                  return filter == null || filter == "" ? supplierCard(SupplierListItem(supplier, context)) :
                  (supplier.firstName + " " + supplier.lastName).toLowerCase().contains(filter.toLowerCase())
                  || supplier.membershipCode.toLowerCase().contains(filter.toLowerCase()) ? supplierCard(SupplierListItem(supplier, context)) : new Container();
                  */
              },
            ),
          ),
        ],
      ),
    );

    final registerSupplierTab = SingleChildScrollView(
      child: Form(
        key: _registerSupplierFormKey,
        child: new Container(
          margin: new EdgeInsets.only(
              left: 20.0, right: 20.0, top: 40.0, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // formLabel,
              // SizedBox(height: boxHeight),
              firstNameField,
              SizedBox(height: boxHeight),
              lastNameField,
              SizedBox(height: boxHeight),
              phoneNumber,
              SizedBox(height: boxHeight),
              about,
              SizedBox(height: boxHeight),
              age,
              SizedBox(height: boxHeight),
              gender,
              SizedBox(height: boxHeight),
              community,
              SizedBox(height: boxHeight),
              organization,
              SizedBox(height: boxHeight),
              formButton,
              SizedBox(height: boxHeight),
            ],
          ),
        ),
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.people),
                    text: labels[appLanguage]['manage']),
                Tab(
                    icon: Icon(Icons.person_add),
                    text: labels[appLanguage]['register'])
              ],
            ),
            title: Text("Suppliers"),
          ),
          body: Form(
            child: TabBarView(
              children: [
                suppliersTab,
                registerSupplierTab,
              ],
            ),
          )),
    );
  }
}
