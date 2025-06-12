# I Wish - Flutter App

A clean architecture Flutter application for managing wishlists using Supabase as the backend.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

- **Domain Layer**: Pure Dart business logic and entities
- **Data Layer**: External service integrations and data management
- **Presentation Layer**: UI components and state management with Riverpod

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.6.1 or higher
- Dart SDK
- Supabase account and project

### Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd i_wish
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Configuration**
   
   Copy the `env.example` file and create your environment configuration:
   ```bash
   cp env.example .env
   ```
   
   Fill in your Supabase credentials in the `.env` file:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   PRODUCTION=false
   ```

4. **Run with environment variables**
   ```bash
   flutter run --dart-define-from-file=.env
   ```

### Database Schema

Set up your Supabase database with the following tables:

#### Items Table
```sql
CREATE TABLE item (
  id SERIAL PRIMARY KEY,
  userId UUID REFERENCES auth.users(id),
  wishlist_id TEXT,
  title TEXT NOT NULL,
  link TEXT,
  image_url TEXT,
  comments TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 📱 Features

- ✅ User Authentication (Sign up/Sign in)
- ✅ Create, Read, Update, Delete wishlists and items
- ✅ Organize items by wishlists
- ✅ Favorites functionality
- ✅ Proper error handling with Result pattern
- ✅ Loading states with AsyncValue
- ✅ Navigation with GoRouter
- ✅ Form validation
- ✅ Centralized logging

## 🛠️ Development

### Code Quality

The project includes:
- Proper error handling with Result<T, Failure> pattern
- Centralized logging instead of print statements
- Input validation utilities
- Environment-based configuration
- Type-safe navigation with GoRouter

### State Management

Uses **Riverpod** with:
- AsyncNotifier for async operations
- Proper loading states
- Error handling integration

### Architecture Rules

1. **Domain Layer**: Pure Dart only, no Flutter dependencies
2. **Data Layer**: Implements domain interfaces, handles external services
3. **Presentation Layer**: UI components, state management, user interactions

## 📦 Dependencies

- `flutter_riverpod`: State management
- `supabase_flutter`: Backend integration
- `go_router`: Navigation
- `google_fonts`: Typography
- `flutter_slidable`: Swipe actions

## 🔒 Security

- API keys stored in environment variables
- Proper authentication flow
- Secure token management

## 🚨 Error Handling

The app implements comprehensive error handling:
- Domain-specific failure types
- User-friendly error messages
- Proper logging for debugging
- Graceful error recovery

## 📈 Future Enhancements

- [ ] Offline support
- [ ] Internationalization (i18n)
- [ ] Push notifications
- [ ] Image upload for items
- [ ] Sharing wishlists
- [ ] Dark mode support
