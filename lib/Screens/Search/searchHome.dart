import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Screens/Search/groupDesign.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _search = TextEditingController();
  late FocusNode focusNode;
  bool isInFocus = false;
  Set<String> suggestedTags = Set<String>();

  @override
  void initState() {
    super.initState();
    getTags();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        isInFocus = focusNode.hasFocus;
      });
    });
  }

  getTags() async {
    List<String> tags = await FirebaseFunction.getAllTags(context);
    setState(() {
      suggestedTags = tags.map((e) => e).toSet();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _removeTag(String tag) {
    setState(() {
      suggestedTags.remove(tag);
    });
  }

  Widget _buildTags() {
    return Column(children: [
      SizedBox(height: 10),
      Text('Suggested Tags'),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: suggestedTags.map((tag) {
            return Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _search.text = tag;
                    focusNode.hasFocus;
                  });
                },
                child: Chip(
                  label: Text(tag),
                  onDeleted: () => _removeTag(tag),
                ),
              ),
            );
          }).toList(),
        ),
      )
    ]);
  }

  Widget _searchGroupBuild(String _search) {
    return StreamBuilder(
      stream:
          Stream.fromFuture(FirebaseFunction.getSearchGroup(context, _search)),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GroupModels>? groups = snapshot.data;
        if (groups!.isEmpty || groups == null) {
          return Center(
            child: Text('No Groups Found'),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: groups!.length,
            itemBuilder: (context, index) {
              return GroupDesign(groupuid: groups[index].groupId);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: TextField(
              controller: _search,
              onChanged: (value) {
                _searchGroupBuild(value);
              },
              focusNode: focusNode,
              enableSuggestions: false,
              style: TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Group Search......',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.black,
                contentPadding: EdgeInsets.all(16),
                filled: true,
                fillColor: Colors.grey.shade100,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          !_search.text.isEmpty
              ? _searchGroupBuild(_search.text)
              : _buildTags(),
        ],
      ),
    );
  }
}
