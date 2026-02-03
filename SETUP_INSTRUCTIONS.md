# 🚀 Panduan Setup DailyFit Student

## Masalah Utama & Solusi

### ❌ Error: "YOUR_SUPABASE_URL" belum dikonfigurasi

Aplikasi tidak bisa berjalan karena kredensial Supabase masih placeholder. Ikuti langkah-langkah di bawah ini.

---

## 📋 Langkah Setup (5-10 Menit)

### 1️⃣ Buat Akun & Project Supabase

1. Kunjungi https://supabase.com
2. Klik **"Start your project"** → Sign up (gratis)
3. Setelah login, klik **"New Project"**
4. Isi form:
   - **Name**: `dailyfit-student` (atau nama lain)
   - **Database Password**: Buat password kuat (simpan baik-baik!)
   - **Region**: Pilih yang terdekat (Southeast Asia untuk Indonesia)
5. Klik **"Create new project"**
6. Tunggu 2-3 menit hingga project selesai dibuat

---

### 2️⃣ Setup Database

1. Di Supabase Dashboard, klik **"SQL Editor"** di menu kiri
2. Buka file `supabase_setup.sql` di VS Code
3. **Copy semua isinya** (Ctrl+A, Ctrl+C)
4. **Paste** ke SQL Editor di Supabase (Ctrl+V)
5. Klik tombol **"Run"** atau tekan **Ctrl+Enter**
6. Jika sukses, Anda akan lihat pesan "Success. No rows returned"

✅ Database siap! Anda sekarang punya 4 tabel:

- `users` - Data pengguna
- `schedules` - Jadwal kuliah/aktivitas
- `tasks` - Tugas & deadline
- `health_data` - Data kesehatan & BMI

---

### 3️⃣ Dapatkan API Credentials

1. Di Supabase Dashboard, klik **⚙️ Settings** → **API**
2. Scroll ke bawah, Anda akan lihat:

   **Project URL**

   ```
   https://xxxxxxxxxxxxx.supabase.co
   ```

   **Project API keys** → `anon` `public`

   ```
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3M...
   ```

3. **Copy** kedua nilai ini

---

### 4️⃣ Update Kode Flutter

1. Buka file `lib/main.dart`
2. Ganti baris 10-11:

**SEBELUM:**

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

**SESUDAH:**

```dart
await Supabase.initialize(
  url: 'https://xxxxxxxxxxxxx.supabase.co',  // ← Paste Project URL Anda
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',  // ← Paste anon key Anda
);
```

3. **Save** file (Ctrl+S)

---

### 5️⃣ Jalankan Aplikasi

```bash
flutter pub get
flutter run
```

Pilih device (Chrome untuk web, atau Android emulator).

---

## ✅ Testing

### Test 1: Register User Baru

1. Klik **"Daftar Sekarang"**
2. Isi:
   - Nama: `Test User`
   - Email: `test@example.com`
   - Password: `password123`
3. Klik **"Daftar"**
4. Jika sukses, Anda akan masuk ke Dashboard

**Verifikasi di Supabase:**

- Buka **Authentication** → **Users** → Lihat user baru
- Buka **Table Editor** → **users** → Lihat data nama

### Test 2: Tambah Jadwal

1. Di Dashboard, klik **"+"** di section Jadwal
2. Tambah jadwal kuliah/kerja
3. Simpan

**Verifikasi:**

- Jadwal muncul di Dashboard
- Cek **Table Editor** → **schedules**

### Test 3: Tambah Tugas

1. Klik menu **"Tugas"** di bottom nav
2. Tambah tugas baru dengan deadline
3. Simpan

**Verifikasi:**

- Tugas muncul di list
- Upcoming tasks muncul di Dashboard

### Test 4: Input Data Kesehatan

1. Klik menu **"Kesehatan"**
2. Isi tinggi, berat, jam tidur
3. Simpan
4. Lihat BMI terhitung otomatis

---

## 🔒 Keamanan Row Level Security (RLS)

Database sudah dilindungi dengan RLS:

- ✅ User hanya bisa lihat/edit data milik mereka sendiri
- ✅ Tidak bisa akses data user lain
- ✅ Authentication wajib untuk semua operasi

---

## ❓ Troubleshooting

### Error: "Invalid API key"

- Pastikan anon key yang di-copy **lengkap** (panjang sekitar 100+ karakter)
- Cek tidak ada spasi tambahan

### Error: "Failed host lookup"

- Pastikan URL lengkap dengan `https://`
- Cek koneksi internet

### Error: "null value in column id"

- User belum login
- Jalankan ulang aplikasi dan register/login dulu

### Database kosong setelah restart

- Ini normal jika development
- Data tersimpan di Supabase, bukan local
- Login dengan akun yang sama untuk lihat data

---

## 📱 Build APK

Setelah testing OK, build APK release:

```bash
flutter build apk --release
```

APK ada di: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🎯 Fitur Aplikasi

✅ **Authentication** - Register & Login dengan Supabase Auth  
✅ **Dashboard** - Overview jadwal hari ini, upcoming tasks, health summary  
✅ **Jadwal** - Manage jadwal kuliah/kerja per hari (Senin-Minggu)  
✅ **Tugas** - Track tugas dengan deadline & status completion  
✅ **Kesehatan** - Input tinggi, berat, tidur → Auto calculate BMI  
✅ **Profile** - Lihat & edit profile user

---

## 📞 Support

Jika masih ada error, kirim screenshot error dan file mana yang bermasalah.

**Selamat mencoba! 🎉**
