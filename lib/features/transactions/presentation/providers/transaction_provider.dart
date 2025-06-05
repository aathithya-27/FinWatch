import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/hive_service.dart';
import '../../../../core/utils/demo_data.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/entities/transaction_entity.dart';

// Transaction summary model
class TransactionSummary {
  final double totalIncome;
  final double totalExpense;
  final double totalBalance;
  final int transactionCount;

  TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBalance,
    required this.transactionCount,
  });
}

// Transactions provider
final transactionsProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<List<TransactionEntity>>>(
  (ref) => TransactionNotifier(),
);

class TransactionNotifier extends StateNotifier<AsyncValue<List<TransactionEntity>>> {
  TransactionNotifier() : super(const AsyncValue.loading()) {
    _loadTransactions();
  }

  final _uuid = const Uuid();

  Future<void> _loadTransactions() async {
    try {
      var transactions = HiveService.getAllTransactions()
          .map((model) => model.toEntity())
          .toList();
      
      // If no transactions exist, generate demo data
      if (transactions.isEmpty) {
        final demoTransactions = DemoDataGenerator.generateDemoTransactions(count: 30);
        
        // Save demo transactions to Hive
        for (final transaction in demoTransactions) {
          final model = TransactionModel.fromEntity(transaction);
          await HiveService.saveTransaction(model);
        }
        
        transactions = demoTransactions;
      }
      
      // Sort by date (newest first)
      transactions.sort((a, b) => b.date.compareTo(a.date));
      
      state = AsyncValue.data(transactions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await HiveService.saveTransaction(model);
      
      // Update state
      final currentTransactions = state.value ?? [];
      final updatedTransactions = [transaction, ...currentTransactions];
      updatedTransactions.sort((a, b) => b.date.compareTo(a.date));
      
      state = AsyncValue.data(updatedTransactions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await HiveService.saveTransaction(model);
      
      // Update state
      final currentTransactions = state.value ?? [];
      final updatedTransactions = currentTransactions.map((t) {
        return t.id == transaction.id ? transaction : t;
      }).toList();
      updatedTransactions.sort((a, b) => b.date.compareTo(a.date));
      
      state = AsyncValue.data(updatedTransactions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await HiveService.deleteTransaction(id);
      
      // Update state
      final currentTransactions = state.value ?? [];
      final updatedTransactions = currentTransactions.where((t) => t.id != id).toList();
      
      state = AsyncValue.data(updatedTransactions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshTransactions() async {
    state = const AsyncValue.loading();
    await _loadTransactions();
  }

  // Create a new transaction with generated ID
  TransactionEntity createTransaction({
    required double amount,
    required String description,
    required String category,
    required TransactionType type,
    DateTime? date,
    String? source,
    String? destination,
    String? notes,
    bool isRecurring = false,
    String? recurringPattern,
    List<String>? tags,
    String? location,
    String? paymentMethod,
    bool isAutoDetected = false,
    String? originalMessage,
    required String userId,
  }) {
    final now = DateTime.now();
    return TransactionEntity(
      id: _uuid.v4(),
      amount: amount,
      description: description,
      category: category,
      type: type,
      date: date ?? now,
      source: source,
      destination: destination,
      notes: notes,
      isRecurring: isRecurring,
      recurringPattern: recurringPattern,
      tags: tags,
      location: location,
      paymentMethod: paymentMethod,
      isAutoDetected: isAutoDetected,
      originalMessage: originalMessage,
      createdAt: now,
      updatedAt: now,
      userId: userId,
    );
  }
}

// Transaction summary provider
final transactionSummaryProvider = Provider<AsyncValue<TransactionSummary>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      double totalIncome = 0;
      double totalExpense = 0;
      
      for (final transaction in transactions) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalExpense += transaction.amount;
        }
      }
      
      final summary = TransactionSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        totalBalance: totalIncome - totalExpense,
        transactionCount: transactions.length,
      );
      
      return AsyncValue.data(summary);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Recent transactions provider (last 5)
final recentTransactionsProvider = Provider<AsyncValue<List<TransactionEntity>>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final recentTransactions = transactions.take(5).toList();
      return AsyncValue.data(recentTransactions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Transactions by date range provider
final transactionsByDateRangeProvider = Provider.family<AsyncValue<List<TransactionEntity>>, DateRange>((ref, dateRange) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final filteredTransactions = transactions.where((transaction) {
        return transaction.date.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
               transaction.date.isBefore(dateRange.end.add(const Duration(days: 1)));
      }).toList();
      
      return AsyncValue.data(filteredTransactions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Transactions by category provider
final transactionsByCategoryProvider = Provider.family<AsyncValue<List<TransactionEntity>>, String>((ref, category) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final filteredTransactions = transactions.where((transaction) {
        return transaction.category.toLowerCase() == category.toLowerCase();
      }).toList();
      
      return AsyncValue.data(filteredTransactions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Today's transactions provider
final todayTransactionsProvider = Provider<AsyncValue<List<TransactionEntity>>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final todayTransactions = transactions.where((transaction) {
        return transaction.date.isAfter(startOfDay) && transaction.date.isBefore(endOfDay);
      }).toList();
      
      return AsyncValue.data(todayTransactions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// This week's transactions provider
final thisWeekTransactionsProvider = Provider<AsyncValue<List<TransactionEntity>>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endOfWeek = startOfWeekDay.add(const Duration(days: 7));
      
      final weekTransactions = transactions.where((transaction) {
        return transaction.date.isAfter(startOfWeekDay) && transaction.date.isBefore(endOfWeek);
      }).toList();
      
      return AsyncValue.data(weekTransactions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// This month's transactions provider
final thisMonthTransactionsProvider = Provider<AsyncValue<List<TransactionEntity>>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 1);
      
      final monthTransactions = transactions.where((transaction) {
        return transaction.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) && 
               transaction.date.isBefore(endOfMonth);
      }).toList();
      
      return AsyncValue.data(monthTransactions);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Category spending provider
final categorySpendingProvider = Provider<AsyncValue<Map<String, double>>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      final Map<String, double> categorySpending = {};
      
      for (final transaction in transactions) {
        if (transaction.type == TransactionType.expense) {
          categorySpending[transaction.category] = 
              (categorySpending[transaction.category] ?? 0) + transaction.amount;
        }
      }
      
      return AsyncValue.data(categorySpending);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Date range class
class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});
}