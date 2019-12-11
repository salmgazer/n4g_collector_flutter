import 'package:flutter/material.dart';
import 'dart:async';
import 'chips-profile.dart';

typedef ChipsInputSuggestions = Future<List<ChipsProfile>> Function(String query);

class ChipsInput extends StatefulWidget {
  const ChipsInput({
    Key key,
    @required this.findSuggestions,
    @required this.onChanged,
  }) : super(key: key);

  final ChipsInputSuggestions findSuggestions;
  final ValueChanged<List<ChipsProfile>> onChanged;

  @override
  _ChipsInputState createState() => _ChipsInputState();
}

class _ChipsInputState extends State<ChipsInput> {
  final _textController = TextEditingController();
  final _profiles = Set<ChipsProfile>();
  List<ChipsProfile> _suggestions;
  int _searchId = 0;

  @override
  Widget build(BuildContext context) {
    var chipsChildren = _profiles
        .map<Widget>(
          (profile) => Chip(
                key: ObjectKey(profile),
                label: Text(profile.name),
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(profile.imageUrl),
                ),
                onDeleted: () => _onDeleteProfile(profile),
              ),
        )
        .toList();

    chipsChildren.add(TextField(
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Search for produce'
      ),
      onChanged: _onSearchChanged,
    ));

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Wrap(
            children: chipsChildren,
            spacing: 4.0,
            runSpacing: -8.0,
          ),
        ),
        new Row(children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
              itemCount: _suggestions?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final profile = _suggestions[index];
                return ListTile(
                  key: ObjectKey(profile),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profile.imageUrl),
                  ),
                  title: Text(profile.name),
                  subtitle: Text(profile.email),
                  onTap: () => _onSuggestionTapped(profile),
                );
              },
            ),
            )
          ),
        ],)
      ],
    );
  }

  void _onSuggestionTapped(ChipsProfile profile) {
    _textController.clear();
    setState(() {
      _profiles.add(profile);
      _suggestions = null;
    });
    widget.onChanged(_profiles.toList(growable: false));
  }

  void _onDeleteProfile(ChipsProfile profile) {
    setState(() => _profiles.remove(profile));
    widget.onChanged(_profiles.toList(growable: false));
  }

  void _onSearchChanged(String value) async {
    final localId = ++_searchId;
    final results = await widget.findSuggestions(value);
    if (_searchId == localId && mounted) {
      setState(() => _suggestions = results);
    }
  }
}

