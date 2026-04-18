import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import 'modal_todo.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> expensesStream = context.watch<ExpensesListProvider>().expense;

    return Scaffold(
      appBar: AppBar(title: const Text("Expenses")),
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

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Expense expense = Expense.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              expense.id = snapshot.data?.docs[index].id;
              return Dismissible(
                key: Key(expense.id.toString()),
                onDismissed: (direction) {
                  context.read<ExpensesListProvider>().deleteExpense(expense.id!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${expense.name} dismissed')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(expense.name),
                  leading: Checkbox(
                    value: expense.paid,
                    onChanged: (bool? value) {
                      context.read<ExpensesListProvider>().toggleStatus(
                        expense.id!,
                        value!,
                      );
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext context) =>
                                    TodoModal(type: 'Edit', item: expense),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext context) =>
                                    TodoModal(type: 'Delete', item: expense),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(type: 'Add'),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
