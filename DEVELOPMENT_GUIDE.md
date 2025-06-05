# FinWatch Development Guide 🛠️

This guide provides comprehensive information for developers working on the FinWatch project.

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Getting Started](#getting-started)
4. [Development Workflow](#development-workflow)
5. [Code Structure](#code-structure)
6. [Key Features Implementation](#key-features-implementation)
7. [Testing](#testing)
8. [Deployment](#deployment)
9. [Contributing](#contributing)

## 🎯 Project Overview

FinWatch is a comprehensive financial tracking application built with Flutter that automatically detects transactions from SMS and notifications, providing real-time insights into spending patterns with beautiful, animated UI/UX.

### Key Technologies
- **Frontend**: Flutter 3.24.5+
- **State Management**: Riverpod
- **Local Database**: Hive
- **Backend**: Firebase (Auth, Firestore, Cloud Functions, Messaging)
- **Charts**: FL Chart & Syncfusion Charts
- **Animations**: Lottie, Flutter Staggered Animations

## 🏗️ Architecture

The project follows Clean Architecture principles with three main layers:

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  (UI, Widgets, Pages, Providers)    │
├─────────────────────────────────────┤
│            Domain Layer             │
│   (Entities, Use Cases, Repos)      │
├─────────────────────────────────────┤
│             Data Layer              │
│ (Models, Data Sources, Repos Impl)  │
└─────────────────────────────────────┘
```

### Folder Structure
```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── theme/              # Theming
│   ├── router/             # Navigation
│   ├── services/           # Core services
│   └── utils/              # Utilities
├── features/               # Feature modules
│   ├── auth/               # Authentication
│   ├── dashboard/          # Dashboard
│   ├── transactions/       # Transactions
│   ├── reports/            # Reports
│   └── settings/           # Settings
└── shared/                 # Shared components
    ├── widgets/            # Reusable widgets
    └── utils/              # Shared utilities
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- Firebase Project

### Quick Setup
1. **Clone and setup**:
   ```bash
   git clone https://github.com/aathithya-27/FinWatch.git
   cd FinWatch
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

2. **Manual setup**:
   ```bash
   flutter pub get
   dart run build_runner build
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 🔄 Development Workflow

### 1. Feature Development
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
# ...

# Run tests
flutter test

# Run analysis
flutter analyze

# Commit changes
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/new-feature
```

### 2. Code Generation
When modifying models or adding new ones:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Adding Dependencies
```bash
flutter pub add package_name
flutter pub get
```

## 📁 Code Structure

### Feature Module Structure
Each feature follows this structure:
```
feature_name/
├── data/
│   ├── models/           # Data models
│   ├── repositories/     # Repository implementations
│   └── datasources/      # Data sources (local/remote)
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic
└── presentation/
    ├── pages/            # UI pages
    ├── widgets/          # Feature-specific widgets
    └── providers/        # State management
```

### Creating a New Feature

1. **Create the folder structure**:
   ```bash
   mkdir -p lib/features/new_feature/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{pages,widgets,providers}}
   ```

2. **Create entity**:
   ```dart
   // lib/features/new_feature/domain/entities/new_entity.dart
   class NewEntity extends Equatable {
     final String id;
     final String name;
     
     const NewEntity({required this.id, required this.name});
     
     @override
     List<Object?> get props => [id, name];
   }
   ```

3. **Create model**:
   ```dart
   // lib/features/new_feature/data/models/new_model.dart
   @HiveType(typeId: X) // Use next available typeId
   @JsonSerializable()
   class NewModel extends HiveObject {
     @HiveField(0)
     final String id;
     
     @HiveField(1)
     final String name;
     
     NewModel({required this.id, required this.name});
     
     factory NewModel.fromJson(Map<String, dynamic> json) => _$NewModelFromJson(json);
     Map<String, dynamic> toJson() => _$NewModelToJson(this);
     
     NewEntity toEntity() => NewEntity(id: id, name: name);
     factory NewModel.fromEntity(NewEntity entity) => NewModel(id: entity.id, name: entity.name);
   }
   ```

4. **Create provider**:
   ```dart
   // lib/features/new_feature/presentation/providers/new_provider.dart
   final newProvider = StateNotifierProvider<NewNotifier, AsyncValue<List<NewEntity>>>(
     (ref) => NewNotifier(),
   );
   
   class NewNotifier extends StateNotifier<AsyncValue<List<NewEntity>>> {
     NewNotifier() : super(const AsyncValue.loading()) {
       _loadData();
     }
     
     Future<void> _loadData() async {
       // Implementation
     }
   }
   ```

## 🔑 Key Features Implementation

### 1. Automatic Transaction Detection

The app uses `NotificationListenerService` (Android) and `UNNotificationServiceExtension` (iOS) to detect payment notifications:

```dart
// lib/core/services/transaction_detection_service.dart
class TransactionDetectionService {
  static TransactionEntity? parseNotification(String message) {
    // Regex patterns for different payment apps
    final patterns = {
      'amount': r'Rs\.?\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
      'type': r'(debited|credited|paid|received)',
      'merchant': r'(?:to|from|at)\s+([A-Za-z0-9\s]+)',
    };
    
    return _extractTransactionDetails(message, patterns);
  }
}
```

### 2. Real-time Dashboard Updates

Using Riverpod for reactive state management:

```dart
// Automatically updates when transactions change
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.when(
    data: (data) => _calculateSummary(data),
    loading: () => DashboardSummary.loading(),
    error: (_, __) => DashboardSummary.error(),
  );
});
```

### 3. Animated Charts

Using FL Chart with custom animations:

```dart
class AnimatedChart extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return PieChart(
          PieChartData(
            sections: _buildAnimatedSections(),
            sectionsSpace: 2 * _animation.value,
            centerSpaceRadius: 60 * _animation.value,
          ),
        );
      },
    );
  }
}
```

### 4. Offline-First Architecture

Using Hive for local storage with automatic sync:

```dart
class TransactionRepository {
  Future<List<Transaction>> getTransactions() async {
    // Try local first
    final localTransactions = await _localDataSource.getTransactions();
    
    // Sync with remote if connected
    if (await _networkInfo.isConnected) {
      final remoteTransactions = await _remoteDataSource.getTransactions();
      await _syncTransactions(localTransactions, remoteTransactions);
    }
    
    return localTransactions;
  }
}
```

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test/

# Integration tests
flutter test integration_test/
```

### Test Structure
```
test/
├── unit/                 # Unit tests
│   ├── core/
│   └── features/
├── widget/               # Widget tests
│   └── features/
└── integration/          # Integration tests
    └── app_test.dart
```

### Writing Tests

**Unit Test Example**:
```dart
// test/unit/features/transactions/domain/usecases/get_transactions_test.dart
void main() {
  group('GetTransactions', () {
    test('should return list of transactions', () async {
      // Arrange
      when(mockRepository.getTransactions())
          .thenAnswer((_) async => [testTransaction]);
      
      // Act
      final result = await usecase();
      
      // Assert
      expect(result, [testTransaction]);
    });
  });
}
```

**Widget Test Example**:
```dart
// test/widget/features/dashboard/presentation/widgets/balance_card_test.dart
void main() {
  testWidgets('BalanceCard displays correct balance', (tester) async {
    // Arrange
    const balance = 1000.0;
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BalanceCard(balance: balance),
      ),
    );
    
    // Assert
    expect(find.text('\$1000.00'), findsOneWidget);
  });
}
```

## 🚀 Deployment

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation for public APIs
- Keep functions small and focused

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: add new transaction categorization
fix: resolve balance calculation issue
docs: update API documentation
style: format code according to style guide
refactor: simplify transaction parsing logic
test: add unit tests for dashboard
```

### Pull Request Process
1. Create feature branch from `main`
2. Make changes with tests
3. Update documentation if needed
4. Ensure all tests pass
5. Create PR with clear description
6. Address review feedback
7. Merge after approval

### Code Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] Performance considerations addressed
- [ ] Security implications considered

## 📚 Additional Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Hive Documentation](https://docs.hivedb.dev/)

### Tools
- [Flutter Inspector](https://docs.flutter.dev/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Firebase Console](https://console.firebase.google.com/)

### Best Practices
- [Flutter Best Practices](https://docs.flutter.dev/development/best-practices)
- [Dart Best Practices](https://dart.dev/guides/language/effective-dart)
- [Firebase Best Practices](https://firebase.google.com/docs/rules/best-practices)

---

**Happy Coding! 🚀**

For questions or support, please reach out to the development team or create an issue on GitHub.