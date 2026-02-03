# Setup Supabase untuk DailyFit Student

## Pendahuluan

Aplikasi DailyFit Student sekarang menggunakan **Supabase** sebagai backend database dan autentikasi. Supabase adalah alternatif open-source untuk Firebase yang menyediakan PostgreSQL database, autentikasi, storage, dan real-time subscriptions.

---

## Langkah 1: Buat Akun Supabase

1. Kunjungi [https://supabase.com](https://supabase.com)
2. Klik **Start your project** atau **Sign Up**
3. Login menggunakan GitHub account (recommended) atau email
4. Setelah login, klik **New Project**

---

## Langkah 2: Buat Project Baru

1. **Organization**: Pilih atau buat organization baru
2. **Project Name**: `DailyFit Student` (atau nama pilihan Anda)
3. **Database Password**: Buat password yang kuat (simpan password ini!)
4. **Region**: Pilih region terdekat dengan lokasi Anda (contoh: Southeast Asia - Singapore)
5. **Pricing Plan**: Pilih **Free** untuk development
6. Klik **Create new project**

⏱️ Proses pembuatan project membutuhkan waktu 1-2 menit.

---

## Langkah 3: Buat Database Tables

Setelah project siap, buka **SQL Editor** dari sidebar kiri.

### Cara 1: Gunakan File SQL (Recommended)

1. Buka file `supabase_setup.sql` yang ada di root project
2. Copy seluruh isinya
3. Paste ke SQL Editor di Supabase Dashboard
4. Klik **Run** atau tekan `Ctrl+Enter`

### Cara 2: Copy Script Manual

Jika file SQL tidak tersedia, copy dan jalankan script berikut:

```sql
-- Tabel Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT auth.uid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users dapat read data mereka sendiri
CREATE POLICY "Users can read own data" ON users
  FOR SELECT USING (auth.uid() = id);

-- Policy: Users dapat update data mereka sendiri
CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Tabel Schedules
CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  instructor TEXT,
  room TEXT,
  day_of_week TEXT NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  type TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

-- Policy: Users hanya dapat mengakses schedules mereka
CREATE POLICY "Users can manage own schedules" ON schedules
  USING (auth.uid() = user_id);

-- Tabel Tasks
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  subject TEXT,
  due_date TIMESTAMP WITH TIME ZONE NOT NULL,
  is_completed INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Policy: Users hanya dapat mengakses tasks mereka
CREATE POLICY "Users can manage own tasks" ON tasks
  USING (auth.uid() = user_id);

-- Tabel Health Data
CREATE TABLE health_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  weight REAL NOT NULL,
  height REAL NOT NULL,
  age INTEGER NOT NULL,
  sleep_hours INTEGER NOT NULL,
  fatigue_note TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE health_data ENABLE ROW LEVEL SECURITY;

-- Policy: Users hanya dapat mengakses health data mereka
CREATE POLICY "Users can manage own health data" ON health_data
  USING (auth.uid() = user_id);

-- Indexes untuk performance
CREATE INDEX idx_schedules_user_day ON schedules(user_id, day_of_week);
CREATE INDEX idx_tasks_user_duedate ON tasks(user_id, due_date);
CREATE INDEX idx_health_data_user_date ON health_data(user_id, date);
```

Klik **Run** atau tekan `Ctrl+Enter` untuk mengeksekusi SQL.

---

## Langkah 4: Setup Authentication

1. Buka **Authentication** > **Providers** dari sidebar
2. Pastikan **Email** provider sudah enabled (biasanya default sudah enabled)
3. (Opsional) Anda bisa enable provider lain seperti Google, GitHub, dll.

### Konfigurasi Email Templates (Opsional)

1. Buka **Authentication** > **Email Templates**
2. Sesuaikan template untuk:
   - Confirm signup
   - Magic Link
   - Change Email Address
   - Reset Password

---

## Langkah 5: Dapatkan API Credentials

1. Buka **Settings** > **API** dari sidebar
2. Anda akan melihat:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **Project API keys**:
     - `anon` `public` key (untuk client-side)
     - `service_role` `secret` key (untuk server-side, jangan expose!)

3. Copy **Project URL** dan **anon public key**

---

## Langkah 6: Konfigurasi Flutter App

Buka file `lib/main.dart` dan ganti placeholder dengan credentials Anda:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xxxxx.supabase.co', // <-- Ganti dengan Project URL Anda
    anonKey: 'eyJhbGc...', // <-- Ganti dengan anon public key Anda
  );

  runApp(const DailyFitApp());
}
```

⚠️ **PENTING**:

- Gunakan **anon public key**, BUKAN service_role key
- Service role key memberikan akses penuh ke database dan tidak boleh di-expose di client

---

## Langkah 7: Install Dependencies

Jalankan command berikut di terminal:

```bash
flutter pub get
```

---

## Langkah 8: Testing

### Test Authentication

1. Jalankan aplikasi: `flutter run`
2. Coba register user baru
3. Check di **Supabase Dashboard** > **Authentication** > **Users**
4. User baru seharusnya muncul di list

### Test Database

1. Setelah login, coba tambah schedule, task, atau health data
2. Check di **Supabase Dashboard** > **Table Editor**
3. Pilih tabel yang sesuai (schedules, tasks, health_data)
4. Data yang Anda input seharusnya muncul di tabel

---

## Fitur Supabase yang Digunakan

### 1. **Authentication**

- Email/Password authentication
- Session management
- User management

### 2. **Database (PostgreSQL)**

- Users table
- Schedules table
- Tasks table
- Health data table

### 3. **Row Level Security (RLS)**

- Users hanya dapat mengakses data mereka sendiri
- Automatic filtering berdasarkan authenticated user ID

### 4. **Real-time (Opsional)**

Anda bisa enable real-time subscriptions untuk mendapatkan update otomatis saat data berubah.

---

## Monitoring dan Management

### Dashboard Utama

- **Table Editor**: Lihat dan edit data di tables
- **SQL Editor**: Jalankan custom SQL queries
- **Authentication**: Manage users dan sessions
- **Logs**: Monitor API requests dan errors
- **Database**: Lihat usage, connections, dan backups

### Useful SQL Queries

**Lihat semua users:**

```sql
SELECT * FROM users ORDER BY created_at DESC;
```

**Lihat schedules user tertentu:**

```sql
SELECT * FROM schedules
WHERE user_id = 'user-uuid-here'
ORDER BY day_of_week, start_time;
```

**Hitung total tasks per user:**

```sql
SELECT user_id, COUNT(*) as total_tasks,
       SUM(is_completed) as completed_tasks
FROM tasks
GROUP BY user_id;
```

---

## Troubleshooting

### Error: "Failed to fetch"

- Periksa koneksi internet
- Pastikan Supabase URL benar
- Check apakah project masih active di dashboard

### Error: "Invalid API key"

- Pastikan menggunakan **anon public key**, bukan service_role
- Check apakah key sudah di-copy dengan benar (tidak ada spasi di awal/akhir)

### Error: "Row Level Security"

- Pastikan RLS policies sudah dibuat dengan benar
- Check apakah user sudah login (auth.uid() tersedia)
- Test query di SQL Editor dengan user context

### Data tidak muncul

- Check RLS policies
- Pastikan user_id di data sesuai dengan authenticated user
- Lihat Logs di dashboard untuk error details

---

## Keamanan

### ✅ Best Practices

1. **JANGAN expose service_role key** di client code
2. **Gunakan RLS policies** untuk protect data
3. **Validate input** di client dan database (constraints)
4. **Enable email confirmation** untuk production
5. **Setup custom domain** untuk email (opsional)

### 🔒 Row Level Security

RLS memastikan bahwa:

- User A tidak bisa melihat data User B
- Queries automatically filtered berdasarkan authenticated user
- Database-level security, tidak bisa di-bypass dari client

---

## Migration dari Firebase

Aplikasi ini sebelumnya menggunakan Firebase. Perubahan utama:

### Perbedaan Struktur

- **Firebase**: NoSQL (Documents/Collections)
- **Supabase**: SQL (Tables/Rows)

### Perbedaan Authentication

- **Firebase**: `FirebaseAuth.instance.currentUser`
- **Supabase**: `Supabase.instance.client.auth.currentUser`

### Perbedaan Data Access

- **Firebase**: `collection('users').doc(id).get()`
- **Supabase**: `from('users').select().eq('id', id).single()`

---

## Resources

- **Supabase Docs**: https://supabase.com/docs
- **Flutter Supabase**: https://supabase.com/docs/reference/dart/introduction
- **SQL Tutorial**: https://www.postgresql.org/docs/current/tutorial.html
- **RLS Guide**: https://supabase.com/docs/guides/auth/row-level-security

---

## Support

Jika mengalami masalah:

1. Check **Supabase Dashboard** > **Logs** untuk error details
2. Baca dokumentasi di https://supabase.com/docs
3. Join Supabase Discord: https://discord.supabase.com

---

**Selamat menggunakan Supabase! 🎉**
