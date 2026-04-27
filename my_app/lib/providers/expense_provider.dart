import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/api/firebase_expenses_api.dart';
import '../models/expense_model.dart';

class ExpensesListProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _expensesStream;
  final FirebaseExpensesApi firebaseService = FirebaseExpensesApi();

  ExpensesListProvider() {
    fetchExpenses();
  }

  // getter
  Stream<QuerySnapshot> get expense => _expensesStream;

  // TODO: get all todo items from Firestore
  void fetchExpenses() {
    _expensesStream = firebaseService.getAllExpenses();
    notifyListeners();
  }

  // TODO: add todo item and store it in Firestore
  Future<void> addExpense(Expense item) async {
    String message = await firebaseService.addExpense(item.toJson());
    print(message);
    notifyListeners();
  }

  // TODO: edit a todo item and update it in Firestore
  // Future<void> editExpense(String id, String newName, String newDesc, String newCategory, int newAmount) async {
  //   String message = await firebaseService.editExpense(id, newName, newDesc, newCategory, newAmount);
  //   print(message);
  //   notifyListeners();
  // }

  Future<void> editExpense(Expense expense) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toJson());
  }

  // TODO: delete a todo item and update it in Firestore
  Future<void> deleteExpense(String id) async {
    String message = await firebaseService.deleteExpense(id);
    print(message);
    notifyListeners();
  }

  // TODO: modify a todo status and update it in Firestore
  Future<void> toggleStatus(String id, bool status) async {
    String message = await firebaseService.toggleStatus(id, status);
    print(message);
    notifyListeners();
  }
}
