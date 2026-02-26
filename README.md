# ✅ DailyDo

**A minimal habit tracking app built with Flutter & Isar**

DailyDo helps you build better habits by letting you create, track, and analyze your daily routines — all stored locally on your device. No account needed, no internet required.

---

## ✨ Features

- ➕ **Create & Manage Habits**
  Add new habits, edit names, or swipe to delete — all from a clean home screen.

- ✔️ **Daily Check-ins**
  Tap a habit to mark it as done for the day. Tap again to undo.

- 📊 **Analysis Dashboard**
  View your habit completion stats with a heat map calendar and per-habit counts — filter by **Weekly** or **Monthly** view.

- 🗺️ **Heat Map Visualization**
  See your activity patterns at a glance with a color-coded heat map powered by `flutter_heatmap_calendar`.

- 🌙 **Dark Mode**
  Toggle between light and dark themes from the Settings page.

- 🚀 **Onboarding Flow**
  A 3-page introduction screen for first-time users, shown only once.

- ☁️ **100% Offline**
  All data is stored locally using the **Isar** NoSQL database. No backend, no sign-up, no internet needed.

---

## 🏗️ Architecture

```
lib/
├── main.dart                          # App entry point & provider setup
├── database/
│   └── habit_database.dart            # Isar CRUD operations & ChangeNotifier
├── models/
│   ├── habit.dart                     # Habit model (Isar collection)
│   └── app_settings.dart              # App settings model (first launch date)
├── pages/
│   ├── home_page.dart                 # Main screen with habit list
│   ├── analysis.dart                  # Analytics dashboard with heat map & grid
│   ├── settings_page.dart             # Dark mode toggle & log out
│   └── notification.dart              # Notification page (placeholder)
├── components/
│   ├── my_habit_tile.dart             # Slidable habit tile widget
│   ├── my_heat_map.dart               # Heat map calendar widget
│   └── my_drawer.dart                 # Navigation drawer
├── theme/
│   ├── theme_provider.dart            # Theme state management
│   ├── light_mode.dart                # Light theme config
│   └── dark_mode.dart                 # Dark theme config
├── util/
│   └── habit_util.dart                # Helper functions (completion check, dataset prep)
└── Introduction Screen/
    └── onboarding_screen.dart         # 3-page onboarding flow
```

---

## 🧰 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** (Dart) | Cross-platform UI framework |
| **Isar** `3.1.0` | Local NoSQL database |
| **Provider** `6.1.5` | State management |
| **SharedPreferences** | Onboarding flag & lightweight key-value storage |
| **flutter_slidable** | Swipe-to-edit & swipe-to-delete on habit tiles |
| **flutter_heatmap_calendar** | Heat map visualization |
| **smooth_page_indicator** | Onboarding page dots |
| **Google Fonts (Poppins)** | Custom typography |
| **intl** | Date formatting in analytics |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.7.2`
- Android Studio / VS Code
- An Android emulator or physical device

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/dev-karthik-op/DailyDo.git
cd DailyDo

# 2. Install dependencies
flutter pub get

# 3. Generate Isar schemas (if needed)
dart run build_runner build

# 4. Run the app
flutter run
```

---

## 📱 Supported Platforms

| Platform | Status |
|----------|--------|
| Android  | ✅ Supported |
| iOS      | 🔧 Untested (should work with minor config) |
| Web      | ❌ Not supported (Isar limitation) |

---

## 🗺️ Roadmap

- [ ] Streak tracking with day-count display
- [ ] Push notification reminders
- [ ] Habit categories & icons/emoji picker
- [ ] Data export (CSV / JSON)
- [ ] iOS testing & release

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👤 Author

**Karthik** — [@dev-karthik-op](https://github.com/dev-karthik-op)

---

> *Built with ❤️ using Flutter*
