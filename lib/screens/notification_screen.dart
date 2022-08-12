import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import '../utils/global_vairable.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Activity',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(
                '/users/${FirebaseAuth.instance.currentUser!.uid}/activity')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return circularIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var activityItem = ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 22,
                  backgroundImage: NetworkImage(doc['profilePic']),
                ),
                title: Row(
                  children: [
                    Text(
                      '${doc['name']} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Text(
                        !doc['isLike']
                            ? 'commented on your post'
                            : 'liked your post',
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(doc['datePublished'].toString()))
                      .toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    doc['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              );
              return activityItem;
            },
          );
        },
      ),
    );
  }
}
