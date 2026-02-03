# DailyFit Student

Aplikasi mobile Flutter untuk manajemen jadwal, tugas, dan kesehatan bagi mahasiswa yang sibuk.

## Fitur Utama

✅ **Autentikasi**

- Login dan Register sederhana
- Penyimpanan session pengguna

✅ **Dashboard**

- Ringkasan jadwal hari ini
- Tugas terdekat
- Status kesehatan

✅ **Manajemen Jadwal**

- Tambah, edit, hapus jadwal kuliah
- Jadwal kerja dan gym
- Tampilan jadwal per hari

✅ **Manajemen Tugas**

- Tambah tugas berdasarkan mata kuliah
- Deadline dan status tugas
- Filter tugas (semua, belum selesai, selesai)

✅ **Tracking Kesehatan**

- Input tinggi badan, berat badan, usia
- Kalkulator BMI otomatis
- Catatan jam tidur dan kelelahan
- Riwayat kesehatan

## Teknologi

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **Database**: SQLite (sqflite)
- **State Management**: StatefulWidget
- **UI**: Material Design 3

## Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── app.dart                  # Root widget & theme
├── models/                   # Data models
│   ├── user.dart
│   ├── schedule.dart
│   ├── task.dart
│   └── health_data.dart
├── services/                 # Business logic
│   ├── database_service.dart
│   └── auth_service.dart
├── screens/                  # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   └── widgets/
│   ├── schedule/
│   │   ├── schedule_list_screen.dart
│   │   ├── add_schedule_screen.dart
│   │   ├── edit_schedule_screen.dart
│   │   └── widgets/
│   ├── task/
│   │   ├── task_list_screen.dart
│   │   ├── add_task_screen.dart
│   │   └── edit_task_screen.dart
│   ├── health/
│   │   └── health_screen.dart
│   └── profile/
│       └── profile_screen.dart
└── utils/
    └── constants.dart        # Colors, spacing, radius
```

## Cara Install & Menjalankan

### Prasyarat

- Flutter SDK 3.0 atau lebih baru
- Dart SDK 3.0 atau lebih baru
- Android Studio / VS Code dengan Flutter plugin
- Emulator Android atau perangkat fisik

### Langkah-langkah

1. **Clone atau Download Proyek**

   ```bash
   cd "c:\Users\user\DailyFit Student"
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**

   ```bash
   flutter run
   ```

4. **Build APK (Opsional)**
   ```bash
   flutter build apk --release
   ```

## Penggunaan

### 1. Register & Login

- Buka aplikasi
- Klik "Daftar di sini" untuk membuat akun baru
- Isi nama, email, dan password
- Login menggunakan kredensial yang sudah dibuat

### 2. Dashboard

- Lihat ringkasan jadwal hari ini
- Lihat tugas yang akan datang
- Cek status kesehatan terbaru

### 3. Kelola Jadwal

- Klik menu "Jadwal" di bottom navigation
- Tambah jadwal kuliah, kerja, atau gym
- Edit atau hapus jadwal yang ada

### 4. Kelola Tugas

- Klik menu "Tugas" di bottom navigation
- Tambah tugas baru dengan deadline
- Tandai tugas sebagai selesai
- Filter tugas berdasarkan status

### 5. Tracking Kesehatan

- Klik menu "Kesehatan" di bottom navigation
- Input data tinggi, berat, usia, dan jam tidur
- Lihat BMI dan kategori kesehatan
- Cek riwayat kesehatan

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.2.8+4 # SQLite database
  path: ^1.8.3 # Path manipulation
  intl: ^0.19.0 # Internationalization
  shared_preferences: ^2.2.2 # Local storage
  flutter_local_notifications: ^16.2.0 # Notifications
```

## Fitur Mendatang (Roadmap)

- [ ] Notifikasi reminder untuk tugas
- [ ] Export jadwal ke PDF
- [ ] Dark mode
- [ ] Sinkronisasi cloud (Firebase)
- [ ] Grafik progres kesehatan
- [ ] Widget kalender mingguan
- [ ] Backup & restore data

## Troubleshooting

### Error: "pub get failed"

```bash
flutter clean
flutter pub get
```

### Error: "Gradle build failed"

Pastikan Android SDK sudah terinstall dengan benar dan `minSdkVersion` sesuai (minimal 21).

### Database tidak menyimpan data

Coba uninstall aplikasi dan install ulang untuk reset database.

## Kontribusi

Proyek ini dibuat untuk tujuan edukasi. Silakan fork dan modifikasi sesuai kebutuhan Anda.

## Lisensi

MIT License - Bebas digunakan untuk keperluan pribadi dan komersial.

## Screenshot

[Akan ditambahkan screenshot aplikasi]

## Kontak

Jika ada pertanyaan atau saran, silakan buat issue di repository ini.

---

**Dibuat dengan ❤️ menggunakan Flutter**
