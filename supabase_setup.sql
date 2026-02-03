-- ==========================================
-- SUPABASE DATABASE SETUP
-- DailyFit Student Application
-- ==========================================

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

-- ==========================================
-- Tabel Schedules
-- ==========================================
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

-- ==========================================
-- Tabel Tasks
-- ==========================================
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  subject TEXT,
  due_date TIMESTAMP WITH TIME ZONE NOT NULL,
  is_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Policy: Users hanya dapat mengakses tasks mereka
CREATE POLICY "Users can manage own tasks" ON tasks
  USING (auth.uid() = user_id);

-- ==========================================
-- Tabel Health Data
-- ==========================================
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

-- ==========================================
-- Indexes untuk Performance
-- ==========================================
CREATE INDEX idx_schedules_user_day ON schedules(user_id, day_of_week);
CREATE INDEX idx_tasks_user_duedate ON tasks(user_id, due_date);
CREATE INDEX idx_health_data_user_date ON health_data(user_id, date);
