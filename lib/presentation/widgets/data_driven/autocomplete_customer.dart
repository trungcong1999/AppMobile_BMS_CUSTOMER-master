import 'package:flutter/material.dart';

class AutoCompleteCustomer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AutoCompleteCustomerState();
}

class _AutoCompleteCustomerState extends State<AutoCompleteCustomer> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Autocomplete<Continent>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return continentOptions
              .where((Continent continent) => continent.name.toLowerCase()
              .startsWith(textEditingValue.text.toLowerCase())
          )
              .toList();
        },
        displayStringForOption: (Continent option) => option.name,
        fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted
            ) {
          return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
        onSelected: (Continent selection) {
          print('Selected: ${selection.name}');
        },
        optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<Continent> onSelected,
            Iterable<Continent> options
            ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: 300.0,
                color: Colors.teal,
                child: ListView.builder(
                  padding: EdgeInsets.all(5.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Continent option = options.elementAt(index);

                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option.name, style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Continent {

  const Continent({
    @required this.name,
    @required this.size,
  });

  final String name;
  final int size;

  @override
  String toString() {
    return '$name ($size)';
  }
}

const List<Continent> continentOptions = <Continent>[
  Continent(name: 'Africa', size: 30370000),
  Continent(name: 'Antarctica', size: 14000000),
  Continent(name: 'Asia', size: 44579000),
  Continent(name: 'Australia', size: 8600000),
  Continent(name: 'Europe', size: 10180000),
  Continent(name: 'North America', size: 24709000),
  Continent(name: 'South America', size: 17840000),
];