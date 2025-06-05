import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../../features/auth/data/models/user_model.dart';

class HiveService {
  static late Box<UserModel> _userBox;
  static late Box<TransactionModel> _transactionBox;
  static late Box _settingsBox;
  static late Box _budgetBox;

  static Future<void> init() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TransactionTypeAdapter());
    }

    // Open boxes
    _userBox = await Hive.openBox<UserModel>(AppConfig.userBox);
    _transactionBox = await Hive.openBox<TransactionModel>(AppConfig.transactionBox);
    _settingsBox = await Hive.openBox(AppConfig.settingsBox);
    _budgetBox = await Hive.openBox(AppConfig.budgetBox);
  }

  // User operations
  static Box<UserModel> get userBox => _userBox;
  
  static Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }
  
  static UserModel? getCurrentUser() {
    return _userBox.get('current_user');
  }
  
  static Future<void> clearUser() async {
    await _userBox.delete('current_user');
  }

  // Transaction operations
  static Box<TransactionModel> get transactionBox => _transactionBox;
  
  static Future<void> saveTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }
  
  static Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final Map<String, TransactionModel> transactionMap = {
      for (var transaction in transactions) transaction.id: transaction
    };
    await _transactionBox.putAll(transactionMap);
  }
  
  static List<TransactionModel> getAllTransactions() {
    return _transactionBox.values.toList();
  }
  
  static TransactionModel? getTransaction(String id) {
    return _transactionBox.get(id);
  }
  
  static Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }
  
  static Future<void> clearAllTransactions() async {
    await _transactionBox.clear();
  }

  // Settings operations
  static Box get settingsBox => _settingsBox;
  
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }
  
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }
  
  static Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Budget operations
  static Box get budgetBox => _budgetBox;
  
  static Future<void> saveBudget(String category, double amount) async {
    await _budgetBox.put(category, amount);
  }
  
  static double? getBudget(String category) {
    return _budgetBox.get(category) as double?;
  }
  
  static Map<String, double> getAllBudgets() {
    final Map<String, double> budgets = {};
    for (var key in _budgetBox.keys) {
      budgets[key.toString()] = _budgetBox.get(key) as double;
    }
    return budgets;
  }
  
  static Future<void> deleteBudget(String category) async {
    await _budgetBox.delete(category);
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await _userBox.clear();
    await _transactionBox.clear();
    await _settingsBox.clear();
    await _budgetBox.clear();
  }
  
  static Future<void> closeBoxes() async {
    await _userBox.close();
    await _transactionBox.close();
    await _settingsBox.close();
    await _budgetBox.close();
  }
}