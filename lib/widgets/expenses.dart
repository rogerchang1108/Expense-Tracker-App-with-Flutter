import 'package:flutter/material.dart';

import 'package:test_dart/widgets/new_expense.dart';
import 'package:test_dart/widgets/expenses_list/expenses_list.dart';
import 'package:test_dart/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  Map<Category, double> _countExpensesByCategory() {
    final countMap = {
      Category.food: 0.0,
      Category.travel: 0.0,
      Category.leisure: 0.0,
      Category.work: 0.0,
    };

    for (final expense in _registeredExpenses) {
      countMap[expense.category] = countMap[expense.category]! + expense.amount;
    }

    return countMap;
  }
  
  Map<Category, double> _calculateBarHeights(Map<Category, double> countMap) {
    final maxCount = countMap.values.fold(0.0, (prev, element) => element > prev ? element : prev);

    final Map<Category, double> barHeights = {};
    for (final category in countMap.keys) {
      barHeights[category] = (countMap[category]! / maxCount) * 100;
    }
    return barHeights;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;
    final countMap = _countExpensesByCategory();
    final barHeights = _calculateBarHeights(countMap);

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                child: Row(
                  children: [
                    for (final category in countMap.keys)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 90,
                              height: barHeights[category],
                              color: themeColor,
                            ),
                            Icon(
                              categoryIcons[category],
                              color: themeColor,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
