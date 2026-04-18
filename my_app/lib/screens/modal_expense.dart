import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class ExpenseModal extends StatelessWidget {
  final String type;
  final Expense? item;
  final TextEditingController _nameformFieldController =
      TextEditingController();
  final TextEditingController _descformFieldController =
      TextEditingController();
  final TextEditingController _amountformFieldController =
      TextEditingController();

  final List<String> categories = [
    'Bills',
    'Transportation',
    'Food',
    'Utilities',
    'Health',
    'Entertainment',
    'Miscellaneous',
  ];

  String? selectedCategory;

  ExpenseModal({super.key, required this.type, this.item}) {
    if (item != null) {
      selectedCategory = item!.category;
    }
  }

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new expense");
      case 'Edit':
        return const Text("Edit expense");
      case 'Delete':
        return const Text("Delete expense");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text("Are you sure you want to delete '${item!.name}'?");
        }
      // Edit and add will have input field in them
      default:
        return Column(
          children: [
            TextField(
              controller: _nameformFieldController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: item != null ? item!.name : '',
                labelText: "Name",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descformFieldController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: item != null ? item!.desc : '',
                labelText: "Description",
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Category",
              ),
              items: categories.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (String? value) {
                selectedCategory = value;
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountformFieldController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Amount",
              ),
            ),
          ],
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
              Expense temp = Expense(
                paid: false,
                name: _nameformFieldController.text,
                desc: _descformFieldController.text,
                category: selectedCategory ?? 'Others',
                amount: int.tryParse(_amountformFieldController.text) ?? 0,
              );

              context.read<ExpensesListProvider>().addExpense(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }

          case 'Delete':
            {
              context.read<ExpensesListProvider>().deleteExpense(item!.id!);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
