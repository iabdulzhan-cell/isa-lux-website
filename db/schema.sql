-- ISA LUX Database Schema
-- Run this in Supabase SQL Editor
-- Tables use prefix "isa_" to avoid conflicts with other projects

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================
-- ISA_CATEGORIES
-- =====================
CREATE TABLE IF NOT EXISTS isa_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug TEXT UNIQUE NOT NULL,
  name_ru TEXT NOT NULL,
  name_kz TEXT NOT NULL,
  name_en TEXT NOT NULL,
  description_ru TEXT,
  description_kz TEXT,
  description_en TEXT,
  icon TEXT,
  image TEXT,
  parent_id UUID REFERENCES isa_categories(id),
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- ISA_BRANDS
-- =====================
CREATE TABLE IF NOT EXISTS isa_brands (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  logo TEXT,
  country TEXT,
  is_active BOOLEAN DEFAULT TRUE
);

-- =====================
-- ISA_PRODUCTS
-- =====================
CREATE TABLE IF NOT EXISTS isa_products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sku TEXT UNIQUE,
  category_id UUID REFERENCES isa_categories(id),
  brand_id UUID REFERENCES isa_brands(id),
  name_ru TEXT NOT NULL,
  name_kz TEXT NOT NULL,
  name_en TEXT NOT NULL,
  description_ru TEXT,
  description_kz TEXT,
  description_en TEXT,
  retail_price NUMERIC(12,2) NOT NULL DEFAULT 0,
  wholesale_price NUMERIC(12,2),
  distributor_price NUMERIC(12,2),
  min_wholesale_qty INTEGER DEFAULT 1,
  unit TEXT DEFAULT 'шт',
  volume TEXT,
  weight TEXT,
  stock INTEGER DEFAULT 0,
  images JSONB DEFAULT '[]',
  tags TEXT[],
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- ISA_USERS
-- =====================
CREATE TABLE IF NOT EXISTS isa_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  role TEXT DEFAULT 'retail' CHECK (role IN ('retail','wholesale','distributor','admin')),
  company TEXT,
  bin TEXT,
  address TEXT,
  city TEXT DEFAULT 'Алматы',
  is_approved BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- ISA_ORDERS
-- =====================
CREATE TABLE IF NOT EXISTS isa_orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number TEXT UNIQUE,
  user_id UUID REFERENCES isa_users(id),
  guest_name TEXT,
  guest_phone TEXT,
  guest_email TEXT,
  status TEXT DEFAULT 'new' CHECK (status IN ('new','confirmed','processing','shipped','delivered','cancelled')),
  payment_method TEXT CHECK (payment_method IN ('kaspi','halyk','forte','epay','cash','transfer')),
  payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending','paid','failed','refunded')),
  delivery_type TEXT CHECK (delivery_type IN ('almaty_own','almaty_yandex','almaty_glovo','almaty_wolt','region_cdek','region_almex','region_pony','pickup')),
  delivery_address TEXT,
  delivery_city TEXT,
  subtotal NUMERIC(12,2) DEFAULT 0,
  delivery_cost NUMERIC(12,2) DEFAULT 0,
  discount NUMERIC(12,2) DEFAULT 0,
  total NUMERIC(12,2) DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- ISA_ORDER_ITEMS
-- =====================
CREATE TABLE IF NOT EXISTS isa_order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES isa_orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES isa_products(id),
  product_name TEXT NOT NULL,
  qty INTEGER NOT NULL DEFAULT 1,
  price NUMERIC(12,2) NOT NULL,
  total NUMERIC(12,2) NOT NULL
);

-- =====================
-- ISA_CART_ITEMS
-- =====================
CREATE TABLE IF NOT EXISTS isa_cart_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES isa_users(id) ON DELETE CASCADE,
  session_id TEXT,
  product_id UUID REFERENCES isa_products(id) ON DELETE CASCADE,
  qty INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id),
  UNIQUE(session_id, product_id)
);

-- =====================
-- ISA_REVIEWS
-- =====================
CREATE TABLE IF NOT EXISTS isa_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES isa_products(id) ON DELETE CASCADE,
  user_id UUID REFERENCES isa_users(id),
  name TEXT,
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  is_approved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- ISA_BANNERS
-- =====================
CREATE TABLE IF NOT EXISTS isa_banners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title_ru TEXT, title_kz TEXT, title_en TEXT,
  subtitle_ru TEXT, subtitle_kz TEXT, subtitle_en TEXT,
  image TEXT, link TEXT,
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE
);

-- =====================
-- SEED: CATEGORIES
-- =====================
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, icon, sort_order) VALUES
('cleaning-chemicals', 'Химия для уборки', 'Тазалыққа арналған химия', 'Cleaning Chemicals', '🧴', 1),
('paper-supplies', 'Бумажные расходники', 'Қағаз жабдықтары', 'Paper Supplies', '🧻', 2),
('cleaning-inventory', 'Инвентарь для уборки', 'Тазалыққа арналған мүкәммал', 'Cleaning Inventory', '🧹', 3),
('hygiene-products', 'Средства гигиены', 'Гигиена құралдары', 'Hygiene Products', '🧼', 4)
ON CONFLICT (slug) DO NOTHING;

INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'floor-cleaner','Средство для пола','Еден тазалағыш','Floor Cleaner',id,1 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'toilet-cleaner','Средство для туалета','Дәретхана тазалағыш','Toilet Cleaner',id,2 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'universal-cleaner','Универсальный очиститель','Әмбебап тазалағыш','Universal Cleaner',id,3 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'disinfectant','Дезинфицирующее средство','Дезинфекциялық зат','Disinfectant',id,4 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'bleach','Отбеливатель','Ағартқыш','Bleach',id,5 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'glass-cleaner','Средство для стекол','Шыны тазалағыш','Glass Cleaner',id,6 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'kitchen-degreaser','Средство для кухни (жир)','Ас үй тазалағышы (май)','Kitchen Degreaser',id,7 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'drain-cleaner','Средство для канализации','Кәріз тазалағыш','Drain Cleaner',id,8 FROM isa_categories WHERE slug='cleaning-chemicals' ON CONFLICT (slug) DO NOTHING;

INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'toilet-paper','Туалетная бумага','Туалет қағазы','Toilet Paper',id,1 FROM isa_categories WHERE slug='paper-supplies' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'paper-towels','Бумажные полотенца','Қағаз сүлгілер','Paper Towels',id,2 FROM isa_categories WHERE slug='paper-supplies' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'napkins','Салфетки','Майлықтар','Napkins',id,3 FROM isa_categories WHERE slug='paper-supplies' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'trash-bags','Мешки для мусора','Қоқыс қаптары','Trash Bags',id,4 FROM isa_categories WHERE slug='paper-supplies' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'hand-paper','Бумага для рук','Қолға арналған қағаз','Hand Paper',id,5 FROM isa_categories WHERE slug='paper-supplies' ON CONFLICT (slug) DO NOTHING;

INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'mops','Швабры','Шаңжуғыш','Mops',id,1 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'buckets','Ведра','Шелектер','Buckets',id,2 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'brushes','Щетки','Щеткалар','Brushes',id,3 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'rags','Тряпки','Шүберектер','Rags',id,4 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'trolleys','Тележки для уборки','Тазалыққа арналған арбалар','Cleaning Trolleys',id,5 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'gloves','Перчатки','Қолғаптар','Gloves',id,6 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'wring-buckets','Ведро с отжимом','Сығылатын шелек','Wring Buckets',id,7 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'vacuums','Пылесосы','Шаңсорғыштар','Vacuums',id,8 FROM isa_categories WHERE slug='cleaning-inventory' ON CONFLICT (slug) DO NOTHING;

INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'liquid-soap','Жидкое мыло','Сұйық сабын','Liquid Soap',id,1 FROM isa_categories WHERE slug='hygiene-products' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'antiseptic','Антисептик','Антисептик','Antiseptic',id,2 FROM isa_categories WHERE slug='hygiene-products' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'dispensers','Диспенсеры','Диспенсерлер','Dispensers',id,3 FROM isa_categories WHERE slug='hygiene-products' ON CONFLICT (slug) DO NOTHING;
INSERT INTO isa_categories (slug, name_ru, name_kz, name_en, parent_id, sort_order) SELECT 'air-fresheners','Освежители воздуха','Ауа жаңартқыштар','Air Fresheners',id,4 FROM isa_categories WHERE slug='hygiene-products' ON CONFLICT (slug) DO NOTHING;

-- =====================
-- SEED: BRANDS
-- =====================
INSERT INTO isa_brands (slug, name, country) VALUES
('isa-lux', 'ISA LUX', 'Kazakhstan'),
('chinese-brand', 'Chinese Brand', 'China')
ON CONFLICT (slug) DO NOTHING;

-- =====================
-- ADMIN USER
-- =====================
INSERT INTO isa_users (email, password, name, phone, role, is_approved, is_active) VALUES
('admin@isalux.kz', '$2a$10$CDPRrjHUTTmq1PmxdRAVm.2QZyP36NP16FzPp4tk9vdtNZNh98eAG', 'Администратор ISA LUX', '+77770000000', 'admin', true, true)
ON CONFLICT (email) DO NOTHING;

-- =====================
-- AUTO ORDER NUMBER
-- =====================
CREATE OR REPLACE FUNCTION isa_generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.order_number := 'ISA-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(FLOOR(RANDOM() * 9000 + 1000)::TEXT, 4, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS isa_set_order_number ON isa_orders;
CREATE TRIGGER isa_set_order_number
BEFORE INSERT ON isa_orders
FOR EACH ROW
WHEN (NEW.order_number IS NULL)
EXECUTE FUNCTION isa_generate_order_number();

-- =====================
-- INDEXES
-- =====================
CREATE INDEX IF NOT EXISTS idx_isa_products_category ON isa_products(category_id);
CREATE INDEX IF NOT EXISTS idx_isa_products_active ON isa_products(is_active);
CREATE INDEX IF NOT EXISTS idx_isa_orders_user ON isa_orders(user_id);
CREATE INDEX IF NOT EXISTS idx_isa_orders_status ON isa_orders(status);
CREATE INDEX IF NOT EXISTS idx_isa_cart_user ON isa_cart_items(user_id);
CREATE INDEX IF NOT EXISTS idx_isa_cart_session ON isa_cart_items(session_id);
