# 🎙️ Voice-Driven To-Do List App (TaskFlow)

A Flutter-based to-do list app powered by **voice commands** to help users manage tasks completely hands-free. Designed for busy routines like cooking or driving, this app supports **offline voice capture**, **real-time cloud sync**, and **natural language commands**, making task management seamless and accessible.

---

## 🚀 Features

### ✅ Voice Commands (Implemented in `VoiceService` & `HomeScreen`)
- `"Add [task]"` – Creates a new task
- `"Delete [task]"` – Removes an existing task
- `"Complete [task]"` – Marks a task as done
- `"Uncomplete [task]"` – Marks a task as not done

### 📝 Manual Task Input
- Text field to enter tasks
- "Add" button to create a task manually
- Checkboxes to toggle task completion
- Delete buttons for removing tasks

### 🔈 Voice Feedback (Implemented using `flutter_tts`)
- Audible confirmation for:
  - Task creation
  - Completion/Uncompletion
  - Task deletion

### 📶 Offline Queueing (Implemented using `LocalStorageService` with Hive)
- Commands are stored locally when offline
- Automatically syncs with the cloud once online

### 🔄 Real-Time Sync (Implemented in `FirebaseService` with Firestore)
- Tasks update instantly across devices
- Reliable and consistent task state everywhere

### 💾 Data Persistence
- Local storage: `Hive`
- Cloud storage: `Firebase Firestore`
- State management: `Riverpod`

---

## 🖼️ UI Overview
- Microphone icon in the app bar to activate voice input
- Clean text input field with an "Add" button
- Task list with:
  - Checkboxes for task status
  - Delete buttons
  - Strikethrough for completed tasks

---

## 📦 Tech Stack
- **Flutter**
- **Firebase Firestore**
- **Hive** (offline storage)
- **flutter_tts** (text-to-speech)
- **Riverpod** (state management)

---

## 📍 Current Status
All core features have been implemented and tested:

| Feature                | Status  |
|------------------------|---------|
| Voice Command Parsing  | ✅ DONE |
| Offline Queueing       | ✅ DONE |
| Real-Time Sync         | ✅ DONE |
| User Feedback (TTS)    | ✅ DONE |
| Data Persistence       | ✅ DONE |

---

## 📌 Usage

1. **Install dependencies**  
   ```bash
   flutter pub get
   ```

2. **Run the app**  
   ```bash
   flutter run
   ```

3. **Start using voice or manual input to manage your tasks!**

---

## 📈 Future Enhancements
Refer to the [Future Implementation & Conclusion](#) section for upcoming plans.
