import 'package:cloud_firestore/cloud_firestore.dart';
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

  // get all expenses from Firestore
  void fetchExpenses() {
    _expensesStream = firebaseService.getAllExpenses();
    notifyListeners();
  }

  // add an expense and store it in Firestore
  Future<void> addExpense(Expense item) async {
    String message = await firebaseService.addExpense(item.toJson());
    print(message);
    notifyListeners();
  }

  // edit an expense and update it in Firestore
  Future<void> editExpense(Expense expense) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toJson());
  }

  // delete an expense item and update it in Firestore
  Future<void> deleteExpense(String id) async {
    String message = await firebaseService.deleteExpense(id);
    print(message);
    notifyListeners();
  }

  // modify expense paid status and update it in Firestore
  Future<void> toggleStatus(String id, bool status) async {
    String message = await firebaseService.toggleStatus(id, status);
    print(message);
    notifyListeners();
  }
}
