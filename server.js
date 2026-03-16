import express from 'express';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';
import { supabase } from './supabase.js';

dotenv.config();
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'isa-lux-secret-2024';

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// File upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, path.join(__dirname, 'public/images/products')),
  filename: (req, file, cb) => cb(null, Date.now() + '-' + file.originalname.replace(/\s/g, '_'))
});
const upload = multer({ storage, limits: { fileSize: 5 * 1024 * 1024 } });

// ── Auth Middleware ──────────────────────────────────────────
function authMiddleware(req, res, next) {
  const token = req.cookies.token || req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
}

function adminMiddleware(req, res, next) {
  authMiddleware(req, res, () => {
    if (req.user.role !== 'admin') return res.status(403).json({ error: 'Forbidden' });
    next();
  });
}

function optionalAuth(req, res, next) {
  const token = req.cookies.token || req.headers.authorization?.replace('Bearer ', '');
  if (token) {
    try { req.user = jwt.verify(token, JWT_SECRET); } catch {}
  }
  next();
}

// ── Telegram Notification ────────────────────────────────────
async function sendTelegram(message) {
  const { TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID } = process.env;
  if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_CHAT_ID) return;
  try {
    await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ chat_id: TELEGRAM_CHAT_ID, text: message, parse_mode: 'HTML' })
    });
  } catch (e) { console.error('Telegram error:', e.message); }
}

// ══════════════════════════════════════════════════════════════
// AUTH ROUTES
// ══════════════════════════════════════════════════════════════

// Register
app.post('/api/auth/register', async (req, res) => {
  const { email, password, name, phone, role, company, bin } = req.body;
  if (!email || !password || !name) return res.status(400).json({ error: 'Заполните все поля' });
  if (password.length < 6) return res.status(400).json({ error: 'Пароль минимум 6 символов' });

  const { data: existing } = await supabase.from('isa_users').select('id').eq('email', email).single();
  if (existing) return res.status(400).json({ error: 'Email уже зарегистрирован' });

  const hashedPassword = await bcrypt.hash(password, 10);
  const userRole = ['wholesale', 'distributor'].includes(role) ? role : 'retail';
  const isApproved = userRole === 'retail';

  const { data, error } = await supabase.from('isa_users').insert({
    email, password: hashedPassword, name, phone,
    role: userRole, company, bin, is_approved: isApproved
  }).select().single();

  if (error) return res.status(500).json({ error: error.message });

  if (!isApproved) {
    await sendTelegram(`🆕 <b>Новый оптовый клиент!</b>\n👤 ${name}\n📧 ${email}\n📱 ${phone || '-'}\n🏢 ${company || '-'}\nРоль: ${userRole}`);
  }

  const token = jwt.sign({ id: data.id, email, role: data.role, is_approved: isApproved }, JWT_SECRET, { expiresIn: '30d' });
  res.cookie('token', token, { httpOnly: true, maxAge: 30 * 24 * 3600 * 1000 });
  res.json({ success: true, user: { id: data.id, name, email, role: data.role, is_approved: isApproved } });
});

// Login
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  const { data: user, error } = await supabase.from('isa_users').select('*').eq('email', email).single();
  if (error || !user) return res.status(401).json({ error: 'Неверный email или пароль' });

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) return res.status(401).json({ error: 'Неверный email или пароль' });
  if (!user.is_active) return res.status(403).json({ error: 'Аккаунт заблокирован' });

  const token = jwt.sign({ id: user.id, email: user.email, role: user.role, is_approved: user.is_approved }, JWT_SECRET, { expiresIn: '30d' });
  res.cookie('token', token, { httpOnly: true, maxAge: 30 * 24 * 3600 * 1000 });
  res.json({ success: true, user: { id: user.id, name: user.name, email: user.email, role: user.role, is_approved: user.is_approved } });
});

// Logout
app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token');
  res.json({ success: true });
});

// Me
app.get('/api/auth/me', authMiddleware, async (req, res) => {
  const { data } = await supabase.from('isa_users').select('id,name,email,phone,role,company,is_approved,city,address').eq('id', req.user.id).single();
  res.json(data);
});

// ══════════════════════════════════════════════════════════════
// CATEGORIES
// ══════════════════════════════════════════════════════════════

app.get('/api/categories', async (req, res) => {
  const { data, error } = await supabase
    .from('isa_categories')
    .select('*')
    .eq('is_active', true)
    .order('sort_order');
  if (error) return res.status(500).json({ error: error.message });

  // Build tree
  const roots = data.filter(c => !c.parent_id);
  roots.forEach(r => { r.children = data.filter(c => c.parent_id === r.id); });
  res.json(roots);
});

// ══════════════════════════════════════════════════════════════
// PRODUCTS
// ══════════════════════════════════════════════════════════════

app.get('/api/products', optionalAuth, async (req, res) => {
  const { category, search, brand, featured, limit = 24, page = 1, sort = 'created_at' } = req.query;
  const offset = (page - 1) * limit;
  const isWholesale = req.user?.is_approved && ['wholesale', 'distributor'].includes(req.user?.role);

  let query = supabase
    .from('isa_products')
    .select('id,sku,name_ru,name_kz,name_en,retail_price,wholesale_price,distributor_price,unit,volume,stock,images,is_featured,category_id,brand_id,isa_categories(name_ru,name_kz,name_en,slug),isa_brands(name)', { count: 'exact' })
    .eq('is_active', true);

  if (category) {
    // Find category and its children
    const { data: cats } = await supabase.from('isa_categories').select('id').or(`slug.eq.${category},parent_id.eq.(select id from categories where slug='${category}')`);
    const ids = cats?.map(c => c.id) || [];
    if (ids.length) query = query.in('category_id', ids);
  }
  if (search) query = query.or(`name_ru.ilike.%${search}%,name_en.ilike.%${search}%`);
  if (brand) query = query.eq('brand_id', brand);
  if (featured === 'true') query = query.eq('is_featured', true);

  query = query.order(sort === 'price_asc' ? 'retail_price' : sort === 'price_desc' ? 'retail_price' : 'created_at',
    { ascending: sort !== 'price_desc' }).range(offset, offset + Number(limit) - 1);

  const { data, error, count } = await query;
  if (error) return res.status(500).json({ error: error.message });

  // Hide wholesale prices if not logged in as approved wholesale
  const products = data.map(p => {
    if (!isWholesale) {
      const { wholesale_price, distributor_price, ...rest } = p;
      return rest;
    }
    return p;
  });

  res.json({ products, total: count, page: Number(page), limit: Number(limit) });
});

app.get('/api/products/:id', optionalAuth, async (req, res) => {
  const isWholesale = req.user?.is_approved && ['wholesale', 'distributor'].includes(req.user?.role);
  let select = 'id,sku,name_ru,name_kz,name_en,description_ru,description_kz,description_en,retail_price,unit,volume,weight,stock,images,tags,is_featured,category_id,brand_id,min_wholesale_qty,categories(*),brands(*)';
  if (isWholesale) select = select.replace('retail_price', 'retail_price,wholesale_price,distributor_price');

  const { data, error } = await supabase.from('isa_products').select(select).eq('id', req.params.id).single();
  if (error) return res.status(404).json({ error: 'Товар не найден' });
  res.json(data);
});

// ══════════════════════════════════════════════════════════════
// CART
// ══════════════════════════════════════════════════════════════

function getSessionId(req) {
  return req.cookies.session_id || `sess_${Date.now()}_${Math.random().toString(36).slice(2)}`;
}

app.get('/api/cart', optionalAuth, async (req, res) => {
  const sessionId = getSessionId(req);
  res.cookie('session_id', sessionId, { maxAge: 7 * 24 * 3600 * 1000 });

  let query = supabase.from('isa_cart_items').select('id,qty,products(id,name_ru,name_kz,retail_price,wholesale_price,images,unit,stock,isa_brands(name))');
  if (req.user) query = query.eq('user_id', req.user.id);
  else query = query.eq('session_id', sessionId);

  const { data, error } = await query;
  if (error) return res.status(500).json({ error: error.message });

  const isWholesale = req.user?.is_approved && ['wholesale', 'distributor'].includes(req.user?.role);
  const items = (data || []).map(item => ({
    ...item,
    price: isWholesale ? (item.products?.wholesale_price || item.products?.retail_price) : item.products?.retail_price
  }));
  res.json(items);
});

app.post('/api/cart', optionalAuth, async (req, res) => {
  const { product_id, qty = 1 } = req.body;
  const sessionId = getSessionId(req);
  res.cookie('session_id', sessionId, { maxAge: 7 * 24 * 3600 * 1000 });

  const upsertData = req.user
    ? { user_id: req.user.id, product_id, qty }
    : { session_id: sessionId, product_id, qty };

  const { error } = await supabase.from('isa_cart_items').upsert(upsertData, {
    onConflict: req.user ? 'user_id,product_id' : 'session_id,product_id'
  });
  if (error) return res.status(500).json({ error: error.message });
  res.json({ success: true });
});

app.put('/api/cart/:id', optionalAuth, async (req, res) => {
  const { qty } = req.body;
  if (qty <= 0) {
    await supabase.from('isa_cart_items').delete().eq('id', req.params.id);
    return res.json({ success: true });
  }
  const { error } = await supabase.from('isa_cart_items').update({ qty }).eq('id', req.params.id);
  if (error) return res.status(500).json({ error: error.message });
  res.json({ success: true });
});

app.delete('/api/cart/:id', async (req, res) => {
  const { error } = await supabase.from('isa_cart_items').delete().eq('id', req.params.id);
  if (error) return res.status(500).json({ error: error.message });
  res.json({ success: true });
});

// ══════════════════════════════════════════════════════════════
// ORDERS
// ══════════════════════════════════════════════════════════════

app.post('/api/orders', optionalAuth, async (req, res) => {
  const { name, phone, email, delivery_type, delivery_address, delivery_city, payment_method, notes, items } = req.body;

  if (!items?.length) return res.status(400).json({ error: 'Корзина пуста' });
  if (!phone || !name) return res.status(400).json({ error: 'Укажите имя и телефон' });

  const isWholesale = req.user?.is_approved && ['wholesale', 'distributor'].includes(req.user?.role);

  // Validate products & compute totals
  const productIds = items.map(i => i.product_id);
  const { data: products } = await supabase.from('isa_products').select('id,name_ru,retail_price,wholesale_price,stock').in('id', productIds);

  let subtotal = 0;
  const orderItems = items.map(item => {
    const product = products.find(p => p.id === item.product_id);
    if (!product) throw new Error(`Товар не найден`);
    const price = isWholesale ? (product.wholesale_price || product.retail_price) : product.retail_price;
    const total = price * item.qty;
    subtotal += total;
    return { product_id: item.product_id, product_name: product.name_ru, qty: item.qty, price, total };
  });

  // Wholesale minimum check
  if (isWholesale && subtotal < 250000) {
    return res.status(400).json({ error: 'Минимальная сумма оптового заказа: 250 000 ₸' });
  }

  const delivery_cost = delivery_type === 'pickup' ? 0 : delivery_type?.startsWith('almaty') ? 1500 : 3000;
  const total = subtotal + delivery_cost;

  const { data: order, error } = await supabase.from('isa_orders').insert({
    user_id: req.user?.id || null,
    guest_name: name, guest_phone: phone, guest_email: email,
    delivery_type, delivery_address, delivery_city,
    payment_method, notes, subtotal, delivery_cost, total,
    status: 'new', payment_status: 'pending'
  }).select().single();

  if (error) return res.status(500).json({ error: error.message });

  // Insert order items
  await supabase.from('isa_order_items').insert(orderItems.map(i => ({ ...i, order_id: order.id })));

  // Clear cart
  if (req.user) {
    await supabase.from('isa_cart_items').delete().eq('user_id', req.user.id);
  } else {
    const sessionId = req.cookies.session_id;
    if (sessionId) await supabase.from('isa_cart_items').delete().eq('session_id', sessionId);
  }

  // Telegram notification
  await sendTelegram(`🛒 <b>Новый заказ ${order.order_number}!</b>\n👤 ${name}\n📱 ${phone}\n💰 ${total.toLocaleString('ru')} ₸\n🚚 ${delivery_type}\n💳 ${payment_method}\n📦 Товаров: ${items.length}`);

  res.json({ success: true, order_id: order.id, order_number: order.order_number });
});

app.get('/api/orders/my', authMiddleware, async (req, res) => {
  const { data, error } = await supabase
    .from('isa_orders')
    .select('id,order_number,status,total,payment_method,created_at,isa_order_items(qty,product_name,price)')
    .eq('user_id', req.user.id)
    .order('created_at', { ascending: false });
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// ══════════════════════════════════════════════════════════════
// REVIEWS
// ══════════════════════════════════════════════════════════════

app.get('/api/products/:id/reviews', async (req, res) => {
  const { data } = await supabase.from('isa_reviews').select('id,name,rating,comment,created_at').eq('product_id', req.params.id).eq('is_approved', true).order('created_at', { ascending: false });
  res.json(data || []);
});

app.post('/api/products/:id/reviews', optionalAuth, async (req, res) => {
  const { rating, comment } = req.body;
  const name = req.user ? undefined : req.body.name;
  const { error } = await supabase.from('isa_reviews').insert({
    product_id: req.params.id, user_id: req.user?.id || null,
    name: name || req.body.name, rating, comment, is_approved: false
  });
  if (error) return res.status(500).json({ error: error.message });
  res.json({ success: true, message: 'Отзыв отправлен на модерацию' });
});

// ══════════════════════════════════════════════════════════════
// ADMIN ROUTES
// ══════════════════════════════════════════════════════════════

// Products CRUD
app.get('/api/admin/products', adminMiddleware, async (req, res) => {
  const { page = 1, limit = 20, search } = req.query;
  let query = supabase.from('isa_products').select('*,isa_categories(name_ru),isa_brands(name)', { count: 'exact' }).order('created_at', { ascending: false }).range((page - 1) * limit, page * limit - 1);
  if (search) query = query.ilike('name_ru', `%${search}%`);
  const { data, count } = await query;
  res.json({ products: data, total: count });
});

app.post('/api/admin/products', adminMiddleware, async (req, res) => {
  const { error, data } = await supabase.from('isa_products').insert(req.body).select().single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

app.put('/api/admin/products/:id', adminMiddleware, async (req, res) => {
  const { error, data } = await supabase.from('isa_products').update({ ...req.body, updated_at: new Date() }).eq('id', req.params.id).select().single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

app.delete('/api/admin/products/:id', adminMiddleware, async (req, res) => {
  const { error } = await supabase.from('isa_products').delete().eq('id', req.params.id);
  if (error) return res.status(500).json({ error: error.message });
  res.json({ success: true });
});

// Image upload
app.post('/api/admin/upload', adminMiddleware, upload.array('images', 5), (req, res) => {
  const urls = req.files.map(f => `/images/products/${f.filename}`);
  res.json({ urls });
});

// Orders
app.get('/api/admin/orders', adminMiddleware, async (req, res) => {
  const { status, page = 1, limit = 20 } = req.query;
  let query = supabase.from('isa_orders').select('*,isa_order_items(qty,product_name,price)', { count: 'exact' }).order('created_at', { ascending: false }).range((page - 1) * limit, page * limit - 1);
  if (status) query = query.eq('status', status);
  const { data, count } = await query;
  res.json({ orders: data, total: count });
});

app.put('/api/admin/orders/:id', adminMiddleware, async (req, res) => {
  const { data, error } = await supabase.from('isa_orders').update({ ...req.body, updated_at: new Date() }).eq('id', req.params.id).select().single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// Users
app.get('/api/admin/users', adminMiddleware, async (req, res) => {
  const { role, page = 1, limit = 20 } = req.query;
  let query = supabase.from('isa_users').select('id,name,email,phone,role,company,is_approved,is_active,created_at', { count: 'exact' }).order('created_at', { ascending: false }).range((page - 1) * limit, page * limit - 1);
  if (role) query = query.eq('role', role);
  const { data, count } = await query;
  res.json({ users: data, total: count });
});

app.put('/api/admin/users/:id/approve', adminMiddleware, async (req, res) => {
  const { data } = await supabase.from('isa_users').update({ is_approved: true }).eq('id', req.params.id).select().single();
  await sendTelegram(`✅ Оптовый клиент <b>${data.name}</b> одобрен!`);
  res.json({ success: true });
});

app.put('/api/admin/users/:id', adminMiddleware, async (req, res) => {
  const { error, data } = await supabase.from('isa_users').update(req.body).eq('id', req.params.id).select().single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// Dashboard stats
app.get('/api/admin/stats', adminMiddleware, async (req, res) => {
  const [orders, users, products] = await Promise.all([
    supabase.from('isa_orders').select('total,status,created_at'),
    supabase.from('isa_users').select('id,role,created_at'),
    supabase.from('isa_products').select('id,stock').eq('is_active', true)
  ]);

  const today = new Date().toISOString().slice(0, 10);
  const todayOrders = orders.data?.filter(o => o.created_at.slice(0, 10) === today) || [];

  res.json({
    total_orders: orders.data?.length || 0,
    total_revenue: orders.data?.filter(o => o.status !== 'cancelled').reduce((s, o) => s + Number(o.total), 0) || 0,
    today_orders: todayOrders.length,
    today_revenue: todayOrders.reduce((s, o) => s + Number(o.total), 0),
    total_users: users.data?.length || 0,
    pending_wholesale: users.data?.filter(u => ['wholesale', 'distributor'].includes(u.role) && !u.is_approved).length || 0,
    total_products: products.data?.length || 0,
    low_stock: products.data?.filter(p => p.stock < 10).length || 0
  });
});

// ── SPA fallback pages ────────────────────────────────────────
const pages = ['catalog', 'product', 'cart', 'checkout', 'login', 'register', 'account', 'wholesale', 'delivery', 'contacts', 'about'];
pages.forEach(page => {
  app.get(`/${page}`, (req, res) => res.sendFile(path.join(__dirname, `public/${page}.html`)));
  app.get(`/${page}.html`, (req, res) => res.sendFile(path.join(__dirname, `public/${page}.html`)));
});
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'public/admin/index.html')));

app.listen(PORT, () => console.log(`✨ ISA LUX Server running on http://localhost:${PORT}`));
