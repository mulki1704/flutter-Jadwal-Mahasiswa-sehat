# Firebase Configuration untuk DailyFit Student

## Setup Firebase

### 1. Buat Project Firebase

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Add project" atau "Tambah project"
3. Nama project: **dailyfit-student**
4. Ikuti wizard hingga selesai

### 2. Tambahkan Web App

1. Di Project Overview, klik ikon Web (</>)
2. App nickname: **DailyFit Student Web**
3. Centang "Also set up Firebase Hosting"
4. Klik "Register app"

### 3. Copy Firebase Config

Setelah registrasi, Anda akan mendapat kode seperti ini:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",
  authDomain: "dailyfit-student.firebaseapp.com",
  projectId: "dailyfit-student",
  storageBucket: "dailyfit-student.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123",
};
```

### 4. Update main.dart

Ganti konfigurasi di `lib/main.dart` dengan config Anda:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'dailyfit-student',
    storageBucket: 'dailyfit-student.appspot.com',
  ),
);
```

### 5. Enable Firestore Database

1. Di Firebase Console, klik **Firestore Database**
2. Klik **Create database**
3. Pilih **Start in test mode** (untuk development)
4. Pilih lokasi: **asia-southeast1** (Singapura)
5. Klik **Enable**

### 6. Firestore Rules (Development)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // HANYA UNTUK DEVELOPMENT!
    }
  }
}
```

### 7. Firestore Rules (Production)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /schedules/{scheduleId} {
        allow read, write: if request.auth != null;
      }

      match /tasks/{taskId} {
        allow read, write: if request.auth != null;
      }

      match /health_data/{healthId} {
        allow read, write: if request.auth != null;
      }
    }
  }
}
```

## Struktur Database Firestore

```
dailyfit-student/
├── users/
│   └── {userId}/
│       ├── name: string
│       ├── email: string
│       ├── password: string (hashed di production!)
│       ├── createdAt: timestamp
│       │
│       ├── schedules/
│       │   └── {scheduleId}/
│       │       ├── title: string
│       │       ├── instructor: string
│       │       ├── room: string
│       │       ├── dayOfWeek: number (0-6)
│       │       ├── startTime: string
│       │       ├── endTime: string
│       │       ├── type: string (class/work/gym)
│       │       └── createdAt: timestamp
│       │
│       ├── tasks/
│       │   └── {taskId}/
│       │       ├── title: string
│       │       ├── description: string
│       │       ├── subject: string
│       │       ├── dueDate: timestamp
│       │       ├── isCompleted: boolean
│       │       └── createdAt: timestamp
│       │
│       └── health_data/
│           └── {healthId}/
│               ├── height: number
│               ├── weight: number
│               ├── age: number
│               ├── sleepHours: number
│               ├── fatigueNote: string
│               └── createdAt: timestamp
```

## Untuk Android App

### 1. Download google-services.json

1. Di Firebase Console, klik ⚙️ Project Settings
2. Scroll ke "Your apps"
3. Klik Android icon atau "Add app" → Android
4. Package name: `com.dailyfit.student`
5. Download `google-services.json`
6. Copy file ke: `android/app/google-services.json`

### 2. Update android/build.gradle

Tambahkan di `dependencies`:

```gradle
classpath 'com.google.gms:google-services:4.3.15'
```

### 3. Update android/app/build.gradle

Tambahkan di baris paling bawah:

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Testing

1. **Register user baru**
2. **Cek di Firebase Console** → Firestore Database
3. **Lihat collection "users"** → akan ada document baru

## Keuntungan Firebase vs SQLite

✅ **Sync otomatis** - Data tersinkronisasi di semua device  
✅ **Real-time** - Perubahan langsung terlihat  
✅ **Cloud backup** - Data aman di cloud  
✅ **Multi-platform** - Web, Android, iOS menggunakan database sama  
✅ **Scalable** - Bisa handle jutaan users

## Notes

⚠️ **PENTING**: Konfigurasi saat ini menggunakan dummy credentials untuk demo.  
Ganti dengan Firebase config asli Anda untuk production!

⚠️ **SECURITY**: Password saat ini disimpan plain text. Di production, gunakan Firebase Authentication dan hash password!
