class AppConfig {
  static const String appName = 'FinWatch';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Smart Financial Tracking & Analytics';
  
  // API Configuration
  static const String baseUrl = 'https://api.finwatch.com';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Firebase Configuration
  static const String firebaseProjectId = 'finwatch-app';
  
  // Hive Box Names
  static const String userBox = 'user_box';
  static const String transactionBox = 'transaction_box';
  static const String settingsBox = 'settings_box';
  static const String budgetBox = 'budget_box';
  
  // Notification Channels
  static const String transactionChannelId = 'transaction_notifications';
  static const String budgetChannelId = 'budget_notifications';
  static const String reminderChannelId = 'reminder_notifications';
  
  // Supported Currencies
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'SEK'
  ];
  
  // Transaction Categories
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Bills & Utilities',
    'Entertainment',
    'Healthcare',
    'Education',
    'Travel',
    'Groceries',
    'Fuel',
    'Other'
  ];
  
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Rental',
    'Gift',
    'Refund',
    'Other'
  ];
  
  // App Limits
  static const int maxTransactionsPerPage = 50;
  static const int maxExportRecords = 10000;
  static const double maxTransactionAmount = 1000000.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Chart Colors
  static const List<String> chartColors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
    '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
  ];
}