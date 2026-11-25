import 'dart:convert';
import 'dart:io';

/// Reads a JSON fixture recorded from the real provider.
Map<String, dynamic> fixtureJson(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync())
        as Map<String, dynamic>;

String fixtureString(String name) =>
    File('test/fixtures/$name').readAsStringSync();
