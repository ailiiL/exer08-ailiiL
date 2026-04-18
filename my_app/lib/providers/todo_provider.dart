import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/api/firebase_expenses_api.dart';
import '../../../../models/todo_model.dart';

class ExpensesListProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _expensesStream;
  final FirebaseExpensesApi firebaseService = FirebaseExpensesApi();

  ExpensesListProvider() {
    fetchExpenses();
  }

  // getter
  Stream<QuerySnapshot> get todo => _expensesStream;

  // TODO: get all todo items from Firestore
  void fetchExpenses() {
    _expensesStream = firebaseService.getAllExpenses();
    notifyListeners();
  }

  // TODO: add todo item and store it in Firestore
  Future<void> addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson());
    print(message);
    notifyListeners();
  }

  // TODO: edit a todo item and update it in Firestore
  Future<void> editTodo(String id, String newTitle) async {
    String message = await firebaseService.editTodo(id,newTitle);
    print(message);
    notifyListeners();
  }

  // TODO: delete a todo item and update it in Firestore
  Future<void> deleteTodo(String id) async {
    String message = await firebaseService.deleteTodo(id);
    print(message);
    notifyListeners();
  }

  // TODO: modify a todo status and update it in Firestore
  Future<void> toggleStatus(String id, bool status) async {
    String message = await firebaseService.toggleStatus(id,status);
    print(message);
    notifyListeners();
  }
}
