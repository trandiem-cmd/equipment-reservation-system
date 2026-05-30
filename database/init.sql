CREATE TYPE user_role AS ENUM (
  'student',
  'staff',
  'admin'
);
CREATE TYPE equipment_category AS ENUM (
  'vr_ar',
  'robotics',
  'audio_video',
  'laboratory',
  'computing',
  'iot_embedded'
);
CREATE TYPE equipment_status AS ENUM (
  'available',
  'reserved',
  'checked_out',
  'pending_return',
  'maintenance'
);

CREATE TYPE reservation_status AS ENUM (
  'approved',
  'active',
  'completed',
  'cancelled'
);

CREATE TYPE log_action AS ENUM (
  'reserve',
  'checkout',
  'return_scan',
  'admin_confirm_return',
  'cancel',
  'maintenance'
);
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS equipment CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS equipment_logs CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,

  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,

  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,

  role user_role NOT NULL,

  is_active BOOLEAN DEFAULT TRUE,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE equipment (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category equipment_category NOT NULL,
  description TEXT,
  location VARCHAR(100),

  qr_code VARCHAR(100) UNIQUE NOT NULL,

  status equipment_status DEFAULT 'available',

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()

);

CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,

  user_id INT NOT NULL,
  equipment_id INT NOT NULL,

  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,

  status reservation_status DEFAULT 'approved',

  checkout_time TIMESTAMP,
  return_time TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW(),

  CONSTRAINT fk_res_user
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_res_equipment
    FOREIGN KEY (equipment_id)
    REFERENCES equipment(id)
    ON DELETE CASCADE
);

CREATE TABLE equipment_logs (
  id SERIAL PRIMARY KEY,

  equipment_id INT NOT NULL,
  user_id INT,

  action log_action NOT NULL,

  status_before equipment_status,
  status_after equipment_status,

  created_at TIMESTAMP DEFAULT NOW(),

  CONSTRAINT fk_log_equipment
    FOREIGN KEY (equipment_id)
    REFERENCES equipment(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_log_user
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE SET NULL
);
