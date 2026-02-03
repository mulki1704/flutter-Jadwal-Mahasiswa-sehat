# Quick Start Guide - DailyFit Student

## Setup Cepat (5 Menit)

### 1. Install Dependencies

```powershell
cd "c:\Users\user\DailyFit Student"
flutter pub get
```

### 2. Cek Flutter Doctor

```powershell
flutter doctor
```

Pastikan tidak ada error kritis (✗). Warning (!) tidak masalah.

### 3. Jalankan Aplikasi

```powershell
# Jalankan di emulator/device
flutter run

# Atau jalankan di Chrome (web)
flutter run -d chrome
```

### 4. Build APK

```powershell
flutter build apk --release
```

APK akan tersimpan di: `build\app\outputs\flutter-apk\app-release.apk`

## Testing Aplikasi

### Akun Test

Buat akun baru saat pertama kali menjalankan aplikasi:

- **Nama**: Test User
- **Email**: test@example.com
- **Password**: test123

### Flow Testing

1. **Register**
   - Klik "Daftar di sini"
   - Isi form pendaftaran
   - Klik "Daftar"

2. **Login**
   - Masukkan email dan password
   - Klik "Masuk"

3. **Dashboard**
   - Lihat ringkasan jadwal dan tugas

4. **Tambah Jadwal**
   - Klik ikon "Jadwal" di bottom nav
   - Klik tombol + (floating action button)
   - Pilih jenis: Kuliah / Kerja / Gym
   - Isi detail jadwal
   - Simpan

5. **Tambah Tugas**
   - Klik ikon "Tugas" di bottom nav
   - Klik tombol +
   - Isi judul, deskripsi, dan deadline
   - Simpan

6. **Update Kesehatan**
   - Klik ikon "Kesehatan" di bottom nav
   - Isi tinggi, berat, usia, jam tidur
   - Lihat hasil BMI
   - Simpan

## Troubleshooting Common Issues

### Issue 1: "flutter: command not found"

**Solusi**: Install Flutter SDK dan tambahkan ke PATH

- Download dari: https://flutter.dev
- Ekstrak dan tambahkan `flutter/bin` ke system PATH

### Issue 2: Dependencies tidak terinstall

**Solusi**:

```powershell
flutter clean
flutter pub get
```

### Issue 3: Emulator tidak terdeteksi

**Solusi**:

```powershell
# Cek device yang tersedia
flutter devices

# Buat emulator baru (Android Studio)
# Tools > Device Manager > Create Device
```

### Issue 4: Hot reload tidak bekerja

**Solusi**:

- Tekan `r` di terminal untuk hot reload
- Tekan `R` di terminal untuk hot restart
- Atau restart aplikasi

### Issue 5: Build error di Android

**Solusi**: Pastikan di `android/app/build.gradle`:

```gradle
minSdkVersion 21
targetSdkVersion 33
```

## Fitur-Fitur Utama

✅ Login & Register
✅ Dashboard dengan ringkasan
✅ Manajemen jadwal (kuliah, kerja, gym)
✅ Manajemen tugas dengan deadline
✅ Tracking kesehatan & BMI calculator
✅ Riwayat kesehatan
✅ Profile & logout

## Tips Development

### Hot Reload

Saat development, gunakan hot reload untuk melihat perubahan instantly:

- Simpan file (Ctrl+S)
- Atau tekan `r` di terminal

### Debug Mode

```powershell
flutter run --debug
```

### Release Mode

```powershell
flutter run --release
```

### Check Performance

```powershell
flutter run --profile
```

## Database

Aplikasi menggunakan SQLite local database dengan tabel:

- `users` - Data pengguna
- `schedules` - Jadwal kuliah/kerja/gym
- `tasks` - Tugas perkuliahan
- `health_data` - Data kesehatan

Data disimpan lokal di device, tidak ada sync ke cloud.

## Customization

### Ubah Warna Tema

Edit file: `lib/utils/constants.dart`

```dart
static const Color primary = Color(0xFF6366F1); // Ubah kode warna
```

### Tambah Fitur Baru

1. Buat model di `lib/models/`
2. Update database service di `lib/services/database_service.dart`
3. Buat screen di `lib/screens/`
4. Tambahkan routing

## Support

Jika ada masalah:

1. Cek `flutter doctor`
2. Cek error log di terminal
3. Google error message
4. Baca dokumentasi Flutter: https://flutter.dev/docs

---

**Selamat Menggunakan DailyFit Student! 🎉**
