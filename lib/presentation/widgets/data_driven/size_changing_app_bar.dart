import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/model/sort_rules.dart';
import 'package:hosco/presentation/features/products/products.dart';
import 'package:hosco/presentation/features/products/views/visual_filter.dart';
import 'package:hosco/presentation/widgets/independent/view_options.dart';

class SizeChangingAppBar extends StatelessWidget {
  final String title;
  final FilterRules filterRules;
  final SortRules sortRules;
  final bool isListView;
  final Function(FilterRules) onFilterRulesChanged;
  final Function(SortRules) onSortRulesChanged;
  final VoidCallback onViewChanged;

  // bool isSearchClicked = false;
  //final TextEditingController _filter = TextEditingController();

  const SizeChangingAppBar(
      {Key key,
      this.title,
      @required this.filterRules,
      this.sortRules,
      this.isListView = true,
      this.onFilterRulesChanged,
      this.onSortRulesChanged,
      this.onViewChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppSizes.app_bar_expanded_size,
      /*title: Container(
        height: 36.0,
        width: double.infinity,
        child: Center(
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: CupertinoTextField(
              keyboardType: TextInputType.text,
              placeholder: 'Search',
              prefix: Padding(
                padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                child: Icon(Icons.search, color: Colors.black,),
              ),
            ),
          ),
        ),
      ),*/
      actions: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),

        child: Row(
          children: <Widget>[
            SizedBox(
              width: AppSizes.app_bar_expanded_size + 130,
              child:
            TextField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                style: Theme.of(context).textTheme.subtitle2,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 14),
                    hintText: 'Tìm kiếm...'),
                onSubmitted: (val) { print(val);},
              ),
            ),
            // Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () { print('val');  },),
          ],
        ),
      ),
        /*
        Expanded(
          child: TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.go,
            //style: _theme.textTheme.subtitle2,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 14),
                hintText: 'Tìm kiếm...'),
            onSubmitted: (val) { print(val);},
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: null, //TODO add search
        )*/
      ],
      floating: true,
      primary: true,
      snap: false,
      pinned: false,
      /*bottom: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ,
      ),*/
      flexibleSpace: FlexibleSpaceBar(

        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                title ?? 'Loading...',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            /*
            Container(
              height: 30,
              child: VisualFilter(
                  filterRules?.hashTags, filterRules?.selectedHashTags,
                  (updateValue, isSelected) {
                BlocProvider.of<ProductsBloc>(context).add(
                    ProductChangeHashTagEvent(updateValue, isSelected));
              }),
            ),*/
            OpenFlutterViewOptions(
              sortRules: sortRules,
              filterRules: filterRules,
              isListView: isListView,
              onChangeViewClicked: onViewChanged,
              onFilterChanged: onFilterRulesChanged,
              onSortChanged: onSortRulesChanged,
            ),
          ],
        ),
      ),
    );
  }
}
