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
      title: 'Guitar Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Dune: Part Two',
      amount: 9.99,
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
      for (var category in Category.values) category: 0.0,
    };

    for (final expense in _registeredExpenses) {
      countMap[expense.category] = countMap[expense.category]! + expense.amount;
    }

    final sortedEntries = countMap.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final sortedMap = Map.fromEntries(sortedEntries);

    return sortedMap;
  }
  
  Map<Category, double> _calculateBarHeights(Map<Category, double> countMap) {
    final maxCount = countMap.values.fold(0.0, (prev, element) => element > prev ? element : prev);
    
    final double availableHeight = MediaQuery.of(context).size.height * 0.2 - 41;
    if (availableHeight <= 0) {
      return {};
    }

    final Map<Category, double> barHeights = {};
    for (final category in countMap.keys) {
      double finalHeight = (countMap[category]! / maxCount) * availableHeight;
      if (finalHeight != 0) {
        barHeights[category] = finalHeight < 1 ? 1 : finalHeight;
      } else {
        barHeights[category] = 0;
      }
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
    
    Widget barChart = Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Row(
            children: [
              for (final category in countMap.keys)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / (countMap.length * 1.5),
                        height: barHeights[category],
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
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
    );

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
          barChart,
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
