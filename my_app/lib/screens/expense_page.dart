import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import 'modal_expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of expenses in the provider
    Stream<QuerySnapshot> expensesStream = context
        .watch<ExpensesListProvider>()
        .expense;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: expensesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error encountered! ${snapshot.error}"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Expenses Found"));
          }
          // EXPENSES LIST TILES
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Expense expense = Expense.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              expense.id = snapshot.data?.docs[index].id;
              return ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ExpenseModal(type: 'Edit', item: expense),  //EDIT EXPENSE
                  );
                },
                // NAME
                title: Text(
                  expense.name,
                  style: TextStyle(
                    decoration: expense.paid
                        ? TextDecoration.lineThrough
                        : null,
                    color: expense.paid ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: expense.paid
                    ? const Text("Paid", style: TextStyle(color: Colors.green))
                    : null,
                // PAID STATUS
                leading: Checkbox(
                  value: expense.paid,
                  onChanged: (bool? value) {
                    context.read<ExpensesListProvider>().toggleStatus(
                      expense.id!,
                      value!,
                    );
                  },
                ),
                // DELETE EXPENSE
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          ExpenseModal(type: 'Delete', item: expense),
                    );
                  },
                  icon: const Icon(Icons.delete_outlined),
                ),
              );
            }),
          );
        },
      ),
      // ADD EXPENSE
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ExpenseModal(type: 'Add'),
          );
        },
        child: const Icon(Icons.attach_money_rounded, color: Colors.white),
      ),
    );
  }
}
