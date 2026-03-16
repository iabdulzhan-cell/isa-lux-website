// ISA LUX — Core App Logic

// ── API ──────────────────────────────────────────────────────
export async function api(method, url, body) {
  const res = await fetch(url, {
    method, headers: { 'Content-Type': 'application/json' },
    body: body ? JSON.stringify(body) : undefined,
    credentials: 'include'
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.error || 'Ошибка запроса');
  return data;
}

// ── Toast ─────────────────────────────────────────────────────
const icons = { success: '✅', error: '❌', warning: '⚠️', info: '💬' };
export function toast(msg, type = 'info', duration = 4000) {
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    document.body.appendChild(container);
  }
  const el = document.createElement('div');
  el.className = `toast ${type}`;
  el.innerHTML = `<span class="toast-icon">${icons[type]}</span><span class="toast-msg">${msg}</span><span class="toast-close">✕</span>`;
  el.querySelector('.toast-close').addEventListener('click', () => removeToast(el));
  container.appendChild(el);
  if (duration > 0) setTimeout(() => removeToast(el), duration);
  return el;
}
function removeToast(el) {
  el.style.animation = 'slideOut 0.3s ease forwards';
  setTimeout(() => el.remove(), 300);
}

// ── Auth ──────────────────────────────────────────────────────
let currentUser = null;

export async function getUser() {
  if (currentUser) return currentUser;
  try {
    currentUser = await api('GET', '/api/auth/me');
    return currentUser;
  } catch { return null; }
}

export async function logout() {
  await api('POST', '/api/auth/logout');
  currentUser = null;
  localStorage.removeItem('user');
  window.location.href = '/';
}

// ── Cart ──────────────────────────────────────────────────────
export async function getCart() {
  try { return await api('GET', '/api/cart'); }
  catch { return []; }
}

export async function addToCart(productId, qty = 1) {
  await api('POST', '/api/cart', { product_id: productId, qty });
  await updateCartBadge();
}

export async function updateCartBadge() {
  const items = await getCart();
  const count = items.reduce((s, i) => s + i.qty, 0);
  document.querySelectorAll('.cart-badge').forEach(el => {
    el.textContent = count;
    el.style.display = count > 0 ? 'flex' : 'none';
  });
  return count;
}

// ── Format ────────────────────────────────────────────────────
export function formatPrice(num) {
  return Number(num).toLocaleString('ru-KZ') + ' ₸';
}

// ── Header ────────────────────────────────────────────────────
export async function initHeader() {
  const header = document.getElementById('header');
  if (!header) return;

  // Scroll effect
  window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.scrollY > 50);
  });

  // Mobile menu
  const hamburger = header.querySelector('.hamburger');
  const nav = header.querySelector('.nav');
  hamburger?.addEventListener('click', () => {
    nav.classList.toggle('open');
    const spans = hamburger.querySelectorAll('span');
    spans[0].style.transform = nav.classList.contains('open') ? 'rotate(45deg) translate(5px, 5px)' : '';
    spans[1].style.opacity = nav.classList.contains('open') ? '0' : '';
    spans[2].style.transform = nav.classList.contains('open') ? 'rotate(-45deg) translate(5px, -5px)' : '';
  });

  // Active nav link
  const path = window.location.pathname;
  header.querySelectorAll('.nav a').forEach(a => {
    a.classList.toggle('active', a.getAttribute('href') === path || (path.includes('catalog') && a.getAttribute('href') === '/catalog'));
  });

  // Update cart badge
  await updateCartBadge();

  // Auth state
  const user = await getUser();
  const loginBtn = header.querySelector('#nav-login-btn');
  const accountBtn = header.querySelector('#nav-account-btn');
  if (user) {
    loginBtn && (loginBtn.style.display = 'none');
    if (accountBtn) {
      accountBtn.style.display = 'flex';
      accountBtn.title = user.name;
    }
  } else {
    loginBtn && (loginBtn.style.display = 'flex');
    accountBtn && (accountBtn.style.display = 'none');
  }
}

// ── Product Card ──────────────────────────────────────────────
export function renderProductCard(product, lang = 'ru') {
  const name = product[`name_${lang}`] || product.name_ru;
  const img = product.images?.[0] || null;
  const price = formatPrice(product.retail_price);
  const brand = product.brands?.name || '';
  const hasWholesale = product.wholesale_price;

  return `
    <div class="product-card" data-id="${product.id}">
      <div class="product-card-img">
        ${img
          ? `<img src="${img}" alt="${name}" loading="lazy">`
          : `<div class="product-card-img-placeholder">🧴</div>`}
        ${product.is_featured ? '<span class="product-badge badge-hot">Хит</span>' : ''}
      </div>
      <div class="product-card-body">
        ${brand ? `<div class="product-brand">${brand}</div>` : ''}
        <h4><a href="/product?id=${product.id}">${name}</a></h4>
        <div class="product-price">
          <span class="price-retail">${price}</span>
          <span class="price-unit">/ ${product.unit || 'шт'}</span>
        </div>
        ${hasWholesale
          ? `<div class="price-wholesale">Опт: ${formatPrice(product.wholesale_price)}</div>`
          : `<div class="price-login-hint" data-i18n="price_login">Войдите для оптовой цены</div>`}
      </div>
      <div class="product-card-footer" style="padding:0 20px 20px">
        <button class="btn-cart" onclick="addToCartHandler('${product.id}', this)">
          🛒 В корзину
        </button>
        <button class="btn-wishlist">♡</button>
      </div>
    </div>`;
}

// Global handler for add to cart
window.addToCartHandler = async (id, btn) => {
  try {
    btn.disabled = true;
    btn.textContent = '✓ Добавлено';
    await addToCart(id);
    toast('Товар добавлен в корзину!', 'success');
    setTimeout(() => { btn.disabled = false; btn.innerHTML = '🛒 В корзину'; }, 2000);
  } catch (e) {
    btn.disabled = false;
    btn.innerHTML = '🛒 В корзину';
    toast(e.message, 'error');
  }
};

// ── Logo SVG ──────────────────────────────────────────────────
export const logoSVG = `
<svg viewBox="0 0 42 42" fill="none" xmlns="http://www.w3.org/2000/svg" class="logo-icon">
  <circle cx="21" cy="21" r="8" stroke="#C9A84C" stroke-width="1.5"/>
  <circle cx="21" cy="13" r="8" stroke="#C9A84C" stroke-width="1"/>
  <circle cx="21" cy="29" r="8" stroke="#C9A84C" stroke-width="1"/>
  <circle cx="14" cy="17" r="8" stroke="#C9A84C" stroke-width="1"/>
  <circle cx="28" cy="17" r="8" stroke="#C9A84C" stroke-width="1"/>
  <circle cx="14" cy="25" r="8" stroke="#C9A84C" stroke-width="1"/>
  <circle cx="28" cy="25" r="8" stroke="#C9A84C" stroke-width="1"/>
  <circle cx="21" cy="21" r="4" stroke="#C9A84C" stroke-width="1.5"/>
  <path d="M21 18l1.5 2.5L21 24l-1.5-3.5L21 18z" fill="#C9A84C"/>
</svg>`;

export const headerHTML = `
<header id="header">
  <div class="container">
    <div class="header-inner">
      <a href="/" class="logo">
        ${logoSVG}
        <div class="logo-text">
          <span class="logo-name">ISA LUX</span>
          <span class="logo-tagline">Premium Cleaning</span>
        </div>
      </a>
      <nav class="nav">
        <a href="/catalog" data-i18n="nav_catalog">Каталог</a>
        <a href="/wholesale" data-i18n="nav_wholesale">Оптовикам</a>
        <a href="/delivery" data-i18n="nav_delivery">Доставка</a>
        <a href="/contacts" data-i18n="nav_contacts">Контакты</a>
      </nav>
      <div class="header-actions">
        <div class="lang-switcher">
          <button class="lang-btn" data-lang="ru">RU</button>
          <button class="lang-btn" data-lang="kz">KZ</button>
          <button class="lang-btn" data-lang="en">EN</button>
        </div>
        <a href="/catalog?search=" class="header-icon-btn" title="Поиск">🔍</a>
        <a href="/cart" class="header-icon-btn" title="Корзина">
          🛒
          <span class="badge cart-badge" style="display:none">0</span>
        </a>
        <a href="/login" class="header-icon-btn" id="nav-login-btn" title="Войти">👤</a>
        <a href="/account" class="header-icon-btn" id="nav-account-btn" style="display:none" title="Кабинет">👤</a>
        <button class="hamburger" aria-label="Menu">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </div>
</header>`;

export const footerHTML = `
<footer id="footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <a href="/" class="logo">
          ${logoSVG}
          <div class="logo-text">
            <span class="logo-name">ISA LUX</span>
            <span class="logo-tagline">Premium Cleaning</span>
          </div>
        </a>
        <p data-i18n="footer_tagline">Премиум средства для уборки. Казахстан.</p>
        <div class="social-links" style="margin-top:20px">
          <a href="#" class="social-link">📘</a>
          <a href="#" class="social-link">📷</a>
          <a href="#" class="social-link">📱</a>
          <a href="#" class="social-link">▶️</a>
        </div>
      </div>
      <div class="footer-col">
        <h5 data-i18n="footer_catalog">Каталог</h5>
        <a href="/catalog?cat=cleaning-chemicals">Химия для уборки</a>
        <a href="/catalog?cat=paper-supplies">Бумажные расходники</a>
        <a href="/catalog?cat=cleaning-inventory">Инвентарь</a>
        <a href="/catalog?cat=hygiene-products">Гигиена</a>
      </div>
      <div class="footer-col">
        <h5>Компания</h5>
        <a href="/about">О нас</a>
        <a href="/wholesale" data-i18n="footer_wholesale">Оптовикам</a>
        <a href="/delivery" data-i18n="footer_delivery">Доставка</a>
        <a href="/contacts" data-i18n="footer_contacts">Контакты</a>
      </div>
      <div class="footer-col">
        <h5>Контакты</h5>
        <div class="footer-contact">
          <div class="footer-contact-item">
            <span>📱</span><span>+7 (777) 000-00-00</span>
          </div>
          <div class="footer-contact-item">
            <span>📧</span><span>info@isalux.kz</span>
          </div>
          <div class="footer-contact-item">
            <span>📍</span><span>Алматы, ул. Алтынсарина</span>
          </div>
          <div class="footer-contact-item">
            <span>⏰</span><span>Пн-Сб: 9:00-18:00</span>
          </div>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p data-i18n="footer_copy">© 2024 ISA LUX. Все права защищены.</p>
      <a href="/privacy" style="font-size:0.8rem;color:rgba(255,255,255,0.3)">Политика конфиденциальности</a>
    </div>
  </div>
</footer>`;

// ── Init Page ─────────────────────────────────────────────────
export async function initPage() {
  // Inject header & footer
  const headerEl = document.getElementById('header-placeholder');
  if (headerEl) headerEl.outerHTML = headerHTML;

  const footerEl = document.getElementById('footer-placeholder');
  if (footerEl) footerEl.outerHTML = footerHTML;

  // Init i18n
  if (window.i18n) window.i18n.initI18n();

  // Init header
  await initHeader();
}
