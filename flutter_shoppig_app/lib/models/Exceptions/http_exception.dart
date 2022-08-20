//package
import 'package:flutter/material.dart';

class HTTPException implements Exception {
  final String message;

  HTTPException({required this.message});

  @override
  String toString() {
    return message;
  }
}
