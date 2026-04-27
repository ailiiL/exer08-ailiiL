import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class ExpenseModal extends StatefulWidget {
  final String type;
  final Expense? item;

  const ExpenseModal({
    super.key,
    required this.type,
    this.item,
  });

  @override
  State<ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends State<ExpenseModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

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

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descController.text = widget.item!.desc;
      _amountController.text = widget.item!.amount.toString();
      selectedCategory = widget.item!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Text _buildTitle() {
    switch (widget.type) {
      case 'Add':
        return const Text('Add Expense');
      case 'Edit':
        return const Text('Edit Expense');
      case 'Delete':
        return const Text('Delete Expense');
      default:
        return const Text('');
    }
  }

  Widget _buildContent() {
    if (widget.type == 'Delete') {
      return Text(
        "Are you sure you want to delete '${widget.item!.name}'?",
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // NAME TEXTFORMFIELD
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name is too short';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // DESCRIPTION TEXTFORMFIELD
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != null && value.length > 100) {
                  return 'Max 100 characters only';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // CATEGORY DROPFDOWN
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // AMOUNT TEXTFORMFIELD
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixText: '₱ ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }

                final number = int.tryParse(value);
                if (number == null) {
                  return 'Enter a valid number';
                }

                if (number <= 0) {
                  return 'Amount must be greater than 0';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // VALIDATION
  void _submit() {
    if (widget.type != 'Delete') {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    // ADD TEXT BUTTON
    switch (widget.type) {
      case 'Add':
        final expense = Expense(
          paid: false,
          name: _nameController.text.trim(),
          desc: _descController.text.trim(),
          category: selectedCategory!,
          amount: int.parse(_amountController.text),
        );

        context.read<ExpensesListProvider>().addExpense(expense);
        break;
      // EDIT TEXT BUTTON
      case 'Edit':
        final updatedExpense = Expense(
          id: widget.item!.id,
          paid: widget.item!.paid,
          name: _nameController.text.trim(),
          desc: _descController.text.trim(),
          category: selectedCategory!,
          amount: int.parse(_amountController.text),
        );

        context.read<ExpensesListProvider>().editExpense(updatedExpense);
        break;
      //DELETE TEXT BUTTON
      case 'Delete':
        context.read<ExpensesListProvider>().deleteExpense(
          widget.item!.id!,
        );
        break;
    }

    Navigator.pop(context);
  }
  //DIALOG
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: [
        TextButton(
          onPressed: _submit,
          child: Text(widget.type),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}