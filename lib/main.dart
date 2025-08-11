import 'package:flutter/material.dart';

import 'UI/home_screen.dart';

void main() {
  runApp(const AuditScannerApp());
}

class AuditScannerApp extends StatelessWidget {
  const AuditScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audit Scanner',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );  
  }
}
