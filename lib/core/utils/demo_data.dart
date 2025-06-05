import 'dart:math';
import '../../features/transactions/domain/entities/transaction_entity.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../config/app_config.dart';

class DemoDataGenerator {
  static final Random _random = Random();
  
  static List<TransactionEntity> generateDemoTransactions({int count = 50}) {
    final transactions = <TransactionEntity>[];
    final now = DateTime.now();
    
    for (int i = 0; i < count; i++) {
      final daysAgo = _random.nextInt(90); // Last 90 days
      final date = now.subtract(Duration(days: daysAgo));
      
      final isExpense = _random.nextBool();
      final type = isExpense ? TransactionType.expense : TransactionType.income;
      
      final category = isExpense 
          ? AppConfig.expenseCategories[_random.nextInt(AppConfig.expenseCategories.length)]
          : AppConfig.incomeCategories[_random.nextInt(AppConfig.incomeCategories.length)];
      
      final amount = _generateAmount(type, category);
      final description = _generateDescription(type, category);
      
      transactions.add(TransactionEntity(
        id: 'demo_${i}_${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        description: description,
        category: category,
        type: type,
        date: date,
        source: _generateSource(type),
        destination: _generateDestination(type),
        notes: _generateNotes(),
        isRecurring: _random.nextDouble() < 0.1, // 10% chance
        tags: _generateTags(),
        location: _generateLocation(),
        paymentMethod: _generatePaymentMethod(),
        isAutoDetected: _random.nextDouble() < 0.7, // 70% auto-detected
        originalMessage: _generateOriginalMessage(type, amount, description),
        createdAt: date,
        updatedAt: date,
        userId: 'demo_user',
      ));
    }
    
    // Sort by date (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));
    
    return transactions;
  }
  
  static double _generateAmount(TransactionType type, String category) {
    switch (type) {
      case TransactionType.income:
        switch (category) {
          case 'Salary':
            return 3000 + _random.nextDouble() * 2000; // $3000-5000
          case 'Freelance':
            return 500 + _random.nextDouble() * 1500; // $500-2000
          case 'Investment':
            return 100 + _random.nextDouble() * 900; // $100-1000
          default:
            return 50 + _random.nextDouble() * 450; // $50-500
        }
      case TransactionType.expense:
        switch (category) {
          case 'Food & Dining':
            return 10 + _random.nextDouble() * 90; // $10-100
          case 'Shopping':
            return 25 + _random.nextDouble() * 275; // $25-300
          case 'Transportation':
            return 5 + _random.nextDouble() * 95; // $5-100
          case 'Bills & Utilities':
            return 50 + _random.nextDouble() * 200; // $50-250
          case 'Entertainment':
            return 15 + _random.nextDouble() * 85; // $15-100
          case 'Healthcare':
            return 30 + _random.nextDouble() * 470; // $30-500
          case 'Education':
            return 100 + _random.nextDouble() * 900; // $100-1000
          case 'Travel':
            return 200 + _random.nextDouble() * 800; // $200-1000
          case 'Groceries':
            return 20 + _random.nextDouble() * 130; // $20-150
          case 'Fuel':
            return 30 + _random.nextDouble() * 70; // $30-100
          default:
            return 10 + _random.nextDouble() * 190; // $10-200
        }
      case TransactionType.transfer:
        return 100 + _random.nextDouble() * 900; // $100-1000
    }
  }
  
  static String _generateDescription(TransactionType type, String category) {
    final descriptions = {
      'Food & Dining': [
        'McDonald\'s',
        'Starbucks Coffee',
        'Pizza Hut',
        'Subway',
        'Local Restaurant',
        'Food Delivery',
        'Burger King',
        'Domino\'s Pizza',
        'KFC',
        'Taco Bell'
      ],
      'Shopping': [
        'Amazon Purchase',
        'Target',
        'Walmart',
        'Best Buy',
        'Online Shopping',
        'Clothing Store',
        'Electronics',
        'Home Depot',
        'Costco',
        'eBay Purchase'
      ],
      'Transportation': [
        'Uber Ride',
        'Gas Station',
        'Public Transit',
        'Taxi',
        'Lyft',
        'Parking Fee',
        'Car Maintenance',
        'Bus Ticket',
        'Train Ticket',
        'Car Wash'
      ],
      'Bills & Utilities': [
        'Electric Bill',
        'Internet Bill',
        'Phone Bill',
        'Water Bill',
        'Gas Bill',
        'Cable TV',
        'Insurance',
        'Rent Payment',
        'Mortgage',
        'Credit Card Payment'
      ],
      'Entertainment': [
        'Netflix',
        'Spotify',
        'Movie Theater',
        'Concert Ticket',
        'Gaming',
        'YouTube Premium',
        'Apple Music',
        'Disney+',
        'HBO Max',
        'Event Ticket'
      ],
      'Healthcare': [
        'Doctor Visit',
        'Pharmacy',
        'Dental Care',
        'Hospital',
        'Health Insurance',
        'Prescription',
        'Medical Test',
        'Therapy',
        'Gym Membership',
        'Vitamins'
      ],
      'Groceries': [
        'Whole Foods',
        'Safeway',
        'Kroger',
        'Trader Joe\'s',
        'Local Market',
        'Organic Store',
        'Supermarket',
        'Fresh Produce',
        'Meat Market',
        'Bakery'
      ],
      'Salary': [
        'Monthly Salary',
        'Payroll Deposit',
        'Salary Credit',
        'Wage Payment',
        'Direct Deposit'
      ],
      'Freelance': [
        'Client Payment',
        'Project Payment',
        'Consulting Fee',
        'Design Work',
        'Writing Payment'
      ],
      'Investment': [
        'Dividend Payment',
        'Stock Sale',
        'Bond Interest',
        'Crypto Gain',
        'Investment Return'
      ],
    };
    
    final categoryDescriptions = descriptions[category] ?? ['Transaction'];
    return categoryDescriptions[_random.nextInt(categoryDescriptions.length)];
  }
  
  static String? _generateSource(TransactionType type) {
    if (type == TransactionType.income) {
      final sources = [
        'Bank Account',
        'PayPal',
        'Venmo',
        'Cash App',
        'Zelle',
        'Wire Transfer',
        'Check Deposit',
        'Direct Deposit'
      ];
      return sources[_random.nextInt(sources.length)];
    }
    return null;
  }
  
  static String? _generateDestination(TransactionType type) {
    if (type == TransactionType.expense) {
      final destinations = [
        'Credit Card',
        'Debit Card',
        'Bank Transfer',
        'Cash',
        'PayPal',
        'Apple Pay',
        'Google Pay',
        'Venmo'
      ];
      return destinations[_random.nextInt(destinations.length)];
    }
    return null;
  }
  
  static String? _generateNotes() {
    if (_random.nextDouble() < 0.3) { // 30% chance of having notes
      final notes = [
        'Business expense',
        'Personal use',
        'Gift for family',
        'Emergency purchase',
        'Planned expense',
        'Unexpected cost',
        'Monthly recurring',
        'One-time purchase',
        'Investment for future',
        'Necessary expense'
      ];
      return notes[_random.nextInt(notes.length)];
    }
    return null;
  }
  
  static List<String>? _generateTags() {
    if (_random.nextDouble() < 0.4) { // 40% chance of having tags
      final allTags = [
        'business',
        'personal',
        'urgent',
        'planned',
        'recurring',
        'one-time',
        'investment',
        'necessity',
        'luxury',
        'gift',
        'emergency',
        'health',
        'education',
        'entertainment'
      ];
      
      final tagCount = 1 + _random.nextInt(3); // 1-3 tags
      final selectedTags = <String>[];
      
      for (int i = 0; i < tagCount; i++) {
        final tag = allTags[_random.nextInt(allTags.length)];
        if (!selectedTags.contains(tag)) {
          selectedTags.add(tag);
        }
      }
      
      return selectedTags;
    }
    return null;
  }
  
  static String? _generateLocation() {
    if (_random.nextDouble() < 0.5) { // 50% chance of having location
      final locations = [
        'New York, NY',
        'Los Angeles, CA',
        'Chicago, IL',
        'Houston, TX',
        'Phoenix, AZ',
        'Philadelphia, PA',
        'San Antonio, TX',
        'San Diego, CA',
        'Dallas, TX',
        'San Jose, CA',
        'Austin, TX',
        'Jacksonville, FL',
        'Fort Worth, TX',
        'Columbus, OH',
        'Charlotte, NC'
      ];
      return locations[_random.nextInt(locations.length)];
    }
    return null;
  }
  
  static String? _generatePaymentMethod() {
    final methods = [
      'Visa ****1234',
      'Mastercard ****5678',
      'American Express ****9012',
      'Discover ****3456',
      'Debit Card ****7890',
      'PayPal',
      'Apple Pay',
      'Google Pay',
      'Venmo',
      'Cash App',
      'Zelle',
      'Bank Transfer',
      'Cash',
      'Check'
    ];
    return methods[_random.nextInt(methods.length)];
  }
  
  static String? _generateOriginalMessage(TransactionType type, double amount, String description) {
    if (_random.nextDouble() < 0.7) { // 70% chance of having original message
      switch (type) {
        case TransactionType.expense:
          return 'Your account has been debited with \$${amount.toStringAsFixed(2)} for $description on ${DateTime.now().toString().substring(0, 10)}. Available balance: \$${(5000 + _random.nextDouble() * 10000).toStringAsFixed(2)}';
        case TransactionType.income:
          return 'Your account has been credited with \$${amount.toStringAsFixed(2)} from $description on ${DateTime.now().toString().substring(0, 10)}. Available balance: \$${(5000 + _random.nextDouble() * 10000).toStringAsFixed(2)}';
        case TransactionType.transfer:
          return 'Transfer of \$${amount.toStringAsFixed(2)} completed successfully. Reference: TXN${_random.nextInt(999999).toString().padLeft(6, '0')}';
      }
    }
    return null;
  }
}