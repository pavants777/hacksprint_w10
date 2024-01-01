import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Screens/Search/groupDesign.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = TextEditingController();
  late FocusNode focusNode;
  bool isInFocus = false;
  bool isTitle = true;
  Set<String> suggestedTags = <String>{};

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
    if (mounted) {
      List<String> tags = await FirebaseFunction.getAllTags(context);
      setState(() {
        suggestedTags = tags.map((e) => e).toSet();
      });
    }
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
      const SizedBox(height: 10),
      const Text('Suggested Tags'),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: suggestedTags.map((tag) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _search.text = tag;
                    isTitle = false;
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

  Widget _searchGroupBuild(String search) {
    return StreamBuilder(
      stream:
          Stream.fromFuture(FirebaseFunction.getSearchGroup(context, search)),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GroupModels>? groups = snapshot.data;
        if (groups!.isEmpty) {
          return const Center(
            child: Text('No Groups Found'),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: groups.length,
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
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.only(left: 10), child: CompanyLogo(100, 100)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: AnimatedCrossFade(
          firstChild: Title(),
          secondChild: Search(),
          crossFadeState:
              isTitle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 100),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isTitle = !isTitle;
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          _search.text.isNotEmpty
              ? _searchGroupBuild(_search.text)
              : _buildTags(),
        ],
      ),
    );
  }

  Widget Title() {
    return Text(
      "Search Groups",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.yellow,
      ),
    );
  }

  Widget Search() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: _search,
        onChanged: (value) {
          _searchGroupBuild(value);
        },
        focusNode: focusNode,
        enableSuggestions: false,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Group Search......',
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.black,
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: Colors.grey.shade100,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }
}
