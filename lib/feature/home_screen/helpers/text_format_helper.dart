import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

Widget buildSectionContent(String content) {
  return Text(
    content,
    style: const TextStyle(fontSize: 14),
  );
}
