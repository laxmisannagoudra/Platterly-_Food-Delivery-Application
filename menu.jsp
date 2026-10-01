<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Menu"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // not logged in: the menu can still be viewed, but remember this page so login brings the user back here
    if (session.getAttribute("userName") == null) {
        String fwdUri = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
        String fwdQs  = (String) request.getAttribute("jakarta.servlet.forward.query_string");
        String target = (fwdUri != null) ? fwdUri : request.getRequestURI();
        String qs     = (fwdUri != null) ? fwdQs  : request.getQueryString();
        if (qs != null) target += "?" + qs;
        session.setAttribute("afterLogin", target);
    }
%>


<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Platterly - Menu</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f5f5f5;
        }

        nav {
            background-color: white;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 max(5%, calc((100% - 1200px) / 2));
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 30px;
            font-weight: bold;
            color: #ff6b00;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 30px;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }

        .nav-links a:hover {
            color: #ff6b00;
        }

        /* RESTAURANT HERO */

        .rest-hero {
            position: relative;
            overflow: hidden;
            color: white;
            background-color: #1f1b16;
            padding: 90px max(5%, calc((100% - 1200px) / 2)) 44px;
        }

        /* blurred, darkened copy of the restaurant image as the backdrop */
        .rest-hero-bg {
            position: absolute;
            inset: -40px;
            background-size: cover;
            background-position: center;
            filter: blur(28px) brightness(0.5);
        }

        .rest-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 40px;
            min-height: 290px;
        }

        .rest-info {
            flex: 1;
            min-width: 0;
        }

        /* the restaurant image itself, shown in a framed card */
        .rest-photo {
            flex: 0 0 auto;
            width: min(46%, 480px);
            height: 290px;
            object-fit: cover;
            border-radius: 18px;
            border: 3px solid rgba(255,255,255,0.85);
            box-shadow: 0 18px 40px rgba(0,0,0,0.45);
            background: #fff;
        }

        .rest-hero .back {
            position: absolute;
            z-index: 2;
            top: 24px;
            left: max(5%, calc((100% - 1200px) / 2));
            color: white;
            text-decoration: none;
            font-weight: bold;
            background: rgba(255,255,255,0.16);
            border: 1px solid rgba(255,255,255,0.4);
            padding: 8px 16px;
            border-radius: 30px;
        }

        .rest-hero .back:hover {
            background: #ff6b00;
            border-color: #ff6b00;
        }

        .rest-hero h1 {
            font-size: clamp(32px, 5vw, 52px);
            margin-bottom: 12px;
            text-shadow: 0 2px 14px rgba(0,0,0,0.45);
        }

        .rest-meta {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px 18px;
            font-size: 15.5px;
        }

        .rest-meta .rate {
            background: #0a8a3f;
            padding: 4px 11px;
            border-radius: 6px;
            font-weight: bold;
        }

        /* MENU */

        .page-heading {
            text-align: center;
            margin: 45px 20px 30px;
        }

        .page-heading h1 {
            font-size: 35px;
            color: #222;
        }

        .page-heading p {
            color: #777;
            margin-top: 10px;
        }

        .menu-container {
            width: 90%;
            max-width: 1200px;
            margin: auto;

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 25px;

            padding-bottom: 50px;
        }

        .menu-card {
            background: white;
            border-radius: 18px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            box-shadow: 0 2px 10px rgba(31,27,22,0.08);
            transition: transform .25s ease, box-shadow .25s ease;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 18px 34px -14px rgba(31,27,22,0.28);
        }

        .menu-img-wrap {
            height: 190px;
            overflow: hidden;
            background: #efe9e1;
        }

        .menu-card img.menu-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform .4s;
        }

        .menu-card:hover img.menu-img {
            transform: scale(1.06);
        }

        .menu-body {
            padding: 16px 18px 18px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .menu-body h2 {
            font-size: 18.5px;
            color: #1f1b16;
            margin-bottom: 6px;
        }

        .menu-desc {
            color: #6b6058;
            font-size: 14px;
            line-height: 1.5;
            min-height: 42px;
            margin-bottom: 16px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .menu-foot {
            margin-top: auto;
            padding-top: 14px;
            border-top: 1px dashed #ede7de;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .price {
            font-size: 20px;
            font-weight: 800;
            color: #1f1b16;
        }

        .add-btn {
            background: white;
            color: #ff6b00;
            border: 1.5px solid #ff6b00;
            padding: 9px 28px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: 0.4px;
            cursor: pointer;
            transition: background .2s, color .2s;
        }

        .add-btn:hover {
            background: #ff6b00;
            color: white;
        }

        .add-btn:focus-visible {
            outline: 3px solid rgba(255,107,0,0.4);
            outline-offset: 2px;
        }

        .menu-empty {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            color: #777;
        }


        /* ---- Blinkit-style quantity stepper ---- */
        .qty-slot .stepper { display: none; }
        .qty-slot.in-cart .stepper { display: inline-flex; }
        .qty-slot.in-cart .add-btn { display: none; }

        .stepper {
            align-items: center;
            background: #ff6b00;
            border-radius: 8px;
            overflow: hidden;
        }
        .stepper button {
            background: transparent;
            color: white;
            border: none;
            width: 34px;
            height: 36px;
            font-size: 20px;
            font-weight: 800;
            cursor: pointer;
        }
        .stepper button:hover { background: rgba(0,0,0,0.15); }
        .stepper .q {
            min-width: 28px;
            text-align: center;
            color: white;
            font-weight: 800;
            font-size: 15px;
        }

        /* ---- "please login" popup ---- */
        .login-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,0.55);
            display: none; align-items: center; justify-content: center; z-index: 200; padding: 20px;
        }
        .login-overlay.show { display: flex; }
        .login-box {
            background: #fff; border-radius: 18px; padding: 30px 28px; max-width: 380px; width: 100%;
            text-align: center; box-shadow: 0 20px 50px rgba(0,0,0,0.35);
        }
        .login-box .lock { font-size: 42px; margin-bottom: 8px; }
        .login-box h3 { font-size: 22px; margin-bottom: 8px; color: #1f1b16; }
        .login-box p { color: #6b6058; font-size: 15px; line-height: 1.5; margin-bottom: 22px; }
        .login-box .btns { display: flex; gap: 10px; }
        .login-box .btns a, .login-box .btns button {
            flex: 1; padding: 12px; border-radius: 10px; font-weight: 700; font-size: 15px;
            cursor: pointer; text-decoration: none; text-align: center; border: none;
        }
        .login-box .btns a { background: #ff6b00; color: #fff; }
        .login-box .btns button { background: #f1ece5; color: #333; }

        /* ---- floating cart bar ---- */
        .cart-bar {
            position: fixed;
            left: 50%;
            bottom: 18px;
            transform: translate(-50%, 140%);
            transition: transform .3s ease;
            width: min(92%, 560px);
            background: #0a8a3f;
            color: white;
            border-radius: 14px;
            padding: 14px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            text-decoration: none;
            font-weight: bold;
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
            z-index: 50;
        }
        .cart-bar.show { transform: translate(-50%, 0); }
        body.has-bar { padding-bottom: 80px; }

        .nav-badge {
            background: #ff6b00;
            color: white;
            border-radius: 20px;
            padding: 1px 8px;
            font-size: 12px;
            margin-left: 4px;
        }
        .nav-badge:empty { display: none; }

        footer {
            background-color: #222;
            color: white;
            text-align: center;
            padding: 25px;
        }

        footer span {
            color: #ff6b00;
            font-weight: bold;
        }

        @media (max-width: 950px) {

            .menu-container {
                grid-template-columns:
                    repeat(2, 1fr);
            }

        }

        @media (max-width: 800px) {

            .rest-hero {
                padding-top: 80px;
                padding-bottom: 30px;
            }

            .rest-hero-inner {
                flex-direction: column-reverse;
                align-items: flex-start;
                min-height: 0;
            }

            .rest-photo {
                width: 100%;
                height: 200px;
            }

        }

        @media (max-width: 600px) {

            .menu-container {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>


<body>

<%
    // read what is already in the cart (all restaurants) so the menu can show it
    Cart sessCart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> cartItems = (sessCart != null) ? sessCart.getItems() : null;
    int cartCount = 0;
    double cartTotal = 0;
    if (cartItems != null) {
        for (CartItem ci : cartItems.values()) {
            cartCount += ci.getQty();
            cartTotal += ci.getTotalPrice();
        }
    }
%>


<!-- NAVBAR -->

<nav>

    

    <a href="home.jsp" class="logo">
        Platterly
    </a>

    <div class="nav-links">

        <a href="home.jsp">
            Home
        </a>

        <a href="restaurant">
            Restaurants
        </a>

        <a href="myorders">
            My Orders
        </a>

        <a href="cart.jsp">
            &#128722; Cart <span class="nav-badge" id="navBadge"><%= cartCount > 0 ? cartCount : "" %></span>
        </a>

        <%
    // shows "Login" when logged out, or a user icon + name dropdown when logged in
    String _umName = (String) session.getAttribute("userName");
    String _umCtx = request.getContextPath();
    if (_umName != null) {
        _umName = _umName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<style>
    .um { position:relative; display:inline-block; }
    .um-btn { display:inline-flex; align-items:center; gap:8px; background:rgba(255,107,0,0.12); color:inherit;
        border:1px solid rgba(255,107,0,0.5); border-radius:999px; padding:6px 14px 6px 8px; font:inherit;
        font-weight:700; font-size:15px; cursor:pointer; }
    .um-avatar { width:28px; height:28px; border-radius:50%; background:#ff6b00; color:#fff; display:inline-flex;
        align-items:center; justify-content:center; font-size:15px; }
    .um-drop { display:none; position:absolute; right:0; top:100%; padding-top:8px; min-width:170px; z-index:100; }
    .um-drop-in { background:#fff; border-radius:12px; box-shadow:0 14px 34px rgba(0,0,0,0.25); overflow:hidden; }
    .um:hover .um-drop, .um:focus-within .um-drop { display:block; }
    .um-drop a { display:block; padding:12px 18px; color:#1f1b16 !important; opacity:1 !important; font-weight:600;
        font-size:14.5px; text-decoration:none !important; }
    .um-drop a:hover { background:#fff3e8; color:#ff6b00 !important; }
</style>
<% if (_umName != null) { %>
    <div class="um">
        <button type="button" class="um-btn" aria-haspopup="true">
            <span class="um-avatar">&#128100;</span><span><%= _umName %></span> &#9662;
        </button>
        <div class="um-drop"><div class="um-drop-in">
            <a href="<%= _umCtx %>/myorders">My Orders</a>
            <a href="<%= _umCtx %>/logout">Logout</a>
        </div></div>
    </div>
<% } else { %>
    <a href="<%= _umCtx %>/register.html">Login</a>
<% } %>

    </div>

</nav>

<!-- RESTAURANT HERO -->

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");

    String rName  = (restaurant != null) ? restaurant.getName() : "Our Menu";
    String rImage = (restaurant != null && restaurant.getImageUrl() != null && !restaurant.getImageUrl().isEmpty())
            ? restaurant.getImageUrl()
            : "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=85";

    // some restaurants store "40", others "20-30 min": only add "mins" when there is no unit already
    String rTime = "";
    if (restaurant != null && restaurant.getDeliveryTime() != null) {
        String dt = restaurant.getDeliveryTime().trim();
        rTime = dt.matches(".*[A-Za-z].*") ? dt : dt + " mins";
    }
%>

<section class="rest-hero">

    <div class="rest-hero-bg" style="background-image: url('<%= rImage %>');"></div>

    <a class="back" href="restaurant">&larr; Back to restaurants</a>

    <div class="rest-hero-inner">

        <div class="rest-info">
            <h1><%= rName %></h1>

            <% if (restaurant != null) { %>
            <div class="rest-meta">
                <span class="rate">&#11088; <%= restaurant.getRating() %></span>
                <span><%= restaurant.getCuisine() %></span>
                <span><%= rTime %></span>
                <span>&#128205; <%= restaurant.getAddress() %></span>
            </div>
            <% } %>
        </div>

        <img class="rest-photo" src="<%= rImage %>" alt="<%= rName %>">

    </div>

</section>


<!-- HEADING -->

<div class="page-heading">

    <h1>
        Our Menu
    </h1>

    <p>
        Choose your favourite food
    </p>

</div>


<!-- MENU ITEMS -->

<div class="menu-container">

<%
    List<Menu> allMenusByRestaurant =
        (List<Menu>) request.getAttribute("allMenusByRestaurant");

    if (allMenusByRestaurant != null && !allMenusByRestaurant.isEmpty()) {

        for (Menu menu : allMenusByRestaurant) {
%>

    <div class="menu-card">

        <div class="menu-img-wrap">
            <img
                src="<%= menu.getImageUrl() != null ? menu.getImageUrl() : "https://via.placeholder.com/400x250?text=No+Image" %>"
                alt="<%= menu.getItemName() %>"
                class="menu-img">
        </div>

        <div class="menu-body">

            <h2><%= menu.getItemName() %></h2>

            <p class="menu-desc"><%= menu.getDescription() %></p>

            <div class="menu-foot">

                <span class="price">&#8377;<%= menu.getPrice() %></span>

                <%
                    CartItem inCart = (cartItems != null) ? cartItems.get(menu.getMenuId()) : null;
                    int q = (inCart != null) ? inCart.getQty() : 0;
                %>
                <div class="qty-slot<%= q > 0 ? " in-cart" : "" %>"
                     data-menu-id="<%= menu.getMenuId() %>"
                     data-restaurant-id="<%= menu.getRestaurantId() %>"
                     data-price="<%= menu.getPrice() %>"
                     data-qty="<%= q %>">
                    <button type="button" class="add-btn" data-act="inc">ADD</button>
                    <div class="stepper">
                        <button type="button" data-act="dec" aria-label="Decrease">&minus;</button>
                        <span class="q"><%= q %></span>
                        <button type="button" data-act="inc" aria-label="Increase">+</button>
                    </div>
                </div>

            </div>

        </div>

    </div>

<%
        }

    } else {
%>

    <div class="menu-empty">
        <h3>No items available right now</h3>
        <p>Please check back soon, or try another restaurant.</p>
    </div>

<%
    }
%>

</div>


<footer>

    <p>

        © 2026

        <span>
            Platterly
        </span>

        | Delicious food delivered to you

    </p>

</footer>


<div class="login-overlay" id="loginOverlay" role="dialog" aria-modal="true" aria-labelledby="loginTitle">
    <div class="login-box">
        <div class="lock">&#128274;</div>
        <h3 id="loginTitle">Please login first</h3>
        <p>Before ordering, you need to login to your account.</p>
        <div class="btns">
            <button type="button" id="loginCancel">Not now</button>
            <a href="<%= request.getContextPath() %>/login.html">Login</a>
        </div>
    </div>
</div>

<a href="cart.jsp" class="cart-bar" id="cartBar">
    <span id="barText"></span>
    <span>View cart &rarr;</span>
</a>

<script>
(function () {
    var count = <%= cartCount %>;
    var loggedIn = <%= session.getAttribute("userName") != null %>;
    var overlay = document.getElementById('loginOverlay');
    document.getElementById('loginCancel').addEventListener('click', function () { overlay.classList.remove('show'); });
    overlay.addEventListener('click', function (e) { if (e.target === overlay) overlay.classList.remove('show'); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') overlay.classList.remove('show'); });
    var total = <%= cartTotal %>;
    var bar = document.getElementById('cartBar');
    var barText = document.getElementById('barText');
    var badge = document.getElementById('navBadge');

    function money(n) { return '\u20B9' + (+n.toFixed(2)); }

    function refreshBar() {
        badge.textContent = count > 0 ? count : '';
        if (count > 0) {
            barText.textContent = count + (count === 1 ? ' item' : ' items') + '  |  ' + money(total);
            bar.classList.add('show');
            document.body.classList.add('has-bar');
        } else {
            bar.classList.remove('show');
            document.body.classList.remove('has-bar');
        }
    }

    // send changes to CartServlet one at a time, in order
    var queue = Promise.resolve();
    function send(params) {
        queue = queue.then(function () {
            return fetch('CartServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'fetch' },
                body: new URLSearchParams(params).toString(),
                credentials: 'same-origin'
            });
        }).catch(function () { location.reload(); });
    }

    function render(slot, q) {
        slot.dataset.qty = q;
        slot.querySelector('.q').textContent = q;
        slot.classList.toggle('in-cart', q > 0);
    }

    document.querySelectorAll('.qty-slot').forEach(function (slot) {
        slot.addEventListener('click', function (e) {
            var btn = e.target.closest('button[data-act]');
            if (!btn) return;

            if (!loggedIn) {                 // not logged in: ask the user to login first
                overlay.classList.add('show');
                return;
            }

            var id = slot.dataset.menuId;
            var price = parseFloat(slot.dataset.price) || 0;
            var q = parseInt(slot.dataset.qty, 10) || 0;

            if (btn.dataset.act === 'inc') {
                if (q === 0) send({ action: 'add', menuId: id, restaurantId: slot.dataset.restaurantId, qty: 1 });
                else         send({ action: 'update', menuId: id, qty: q + 1 });
                q++; count++; total += price;
            } else {
                if (q <= 0) return;
                if (q === 1) send({ action: 'remove', menuId: id });
                else         send({ action: 'update', menuId: id, qty: q - 1 });
                q--; count--; total -= price;
            }
            render(slot, q);
            refreshBar();
        });
    });

    // Back button from cart: reload so quantities are always current
    window.addEventListener('pageshow', function (e) {
        if (e.persisted) location.reload();
    });

    refreshBar();
})();
</script>

</body>

</html>
