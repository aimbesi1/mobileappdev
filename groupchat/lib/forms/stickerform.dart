import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../model/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StickerForm extends StatefulWidget {
  const StickerForm({Key? key}) : super(key: key);

  @override
  State<StickerForm> createState() => _StickerFormState();
}

class _StickerFormState extends State<StickerForm> {
  final _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(crossAxisCount: 3, children: [])),
    );
  }

  // Widget stickerTile(BuildContext context, String img) {}
}
