# FinWatch 💰

A comprehensive, cross-platform mobile application for automatic financial tracking and smart analytics. FinWatch automatically detects transactions from SMS and notifications, providing real-time insights into your spending patterns with beautiful, animated UI/UX.

![FinWatch Banner](assets/images/banner.png)

## 🌟 Features

### 🔐 Authentication & User Management
- **Email + Password Authentication** with Firebase Auth
- **Google OAuth Integration** for seamless sign-in
- **Forgot Password & Reset** functionality
- **Profile Management** (Name, Email, Currency, Avatar)
- **Secure Account Deletion** with confirmation and data purge
- **Token-based Authentication** with automatic refresh handling

### 📥 Automatic Transaction Tracking
- **SMS & Notification Parsing** for automatic transaction detection
- **Smart Category Recognition** (Shopping, Bills, UPI, Transfer, Salary, etc.)
- **Manual Transaction Entry** with rich UI forms
- **Duplicate Detection** to avoid redundant entries
- **Multi-bank Support** for various payment apps (GPay, PhonePe, Paytm, etc.)

### 📊 Dashboard & Analytics
- **Real-time Balance Overview** with income/expense breakdown
- **Time-based Summaries**: Today, Yesterday, Weekly, Monthly
- **Interactive Charts**: Line graphs, Bar charts, Pie charts with animations
- **Category-wise Spending Analysis** with visual representations
- **Smart Budget Alerts** and spending warnings
- **AI-powered Insights** for financial recommendations

### 💡 Smart Features
- **Spending Reduction Suggestions** based on patterns
- **Monthly Budget Planning** with goal tracking
- **Recurring Expense Notifications** 
- **Weekly Email Summaries** (optional)
- **Cash Burn Rate Analysis**
- **Savings Streak Tracking**

### 🎨 Premium UI/UX & Animations
- **Material 3 Design** with Cupertino elements
- **Dark/Light/AMOLED Themes** for all preferences
- **Lottie Animations** for onboarding and interactions
- **Smooth Transitions** with physics-based animations
- **Glassmorphism Cards** and Neumorphism toggles
- **Skeleton Loaders** and shimmering effects
- **Gesture-based Navigation** with haptic feedback

### ⌚ Smartwatch Integration
- **Apple Watch Support** via HealthKit integration
- **WearOS/Fitbit Compatibility** through Google Fit APIs
- **Real-time Spending Alerts** on wearable devices
- **Quick Transaction Entry** via voice or tap
- **Live Balance Widget** for watch faces

### 🧰 Developer-Friendly Backend
- **Firebase/Supabase Integration** for scalable backend
- **Offline-first Architecture** with automatic syncing
- **Cloud Functions** for server-side processing
- **Real-time Database** with Firestore/Supabase DB
- **Push Notifications** via Firebase Messaging
- **Conflict Resolution** for data synchronization

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.24.5+
- **State Management**: Riverpod
- **Local Database**: Hive
- **Charts**: FL Chart & Syncfusion Charts
- **Animations**: Lottie, Flutter Staggered Animations
- **Navigation**: Go Router

### Backend & Services
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **Functions**: Firebase Cloud Functions
- **Messaging**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics

### Development Tools
- **Code Generation**: Build Runner, JSON Serializable
- **Architecture**: Clean Architecture (Domain-Data-Presentation)
- **Testing**: Flutter Test, Mockito
- **CI/CD**: GitHub Actions (ready)

## 📱 Screenshots

| Onboarding | Login | Dashboard | Transactions |
|------------|-------|-----------|--------------|
| ![Onboarding](assets/screenshots/onboarding.png) | ![Login](assets/screenshots/login.png) | ![Dashboard](assets/screenshots/dashboard.png) | ![Transactions](assets/screenshots/transactions.png) |

| Reports | Settings | Add Transaction | Charts |
|---------|----------|-----------------|--------|
| ![Reports](assets/screenshots/reports.png) | ![Settings](assets/screenshots/settings.png) | ![Add](assets/screenshots/add.png) | ![Charts](assets/screenshots/charts.png) |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Firebase Project (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/aathithya-27/FinWatch.git
   cd FinWatch
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase in your project
   firebase init
   
   # Configure FlutterFire
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

4. **Generate code**
   ```bash
   dart run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Android Setup
1. Add your `google-services.json` to `android/app/`
2. Enable required permissions in `AndroidManifest.xml`
3. Configure notification listener service for SMS parsing

#### iOS Setup
1. Add your `GoogleService-Info.plist` to `ios/Runner/`
2. Configure capabilities in Xcode:
   - Push Notifications
   - Background App Refresh
   - HealthKit (for Apple Watch)
3. Add required permissions to `Info.plist`

#### Firebase Configuration
1. Enable Authentication providers (Email/Password, Google)
2. Set up Firestore database with security rules
3. Configure Cloud Functions for transaction processing
4. Enable Firebase Messaging for push notifications

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core functionality
│   ├── config/                        # App configuration
│   ├── theme/                         # App themes and styling
│   ├── router/                        # Navigation configuration
│   ├── services/                      # Core services
│   └── utils/                         # Utility functions
├── features/                          # Feature modules
│   ├── auth/                          # Authentication
│   │   ├── data/                      # Data layer
│   │   ├── domain/                    # Domain layer
│   │   └── presentation/              # UI layer
│   ├── dashboard/                     # Dashboard & home
│   ├── transactions/                  # Transaction management
│   ├── reports/                       # Analytics & reports
│   ├── settings/                      # App settings
│   ├── onboarding/                    # User onboarding
│   └── splash/                        # Splash screen
├── shared/                            # Shared components
│   ├── widgets/                       # Reusable widgets
│   ├── utils/                         # Shared utilities
│   └── constants/                     # App constants
└── assets/                            # Static assets
    ├── images/                        # Images
    ├── lottie/                        # Lottie animations
    ├── icons/                         # App icons
    └── fonts/                         # Custom fonts
```

## 🔧 Key Features Implementation

### Automatic Transaction Detection
```dart
// SMS parsing service
class SMSParserService {
  static TransactionEntity? parseTransactionFromSMS(String message) {
    // Regex patterns for different banks and payment apps
    final patterns = {
      'upi': r'Rs\.?\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
      'debit': r'debited.*?Rs\.?\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
      'credit': r'credited.*?Rs\.?\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
    };
    
    // Parse and extract transaction details
    return extractTransactionDetails(message, patterns);
  }
}
```

### Real-time Dashboard Updates
```dart
// Riverpod provider for real-time updates
final transactionSummaryProvider = Provider<AsyncValue<TransactionSummary>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.when(
    data: (data) => AsyncValue.data(calculateSummary(data)),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
```

### Animated Charts
```dart
// FL Chart with animations
class AnimatedPieChart extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return PieChart(
          PieChartData(
            sections: _buildAnimatedSections(),
            sectionsSpace: 2,
            centerSpaceRadius: 60 * _animation.value,
          ),
        );
      },
    );
  }
}
```

## 🔒 Security Features

- **Biometric Authentication** for app access
- **Encrypted Local Storage** using Hive with encryption
- **Secure API Communication** with HTTPS and certificate pinning
- **Data Validation** and sanitization for all inputs
- **Privacy-first Design** with minimal data collection
- **GDPR Compliance** with data export and deletion options

## 📊 Analytics & Insights

### Smart Categorization
- Machine learning-based transaction categorization
- Custom category creation and management
- Spending pattern recognition
- Budget variance analysis

### Predictive Analytics
- Future spending predictions based on historical data
- Seasonal spending pattern detection
- Budget optimization suggestions
- Financial goal tracking and recommendations

## ⌚ Smartwatch Features

### Apple Watch Integration
```dart
// HealthKit integration for Apple Watch
class AppleWatchService {
  static Future<void> syncTransactionAlert(TransactionEntity transaction) async {
    await HealthKit.writeWorkout(
      type: 'financial_activity',
      data: transaction.toHealthKitData(),
    );
  }
}
```

### WearOS Integration
```dart
// Google Fit integration for WearOS
class WearOSService {
  static Future<void> sendSpendingAlert(double amount) async {
    await GoogleFit.insertDataPoint(
      dataType: 'financial_metric',
      value: amount,
      timestamp: DateTime.now(),
    );
  }
}
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test/
```

## 📦 Build & Deployment

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web (PWA)
```bash
flutter build web --release
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **Riverpod** for state management
- **FL Chart** for beautiful charts
- **Lottie** for smooth animations
- **Material Design** for UI guidelines

## 📞 Support

- **Email**: support@finwatch.app
- **Documentation**: [docs.finwatch.app](https://docs.finwatch.app)
- **Issues**: [GitHub Issues](https://github.com/aathithya-27/FinWatch/issues)
- **Discussions**: [GitHub Discussions](https://github.com/aathithya-27/FinWatch/discussions)

## 🗺️ Roadmap

### Version 1.1
- [ ] Advanced AI insights and recommendations
- [ ] Multi-currency support with real-time exchange rates
- [ ] Investment tracking and portfolio management
- [ ] Social features for expense sharing

### Version 1.2
- [ ] Voice-controlled transaction entry
- [ ] OCR for receipt scanning
- [ ] Advanced export options (Excel, PDF reports)
- [ ] Integration with banking APIs

### Version 2.0
- [ ] Web dashboard for comprehensive analysis
- [ ] Family account management
- [ ] Merchant partnerships and cashback offers
- [ ] Advanced security with 2FA

---

**Made with ❤️ by the FinWatch Team**

*FinWatch - Your Smart Financial Companion* 🚀