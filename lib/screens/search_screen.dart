// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _isShowUsers = false;
  bool _isTyping = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Row(
            children: [
              _isTyping
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTyping = false;
                            _isShowUsers = false;
                            searchController.text = '';
                          });
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        _isTyping = true;
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: !_isTyping
                            ? const Icon(
                                Icons.search,
                                color: Colors.grey,
                              )
                            : null,
                        fillColor: const Color(0xFF141318),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(8)),
                    style: const TextStyle(fontSize: 14),
                    onFieldSubmitted: (_) {
                      setState(() {
                        _isShowUsers = true;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            _isShowUsers
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('username',
                            isGreaterThanOrEqualTo:
                                searchController.text.trim())
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      print(snapshot);
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(doc['photoUrl']),
                            ),
                            title: Text(doc['username']),
                            subtitle: Text(doc['bio']),
                          );
                        },
                      );
                    },
                  )
                : FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection('posts').get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                          child: StaggeredGridView.countBuilder(
                        crossAxisCount: 3,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ),
                        staggeredTileBuilder: (index) => StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1,
                          (index % 7 == 0) ? 2 : 1,
                        ),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ));
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
