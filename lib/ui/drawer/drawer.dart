import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
      child: Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[buildProductDetailsIcon()],
        )),
      ),
    );
  }

  buildProductDetailsIcon() {
    return const ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
    );
  }
}
