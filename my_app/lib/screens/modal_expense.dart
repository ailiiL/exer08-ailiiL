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

    // Pre-fill fields when editing
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

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
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
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    switch (widget.type) {

      case 'Add':
        final expense = Expense(
          paid: false,
          name: _nameController.text,
          desc: _descController.text,
          category: selectedCategory ?? 'Bills',
          amount: int.tryParse(_amountController.text) ?? 0,
        );

        context.read<ExpensesListProvider>().addExpense(expense);
        break;

      case 'Edit':
        final updatedExpense = Expense(
          id: widget.item!.id,
          paid: widget.item!.paid,
          name: _nameController.text,
          desc: _descController.text,
          category: selectedCategory ?? 'Bills',
          amount: int.tryParse(_amountController.text) ?? 0,
        );

        context.read<ExpensesListProvider>().editExpense(updatedExpense);
        break;

      case 'Delete':
        context.read<ExpensesListProvider>().deleteExpense(
          widget.item!.id!,
        );
        break;
    }

    Navigator.pop(context);
  }

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