import 'package:flutter/material.dart';

Widget buildBlogsSection() {
  return ListView.builder(
    itemCount: 3,
    itemBuilder: (context, index) {
      return const Card(
        elevation: 3,
        child: ListTile(
          leading: Icon(Icons.article, color: Colors.green),
          title: Text("Blog Title"),
          subtitle: Text("Short description of the blog..."),
          trailing: Icon(Icons.arrow_forward, color: Colors.green),
        ),
      );
    },
  );
}
