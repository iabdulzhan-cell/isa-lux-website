-- ISA LUX Sample Products Seed
-- Run this in Supabase SQL Editor after schema.sql

-- =====================
-- CLEANING CHEMICALS
-- =====================

-- Floor Cleaner
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-FC-001',
  (SELECT id FROM isa_categories WHERE slug='floor-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Средство для мытья полов ISA LUX Лимон 5л',
  'ISA LUX Лимон едендік тазалағыш 5л',
  'ISA LUX Floor Cleaner Lemon 5L',
  'Профессиональное средство для мытья полов с ароматом лимона. Эффективно удаляет загрязнения, оставляет приятный аромат. Подходит для всех типов напольных покрытий.',
  2500, 1800, 1400, 20, 'л', '5л', 150, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-FC-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-FC-002',
  (SELECT id FROM isa_categories WHERE slug='floor-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Средство для мытья полов ISA LUX Сосна 1л',
  'ISA LUX Қарағай едендік тазалағыш 1л',
  'ISA LUX Floor Cleaner Pine 1L',
  'Концентрированное средство для полов с хвойным ароматом. Дезинфицирует и освежает.',
  650, 450, 350, 50, 'л', '1л', 300, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-FC-002');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-FC-003',
  (SELECT id FROM isa_categories WHERE slug='floor-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Средство для мытья полов ISA LUX 10л (канистра)',
  'ISA LUX едендік тазалағыш 10л (канистр)',
  'ISA LUX Floor Cleaner 10L (Canister)',
  'Экономичная канистра 10л для профессионального использования. Концентрат — разводить 1:10.',
  4500, 3200, 2500, 10, 'л', '10л', 80, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-FC-003');

-- Toilet Cleaner
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-TC-001',
  (SELECT id FROM isa_categories WHERE slug='toilet-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Средство для унитаза ISA LUX Антибактериальное 750мл',
  'ISA LUX Антибактериялдық дәретхана тазалағыш 750мл',
  'ISA LUX Toilet Cleaner Antibacterial 750ml',
  'Мощное антибактериальное средство для чистки унитазов. Уничтожает 99.9% бактерий, удаляет известковый налёт.',
  890, 620, 480, 30, 'шт', '750мл', 200, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-TC-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-TC-002',
  (SELECT id FROM isa_categories WHERE slug='toilet-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Таблетки для унитаза ISA LUX (10 шт)',
  'ISA LUX дәретхана таблеткасы (10 дана)',
  'ISA LUX Toilet Tablets (10 pcs)',
  'Таблетки для бачка унитаза с антибактериальным эффектом. Одна таблетка — до 500 смывов.',
  450, 320, 250, 50, 'упак', '10шт', 400, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-TC-002');

-- Disinfectant
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-DZ-001',
  (SELECT id FROM isa_categories WHERE slug='disinfectant'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Дезинфектор ISA LUX Professional 5л',
  'ISA LUX Professional дезинфекциялық зат 5л',
  'ISA LUX Professional Disinfectant 5L',
  'Профессиональный дезинфицирующий раствор. Эффективен против бактерий, вирусов, грибков. Сертифицирован МЗ РК.',
  3800, 2700, 2100, 20, 'л', '5л', 120, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-DZ-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-DZ-002',
  (SELECT id FROM isa_categories WHERE slug='disinfectant'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Дезинфектор ISA LUX Спрей 500мл',
  'ISA LUX дезинфекциялық спрей 500мл',
  'ISA LUX Disinfectant Spray 500ml',
  'Спрей-дезинфектор для поверхностей. Быстрое нанесение без разведения.',
  1200, 850, 660, 30, 'шт', '500мл', 250, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-DZ-002');

-- Bleach
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-BL-001',
  (SELECT id FROM isa_categories WHERE slug='bleach'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Отбеливатель ISA LUX Хлор 5л',
  'ISA LUX Хлор ағартқыш 5л',
  'ISA LUX Bleach Chlorine 5L',
  'Концентрированный отбеливатель на основе хлора. Отбеливание, дезинфекция, удаление плесени.',
  1800, 1300, 1000, 20, 'л', '5л', 180, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-BL-001');

-- Glass Cleaner
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-GL-001',
  (SELECT id FROM isa_categories WHERE slug='glass-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Средство для стекол ISA LUX 500мл спрей',
  'ISA LUX шыны тазалағыш спрей 500мл',
  'ISA LUX Glass Cleaner Spray 500ml',
  'Не оставляет разводов. Быстро испаряется. Для стекол, зеркал, хромированных поверхностей.',
  750, 520, 400, 30, 'шт', '500мл', 350, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-GL-001');

-- Kitchen Degreaser
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-KD-001',
  (SELECT id FROM isa_categories WHERE slug='kitchen-degreaser'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Обезжириватель для кухни ISA LUX 1л',
  'ISA LUX ас үй майсыздандырғышы 1л',
  'ISA LUX Kitchen Degreaser 1L',
  'Мощный обезжириватель для кухонных поверхностей, плит, вытяжек. Растворяет застаревший жир.',
  950, 680, 520, 30, 'л', '1л', 200, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-KD-001');

-- Universal Cleaner
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-UC-001',
  (SELECT id FROM isa_categories WHERE slug='universal-cleaner'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Универсальный очиститель ISA LUX 5л',
  'ISA LUX Әмбебап тазалағыш 5л',
  'ISA LUX Universal Cleaner 5L',
  'Многофункциональное чистящее средство для любых поверхностей в доме, офисе, ресторане.',
  2200, 1600, 1200, 20, 'л', '5л', 160, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-UC-001');

-- =====================
-- PAPER SUPPLIES
-- =====================

-- Toilet Paper
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-TP-001',
  (SELECT id FROM isa_categories WHERE slug='toilet-paper'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Туалетная бумага ISA LUX 2-слойная 200м (12 рул)',
  'ISA LUX 2 қабатты туалет қағазы 200м (12 рулон)',
  'ISA LUX Toilet Paper 2-ply 200m (12 rolls)',
  'Мягкая 2-слойная туалетная бумага. 200 метров на рулоне. Упаковка 12 рулонов.',
  1800, 1300, 1000, 30, 'упак', 500, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-TP-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-TP-002',
  (SELECT id FROM isa_categories WHERE slug='toilet-paper'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Туалетная бумага ISA LUX Jumbo 300м (6 рул)',
  'ISA LUX Jumbo туалет қағазы 300м (6 рулон)',
  'ISA LUX Toilet Paper Jumbo 300m (6 rolls)',
  'Джамбо-рулон для диспенсеров. 300 метров, 1-слойный. Для отелей, ресторанов, офисов.',
  2400, 1700, 1300, 20, 'упак', 300, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-TP-002');

-- Paper Towels
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-PT-001',
  (SELECT id FROM isa_categories WHERE slug='paper-towels'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Бумажные полотенца ISA LUX V-сложение (200 л) 20 пач',
  'ISA LUX V-бүктеу қағаз сүлгілер (200 парақ) 20 пакет',
  'ISA LUX Paper Towels V-fold (200 sheets) 20 packs',
  'Однослойные бумажные полотенца V-сложения. 200 листов в пачке, 20 пачек в упаковке.',
  3500, 2500, 1950, 15, 'упак', 250, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-PT-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-PT-002',
  (SELECT id FROM isa_categories WHERE slug='paper-towels'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Полотенца бумажные рулон 150м для диспенсера (6 шт)',
  'Диспенсерге арналған қағаз сүлгі орамы 150м (6 дана)',
  'Paper Towel Roll 150m for Dispenser (6 pcs)',
  '2-слойные рулонные полотенца для диспенсеров. Высокая впитываемость.',
  2800, 2000, 1550, 15, 'упак', 180, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-PT-002');

-- Trash Bags
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-TB-001',
  (SELECT id FROM isa_categories WHERE slug='trash-bags'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Мешки для мусора 120л чёрные (50 шт)',
  'Қоқыс қаптары 120л қара (50 дана)',
  'Trash Bags 120L Black (50 pcs)',
  'Прочные мусорные мешки 120 литров. Толщина 30 мкм. Упаковка 50 штук.',
  1200, 850, 660, 30, 'упак', 400, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-TB-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-TB-002',
  (SELECT id FROM isa_categories WHERE slug='trash-bags'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Мешки для мусора 60л чёрные (50 шт)',
  'Қоқыс қаптары 60л қара (50 дана)',
  'Trash Bags 60L Black (50 pcs)',
  'Стандартные мешки для мусора 60 литров. Для офисных корзин и небольших ведер.',
  850, 600, 460, 50, 'упак', 600, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-TB-002');

-- Napkins
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-NP-001',
  (SELECT id FROM isa_categories WHERE slug='napkins'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Салфетки бумажные 24х24 белые (400 шт) 18 пач',
  'Ақ қағаз майлықтар 24х24 (400 дана) 18 пакет',
  'Paper Napkins 24x24 White (400 pcs) 18 packs',
  'Однослойные бумажные салфетки для диспенсеров и столов. 400 листов в пачке.',
  4200, 3000, 2300, 10, 'упак', 200, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-NP-001');

-- =====================
-- CLEANING INVENTORY
-- =====================

-- Mops
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-MP-001',
  (SELECT id FROM isa_categories WHERE slug='mops'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Швабра с отжимом ISA LUX Professional',
  'ISA LUX Professional сығылатын шаңжуғыш',
  'ISA LUX Professional Mop with Wringer',
  'Профессиональная швабра с механизмом отжима. Телескопическая ручка 120см. Насадка из микрофибры.',
  4500, 3200, 2500, 10, 'шт', null, 120, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-MP-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-MP-002',
  (SELECT id FROM isa_categories WHERE slug='mops'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Насадка для швабры микрофибра (сменная)',
  'Шаңжуғышқа арналған микрофибра тіркемесі (алмастырылатын)',
  'Microfiber Mop Head Replacement',
  'Сменная насадка из микрофибры. Подходит для большинства швабр. Машинная стирка до 300 раз.',
  1200, 850, 660, 20, 'шт', null, 250, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-MP-002');

-- Buckets
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-BK-001',
  (SELECT id FROM isa_categories WHERE slug='buckets'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Ведро с отжимом 20л на колёсах ISA LUX',
  'ISA LUX дөңгелекті сығылатын шелек 20л',
  'ISA LUX Mop Bucket with Wringer 20L on Wheels',
  'Профессиональное ведро 20 литров с педальным отжимом и колёсами. Для торговых центров, отелей.',
  8500, 6000, 4700, 5, 'шт', null, 60, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-BK-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-BK-002',
  (SELECT id FROM isa_categories WHERE slug='buckets'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Ведро пластиковое 12л с меркой',
  'Өлшем белгісі бар пластик шелек 12л',
  'Plastic Bucket 12L with Scale',
  'Прочное ведро с мерной шкалой. Удобная ручка. Для бытового и профессионального использования.',
  950, 680, 520, 20, 'шт', null, 200, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-BK-002');

-- Gloves
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-GV-001',
  (SELECT id FROM isa_categories WHERE slug='gloves'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Перчатки резиновые хозяйственные L (12 пар)',
  'Резеңке шаруашылық қолғаптар L (12 жұп)',
  'Rubber Household Gloves L (12 pairs)',
  'Плотные резиновые перчатки для уборки и работы с химией. Размер L. Упаковка 12 пар.',
  1800, 1300, 1000, 20, 'упак', null, 300, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-GV-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-GV-002',
  (SELECT id FROM isa_categories WHERE slug='gloves'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Перчатки нитриловые одноразовые S/M/L (100 шт)',
  'Нитрилді бір рет қолданылатын қолғаптар S/M/L (100 дана)',
  'Nitrile Disposable Gloves S/M/L (100 pcs)',
  'Одноразовые нитриловые перчатки без пудры. Коробка 100 штук. Размеры: S, M, L.',
  2200, 1600, 1200, 15, 'упак', null, 400, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-GV-002');

-- Rags
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-RG-001',
  (SELECT id FROM isa_categories WHERE slug='rags'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Тряпки микрофибра 40х40 (10 шт)',
  'Микрофибра шүберектер 40х40 (10 дана)',
  'Microfiber Cloths 40x40 (10 pcs)',
  'Профессиональные микрофибровые тряпки. Отлично впитывают, не оставляют следов. 10 штук в упаковке.',
  1500, 1100, 850, 20, 'упак', null, 350, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-RG-001');

-- Brushes
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-BR-001',
  (SELECT id FROM isa_categories WHERE slug='brushes'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Щётка для туалета с подставкой (набор)',
  'Тұғырлы дәретхана щеткасы (жиынтық)',
  'Toilet Brush Set with Holder',
  'Щётка для туалета с держателем и подставкой. Нержавеющая сталь. Антибактериальная щетина.',
  1800, 1300, 1000, 10, 'шт', null, 180, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-BR-001');

-- =====================
-- HYGIENE PRODUCTS
-- =====================

-- Liquid Soap
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-LS-001',
  (SELECT id FROM isa_categories WHERE slug='liquid-soap'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Жидкое мыло ISA LUX Антибактериальное 5л',
  'ISA LUX Антибактериялдық сұйық сабын 5л',
  'ISA LUX Liquid Soap Antibacterial 5L',
  'Антибактериальное жидкое мыло для диспенсеров. Нежный уход, приятный аромат.',
  2800, 2000, 1550, 20, 'л', '5л', 200, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-LS-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-LS-002',
  (SELECT id FROM isa_categories WHERE slug='liquid-soap'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Жидкое мыло ISA LUX Жемчужное 1л',
  'ISA LUX Маржан сұйық сабын 1л',
  'ISA LUX Liquid Soap Pearl 1L',
  'Нежное жидкое мыло-крем с перламутровым эффектом. Увлажняет кожу рук.',
  750, 520, 400, 50, 'л', '1л', 300, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-LS-002');

-- Antiseptic
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-AS-001',
  (SELECT id FROM isa_categories WHERE slug='antiseptic'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Антисептик ISA LUX 5л (70% спирт)',
  'ISA LUX антисептик 5л (70% спирт)',
  'ISA LUX Antiseptic 5L (70% alcohol)',
  'Антисептик на основе этилового спирта 70%. Для рук и поверхностей. Одобрен МЗ РК.',
  3500, 2500, 1950, 20, 'л', '5л', 150, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-AS-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-AS-002',
  (SELECT id FROM isa_categories WHERE slug='antiseptic'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Антисептик-гель ISA LUX 500мл помпа',
  'ISA LUX антисептик-гель 500мл помпа',
  'ISA LUX Antiseptic Gel 500ml Pump',
  'Гель-антисептик с дозатором-помпой. Без смывания. Увлажняет кожу.',
  1400, 1000, 780, 30, 'шт', '500мл', 250, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-AS-002');

-- Dispensers
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-DS-001',
  (SELECT id FROM isa_categories WHERE slug='dispensers'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Диспенсер для жидкого мыла 1л настенный',
  'Қабырғалы сұйық сабын диспенсері 1л',
  'Wall-mounted Liquid Soap Dispenser 1L',
  'Настенный диспенсер для жидкого мыла. Объём 1 литр. Нержавеющая сталь. Ключ в комплекте.',
  4500, 3200, 2500, 5, 'шт', null, 80, true, true
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-DS-001');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-DS-002',
  (SELECT id FROM isa_categories WHERE slug='dispensers'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Диспенсер для бумажных полотенец настенный',
  'Қабырғалы қағаз сүлгі диспенсері',
  'Wall-mounted Paper Towel Dispenser',
  'Диспенсер для листовых полотенец (V/Z-сложение). Пластик ABS. Объём 400 листов.',
  3800, 2700, 2100, 5, 'шт', null, 70, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-DS-002');

INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, stock, is_active, is_featured)
SELECT 'ISA-DS-003',
  (SELECT id FROM isa_categories WHERE slug='dispensers'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Диспенсер для туалетной бумаги Jumbo',
  'Jumbo туалет қағазы диспенсері',
  'Jumbo Toilet Paper Dispenser',
  'Диспенсер для джамбо-рулонов туалетной бумаги. ABS пластик. Замок в комплекте.',
  3200, 2300, 1800, 5, 'шт', null, 90, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-DS-003');

-- Air Fresheners
INSERT INTO isa_products (sku, category_id, brand_id, name_ru, name_kz, name_en, description_ru, retail_price, wholesale_price, distributor_price, min_wholesale_qty, unit, volume, stock, is_active, is_featured)
SELECT 'ISA-AF-001',
  (SELECT id FROM isa_categories WHERE slug='air-fresheners'),
  (SELECT id FROM isa_brands WHERE slug='isa-lux'),
  'Освежитель воздуха ISA LUX Цветочный 300мл',
  'ISA LUX гүлді ауа жаңартқыш 300мл',
  'ISA LUX Air Freshener Floral 300ml',
  'Аэрозольный освежитель воздуха с цветочным ароматом. Нейтрализует неприятные запахи.',
  850, 600, 460, 30, 'шт', '300мл', 300, true, false
WHERE NOT EXISTS (SELECT 1 FROM isa_products WHERE sku='ISA-AF-001');
