#!/bin/bash

# FinWatch Development Setup Script
# This script sets up the development environment for FinWatch

set -e

echo "🚀 Setting up FinWatch Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter found: $FLUTTER_VERSION"
    else
        print_error "Flutter is not installed. Please install Flutter first."
        print_status "Visit: https://docs.flutter.dev/get-started/install"
        exit 1
    fi
}

# Install Flutter dependencies
install_dependencies() {
    print_status "Installing Flutter dependencies..."
    flutter pub get
    print_success "Dependencies installed successfully"
}

# Generate code
generate_code() {
    print_status "Generating code..."
    dart run build_runner build --delete-conflicting-outputs
    print_success "Code generation completed"
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    
    mkdir -p assets/images
    mkdir -p assets/lottie
    mkdir -p assets/icons
    mkdir -p assets/fonts
    mkdir -p test/unit
    mkdir -p test/widget
    mkdir -p test/integration
    mkdir -p docs
    
    print_success "Directories created"
}

# Main setup function
main() {
    echo "📱 FinWatch - Smart Financial Tracking App"
    echo "=========================================="
    echo
    
    check_flutter
    create_directories
    install_dependencies
    generate_code
    
    echo
    print_success "🎉 FinWatch development environment setup completed!"
    echo
    print_status "Next steps:"
    echo "1. Configure your Firebase project"
    echo "2. Add your google-services.json (Android) and GoogleService-Info.plist (iOS)"
    echo "3. Run 'flutter run' to start the app"
    echo "4. Check 'flutter doctor' for any remaining issues"
    echo
    print_status "Happy coding! 🚀"
}

# Run main function
main