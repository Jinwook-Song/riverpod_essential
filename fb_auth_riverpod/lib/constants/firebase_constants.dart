import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final fbAuthService = FirebaseAuth.instance;
final usersCollectoin = FirebaseFirestore.instance.collection('users');
