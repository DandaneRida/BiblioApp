
# 📚 BiblioApp

A Flutter mobile application for managing your personal book library,
built as part of the **Mobile Development module** at ENSAM Meknès (ILSI-3A, 2025/2026).

---

## 🎯 Overview

BiblioApp allows users to manage a personal book collection with full
CRUD operations, smart filtering, and insightful reading statistics —
all stored locally on the device using SQLite.

---

## ✨ Features

- 📖 **Add, edit, and delete** books from your library
- 🔍 **Search** by title or author in real time
- 🏷️ **Filter** books by literary genre
- ⭐ **Rate** books on a 5-star scale
- ✅ **Track** read / unread status
- 📊 **Statistics** screen with reading progress and genre breakdown

---

## 🏗️ Architecture

This project follows a clean **3-layer architecture**:


UI (Screens) → BLoC (Business Logic) → Repository → SQLite


| Layer | Role |
|---|---|
| `screens/` | UI only, no business logic |
| `bloc/` | Events, States, and BLoC orchestration |
| `repositories/` | Abstraction over the data source |
| `database/` | SQLite configuration via singleton |
| `models/` | Data model with serialization |



## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter 3.x | UI framework |
| Dart 3.x | Programming language |
| flutter_bloc 8.x | State management (BLoC pattern) |
| equatable | Value-based object comparison |
| sqflite | Local SQLite database |
| path | Cross-platform file path handling |

---
## 📁 Project Structure

```
biblio_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── livre.dart
│   ├── database/
│   │   └── database_helper.dart
│   ├── repositories/
│   │   └── livre_repository.dart
│   ├── bloc/
│   │   ├── livre_bloc.dart
│   │   ├── livre_event.dart
│   │   └── livre_state.dart
│   └── screens/
│       ├── liste_livres_screen.dart
│       ├── detail_livre_screen.dart
│       ├── ajouter_livre_screen.dart
│       ├── modifier_livre_screen.dart
│       └── statistiques_screen.dart
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

---
## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.10
- Dart SDK ≥ 3.0
- Android Studio with an Android emulator (API 33+)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/biblio_app.git
cd biblio_app

# Install dependencies
flutter pub get

# Run on Android emulator
flutter run
```

> ⚠️ This app uses **sqflite** for local storage.
> Run on an **Android emulator or physical device** only.
> Web and desktop require additional FFI configuration.

---

## 📱 Screens

| Screen | Description |
|---|---|
| **Book List** | Main screen with search bar and genre filters |
| **Book Detail** | Full book info with edit and delete actions |
| **Add Book** | Validated form to create a new entry |
| **Edit Book** | Pre-filled form to update an existing book |
| **Statistics** | Reading rate, average rating, genre breakdown |

---

## 👥 Authors

- **Rida Dandane** — ENSAM Meknès, ILSI-3A
- **Lhassan Oubihi** — ENSAM Meknès, ILSI-3A

Supervised by **Pr. S. Amri** — Mobile Development Module

---

## 📄 License

This project was developed for academic purposes at
**École Nationale Supérieure des Arts et Métiers — Meknès**.
```